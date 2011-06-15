/***********************************************************************
* This class defines the basics of any object which has in-game code  
* components. Most notably, it provides an override for 
* OnEnterFrame, which calls Animate and Execute.
***********************************************************************/
package World
{
	import flash.display.MovieClip;
	import flash.events.*;
	public class ProgrammableObject extends ActiveObject //implements IProgrammable
	{
		private var world:World;
		/* Constructor to pull out all properties available for call and edit */
		public function ProgrammableObject()
		{
			addEventListener(MouseEvent.ROLL_OVER, rolledOver);
			//addEventListener(MouseEvent.ROLL_OUT);
		}
		public function setWorld(w:World)
		{
			world = w;
		}
		public function rolledOver(e:Event)
		{
			world.loadConsole(this);
		}
	}
}
