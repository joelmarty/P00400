/* Domain.vala
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
 using Gee;
 using gnomecook.DAO;
 
 namespace gnomecook.Domain {
 	 public class Meal : GLib.Object {
 	 
 		public int64 id { get; set; default = 0; }
 		public string name { get;set; default = "new recipe"; }
 		public string ingredients { get; set; default = ""; }
 		public double cooking_time { get; set; default=0; }
 		public string instructions { get; set; default=""; }
 		public double rating { get; set; default = 0; }
 		

 	}

 }
