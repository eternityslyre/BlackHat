/***********************************************************************
* This class wraps all scopable objects, preventing access to things
* the player shouldn't have access to, which will protect themselves
* from a great deal of badness.
************************************************************************/

package Console {
	import flash.display.*;
	public interface ScopableObject
	{
		public function has(name:String):Boolean;
		public function get(name:String):Object;
		public function set(name:String, value:Object);
	}
}
