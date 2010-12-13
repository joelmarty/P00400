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

using GLib;
using Gtk;
using gnomecook.Domain;
using gnomecook.DAO;
using gnomecook.model;

namespace gnomecook.ui {

  public class Application : GLib.Object {

    private Window window = null;
    private Builder builder = null;
    
    // recipe list objects
    private TreeView recipe_list = null;
    private ListStore recipe_store = null;
    private TreeViewColumn name_column = null;
    private CellRendererText name_renderer = null;
   
    // Model
    Model model = null;
    
    // keep a reference to the currently edited meal
    //Meal current_meal = null;

    public Application(string[] args) {
      
      builder = new Builder();
      Gtk.init(ref args);
      
      try {
        this.on_fatal.connect((t) => {Gtk.main_quit();});
        this.on_error.connect((t,text) => {this.show_error_dialog(text);});
        builder.add_from_file ("data/ui/recipes.glade");
        builder.connect_signals(this);
        this.window = builder.get_object("gnomecook") as Window;
        
        model = new Model();
        
        init_list_store();
        populate_recipe_list();
        
        window.show_all();
        Gtk.main();
      }
      catch (DAOError e) {
      }
      catch (Error e) {
        GLib.debug ("Could not load UI: %s", e.message);
      }
      
      
    }

    public static void on_destroy() {
      Gtk.main_quit();
	  }
	  
	  private void init_list_store() {
	  
	    // creating cell renderer
	    name_renderer = new CellRendererText();
	    name_renderer.set_property("editable", false);
	    
	    // creating columns
	    name_column = new TreeViewColumn();
	    name_column.pack_start(name_renderer, true);
	    name_column.set_title("Recipe");
	    name_column.add_attribute(name_renderer, "text", 1);
	    
	    // creating ListStore
	    this.recipe_store = new Gtk.ListStore(2, typeof(int64),typeof(string));
	    
	    // getting object from view and building
	    recipe_list = builder.get_object("recipelist") as Gtk.TreeView;
	    recipe_list.append_column(name_column);

	    
	    // signal connection
	    recipe_list.row_activated.connect(on_recipe_selected);
	    
	  }
	  
	  public void populate_recipe_list() {
	    
	    TreeIter iter;

      Gee.List<Meal> meals = model.get_all();
      GLib.debug("got %d meals from db", meals.size );
      
      if(recipe_store.length != 0) {
        GLib.debug("clearing store");
        recipe_store.clear();
      }
      
	    foreach(Meal m in meals) {
        recipe_store.append(out iter);
	      recipe_store.set(iter, 0, m.id, 1, m.name);
	    }
	    
	    recipe_list.set_model(recipe_store);
	  }
	  
	  public void on_recipe_selected(Gtk.TreeView sender, Gtk.TreePath path, Gtk.TreeViewColumn column) {
	  
	    Meal current_meal;
	    
	    // getting objects from view
	    TreeIter iter;
	    TreeSelection selected_row = sender.get_selection();
	    TreeModel? treemodel;
	    
	    // getting selected row
	    selected_row.get_selected(out treemodel, out iter);
      
      Value col0;
      
      // getting column 0 value (meal id)
      treemodel.get_value(iter, 0, out col0);
      
      // updating model
      if(col0.get_int64() != 0) {
        current_meal = model.get_one(col0.get_int64());
      } else {
        current_meal = new Meal();
      }
      
      // updating rate widget
      Adjustment rate_adj = builder.get_object("rateadjustment") as Adjustment;
      rate_adj.value = current_meal.rating;
      
      // updating recipe name
      Entry name_text = builder.get_object("nameentry") as Entry;
      name_text.text = current_meal.name;
      
      // updating ingredient list
      TextBuffer ing_text = new TextBuffer(null);
      ing_text.set_text(current_meal.ingredients);
      TextView ing_view = builder.get_object("ingredientview") as TextView;
      
      // updating recipe text
      TextBuffer rec_text = new TextBuffer(null);
      rec_text.set_text(current_meal.instructions);
      TextView rec_view = builder.get_object("recipeview") as TextView;
      
      // updating text buffers for view
      ing_view.set_buffer(ing_text);
      rec_view.set_buffer(rec_text);
      
	  }
	  
	  [CCode (instance_pos = -1)]
	  public void on_recipe_add(Action sender) {
	  
	    // iterator for appending
	    TreeIter iter;

	    // updating rate widget
      Adjustment rate_adj = builder.get_object("rateadjustment") as Adjustment;
      rate_adj.value = 0;
      
      // updating recipe name
      Entry name_text = builder.get_object("nameentry") as Entry;
      name_text.text = "";
      
      // updating ingredient list
      TextBuffer ing_text = new TextBuffer(null);
      ing_text.set_text("");
      TextView ing_view = builder.get_object("ingredientview") as TextView;
      
      // updating recipe text
      TextBuffer rec_text = new TextBuffer(null);
      rec_text.set_text("");
      TextView rec_view = builder.get_object("recipeview") as TextView;
      
      // updating text buffers for view
      ing_view.set_buffer(ing_text);
      rec_view.set_buffer(rec_text);
      
      // adding an empty model with id 0 (reserved value)
      recipe_store.append(out iter);
	    recipe_store.set(iter, 0, 0, 1, "new recipe");
	  }
	  
	  [CCode (instance_pos = -1)]
	  public void on_recipe_save(Action sender) {
    
	    bool is_update = false;
	    
	    // getting objects from view
	    TreeIter? iter;
	    TreeSelection selected_row = this.recipe_list.get_selection();
	    TreeModel? treemodel;
	    
	    // getting selected row
	    selected_row.get_selected(out treemodel, out iter);
      
      Value col0;
      
      // getting column 0 value (meal id)
      treemodel.get_value(iter, 0, out col0);
      
      if(col0.get_int64() != 0)
        is_update = true;
      
      Meal current_meal;
      
      // updating model
      if(is_update)
        current_meal = model.get_one(col0.get_int64());
      else
        current_meal = new Meal();

      if(current_meal == null) {
        on_error("no meal selected!");
        return; 
      }

            // getting name
      Entry name_text = builder.get_object("nameentry") as Entry;
      if(name_text.text == "") {
        on_error("A name is required!");
        return;
      }
      current_meal.name = name_text.text;

      // getting rating
      Adjustment rate_adj = builder.get_object("rateadjustment") as Adjustment;
      current_meal.rating = rate_adj.value;
      
      // getting ingredients
      TextView ing_view = builder.get_object("ingredientview") as TextView;
      TextBuffer ing_text = ing_view.buffer;
      current_meal.ingredients = ing_text.text;
      
      // getting instructions
      TextView rec_view = builder.get_object("recipeview") as TextView;
      TextBuffer rec_text = rec_view.buffer;
      current_meal.instructions = rec_text.text;
      
      // getting cooking time (not implemented)
      current_meal.cooking_time = 0;
      
      if(is_update) {
        model.update(current_meal);
      }
      else {
        model.add(current_meal);
        current_meal = null;
      }
     
      // updating view
      populate_recipe_list();
	  }
	  
	  [CCode (instance_pos = -1)]
	  public void on_recipe_delete(Action sender) {
		    
	    // getting objects from view
	    TreeIter iter;
	    TreeSelection selected_row = this.recipe_list.get_selection();
	    TreeModel? treemodel;
	    
	    // getting selected row
	    selected_row.get_selected(out treemodel, out iter);
      
      Value col0;
      
      // getting column 0 value (meal id)
      treemodel.get_value(iter, 0, out col0);

      // updating model
      Meal current_meal = model.get_one(col0.get_int64());
      if(current_meal == null) {
	      on_error("No selected meal!");
	      return;
	    }
      model.del(current_meal);
      recipe_store.remove(iter);
      
      // clear view
      // updating rate widget
      Adjustment rate_adj = builder.get_object("rateadjustment") as Adjustment;
      rate_adj.value = 0;
      
      // updating recipe name
      Entry name_text = builder.get_object("nameentry") as Entry;
      name_text.text = "";
      
      // updating ingredient list
      TextBuffer ing_text = new TextBuffer(null);
      ing_text.set_text("");
      TextView ing_view = builder.get_object("ingredientview") as TextView;
      
      // updating recipe text
      TextBuffer rec_text = new TextBuffer(null);
      rec_text.set_text("");
      TextView rec_view = builder.get_object("recipeview") as TextView;
      
      // updating text buffers for view
      ing_view.set_buffer(ing_text);
      rec_view.set_buffer(rec_text);
	  }
	  
	  private void show_error_dialog(string text) {
	    GLib.debug("an error was thrown: %s", text);
	    MessageDialog dialog = new MessageDialog(window, DialogFlags.MODAL, MessageType.ERROR, ButtonsType.CANCEL, null);
	    dialog.text = text;
	    dialog.run();
	    dialog.destroy();
	  }
	  
	  public signal void on_fatal();

    public signal void on_error(string text);
  }
}