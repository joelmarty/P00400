/* DAO.vala
 *
 * Copyright (C) 2010  Joel Marty
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *  
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *  
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * Author:
 * 	Joel Marty <10093745@brookes.ac.uk>
 */
 
 using GLib;
 //using Posix;
 using Sqlite;
 using gnomecook.Domain;
 using gnomecook.ui;
 
 namespace gnomecook.DAO {
 
 public errordomain DAOError {
  E_OPEN,
  E_SQL,
  E_TYPE
 } 
 
 	public interface DAOInterface<T> : GLib.Object {
 	  
 		public static Database connect() throws DAOError.E_OPEN {
 			Database _db = null;
 			int rc = 0;
      
 			if(!FileUtils.test("data/cook.db", FileTest.IS_REGULAR))
 				throw new DAOError.E_OPEN("Database not found");
 			else
 				rc = Sqlite.Database.open_v2("data/cook.db", out _db, Sqlite.OPEN_READWRITE | Sqlite.OPEN_CREATE, null);
 			
 			if (rc != Sqlite.OK)
 			  throw new DAOError.E_OPEN("Error opening the database, code is " + rc.to_string() + ": " + _db.errmsg());

 			return _db;
 		}

 		public abstract T get_one (int64 id) throws DAOError;
 		
 		public abstract Gee.List<T> get_all() throws DAOError;
 		
 		public abstract void add(T obj) throws DAOError;
 		
 		public abstract void update(T obj) throws DAOError;
 		
 		public abstract void del(T obj) throws DAOError;
 	}
 	
 	public class MealDAO : GLib.Object, DAOInterface<Meal> {
 	  
 	  private static MealDAO _instance;
 	  private Database _db;
 	  
 	  public static MealDAO get_instance() throws DAOError.E_OPEN {
 	    GLib.debug("MealDAO.get_instance()");
 	  
 	    if (_instance == null) {
 	      try {
 	        _instance = new MealDAO();
 	      } catch (DAOError.E_OPEN e) {
 	        throw e;
 	      }
 	    }
 	    return _instance;
 	  }
 	  
 	  private MealDAO() throws DAOError.E_OPEN {
 	  
 	    try {
        this._db = this.connect();
      } catch (DAOError.E_OPEN e) {
        throw e;
      }
 	  }
 	
 	  public Meal get_one(int64 id) throws DAOError.E_SQL, DAOError.E_TYPE {
 	    
 	    string qry = "SELECT id, name, cooking_time, instructions, rating, ingredients " +
 	                 "FROM meals WHERE id = ?";
 	    Statement stmt;
 	    
 	    int res = _db.prepare_v2(qry,-1, out stmt);
 	    
 	    stmt.bind_int64(1, id);
 	    assert(res == Sqlite.OK);

 	    res = stmt.step();
 	    if(res != Sqlite.ROW) {
 	      throw new DAOError.E_SQL("Fetching meal " + id.to_string() + " failed");
 	    }

 	    Meal m = new Meal();

      m.id = stmt.column_int64(0);
      m.name = stmt.column_text(1);
      m.cooking_time = stmt.column_value(2).to_double();
      m.instructions = stmt.column_text(3);
      m.rating = stmt.column_value(4).to_double();
      m.ingredients = stmt.column_text(5);
 	    
 	    return m;
 	  }

 	  public Gee.List<Meal> get_all() throws DAOError {
 	  
 	    string qry = "SELECT id, name, cooking_time, instructions, rating, ingredients FROM meals;";
 	    Gee.List<Meal> meals = new Gee.ArrayList<Meal>();
 	    Statement stmt;
 	    
 	    int res = _db.prepare_v2(qry,-1,out stmt);
 	    if (res != Sqlite.OK)
 	      throw new DAOError.E_SQL("preparing statement: " + _db.errmsg());
 	    
 	    for(;;) {
 	      res = stmt.step();
        if (res == Sqlite.DONE)
          break;
        else if (res != Sqlite.ROW)
          throw new DAOError.E_SQL("error fetching row:" + _db.errmsg());
        
        Meal m = new Meal();

        m.id = stmt.column_int64(0);
        m.name = stmt.column_text(1);
        m.cooking_time = stmt.column_value(2).to_double();
        m.instructions = stmt.column_text(3);
        m.rating = stmt.column_value(4).to_double();
        m.ingredients = stmt.column_text(5);
 
 	      meals.add(m);
 	    }
 	    
 	    return meals;
 	  }
 	  
 	  public void add(Meal m) throws DAOError {
 	    
 	    string qry = "INSERT INTO meals " +
 	                               "(name, " +
 	                               "cooking_time, " +
 	                               "instructions, " +
 	                               "rating, " +
 	                               "ingredients) VALUES(?,?,?,?,?)";
 	    
 	    Sqlite.Statement stmt;
 	    
 	    int res = _db.prepare_v2(qry, -1, out stmt);  
 	    
 	    if (res != Sqlite.OK)
 	      throw new DAOError.E_SQL(_db.errmsg());
 	    
 	    res = stmt.bind_text(1,m.name);
      assert(res == Sqlite.OK);
 	    res = stmt.bind_double(2,m.cooking_time);
 	    assert(res == Sqlite.OK);
 	    res = stmt.bind_text(3,m.instructions);
 	    assert(res == Sqlite.OK);
 	    res = stmt.bind_double(4, m.rating);
 	    assert(res == Sqlite.OK);
 	    res = stmt.bind_text(5, m.ingredients);
 	    assert(res == Sqlite.OK);
 	    
 	    res = stmt.step();
 	    
 	    if(res != Sqlite.DONE)
 	      throw new DAOError.E_SQL(_db.errmsg());
 	    
 	  }
 	  
 	  public void update(Meal m) throws DAOError {
 	  
 	    string qry = "UPDATE meals SET " +
 	                               "name = ?, " +
 	                               "cooking_time = ?, " +
 	                               "instructions = ?, " +
 	                               "rating = ?, " +
 	                               "ingredients = ? " +
 	                               "where id = ? ;";
 	  
 	    Sqlite.Statement stmt;
 	    
 	    int res = _db.prepare_v2(qry, -1, out stmt);  
 	    
 	    if (res != Sqlite.OK)
 	      throw new DAOError.E_SQL(_db.errmsg());
 	    
 	    res = stmt.bind_text(1,m.name);
 	    res = stmt.bind_double(2,m.cooking_time);
 	    res = stmt.bind_text(3,m.instructions);
 	    res = stmt.bind_double(4, m.rating);
 	    res = stmt.bind_text(5, m.ingredients);
 	    res = stmt.bind_int64(6, m.id);

 	    res = stmt.step();
 	    
 	    if(res != Sqlite.DONE)
 	      throw new DAOError.E_SQL(_db.errmsg());
 	  }
 	  
 	  public void del(Meal m) throws DAOError {
 	  
 	    string qry = "DELETE FROM meals WHERE id = ?;";
 	  
 	    Sqlite.Statement stmt;
 	    
 	    int res = _db.prepare_v2(qry, -1, out stmt);  
 	    
 	    if (res != Sqlite.OK)
 	      throw new DAOError.E_SQL(_db.errmsg());
 	    
 	    res = stmt.bind_int64(1,m.id);
 	    assert(res == Sqlite.OK);

 	    res = stmt.step();
 	    
 	    if(res != Sqlite.DONE)
 	      throw new DAOError.E_SQL(_db.errmsg());
 	  }

 	}
 }
