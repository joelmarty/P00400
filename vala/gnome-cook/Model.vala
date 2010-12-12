/* Application.vala
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
 
using gnomecook.Domain;
using gnomecook.DAO;
using Gee;

namespace gnomecook.model {

  public class Model : GLib.Object {
  
    private MealDAO dao = null;
    private Gee.List<Meal> models = null;
    
    //public Meal current_meal {get;set;}
  
    public Model() {

      try {
        dao = MealDAO.get_instance();
	      models = dao.get_all();
	    } catch (DAOError.E_OPEN e) {
	      GLib.debug("error opening database!");
	      GLib.debug(e.message);
	    } catch (DAOError.E_SQL e) {
	      GLib.debug("error loading data from db!");
	      GLib.debug(e.message);
	    } catch (DAOError.E_TYPE e) {
	      GLib.debug("error loading row, invalid type!");
	      GLib.debug(e.message);
	    } catch (Error e) {
	      GLib.debug("error: %s ", e.message);
	    }
    }
    
    public void add(Meal m) {
      
      try {
        if(m != null) {
          dao.add(m);
          models.add(m);
        }
      } catch (DAOError e) {
        GLib.debug("failed to add new meal: %s", e.message);  
      }
    }
    
    public void update(Meal m) {
      
      try {
        if(m != null) {
          dao.update(m);
        }
        this.models = get_all();
      } catch (DAOError e) {
        GLib.debug("failed to update model: %s", e.message);
      }
    }
    
    public void del(Meal m) {
      GLib.debug("Model.del()");
      
      try {
        if(m != null) {
          dao.del(m);
          models.remove(m);
        }
      } catch (DAOError e) {
        GLib.debug("failed to delete model: %s", e.message);
      }
      
    }
    
    public Gee.List<Meal> get_all() {
      models = dao.get_all();
      return models;
    }
    
    public Meal get_one(int64 id) {

      Meal val = null;
      
      foreach(Meal m in models) {
        if(m.id == id)
          val = m;
      }
      
      return val;
    }
  }
  
}