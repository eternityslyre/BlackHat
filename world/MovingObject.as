/***********************************************************************
* This class defines the basics of any object which has in-game code  
* components. Most notably, it provides an override for 
* OnEnterFrame, which calls Animate and Execute.
***********************************************************************/
package World
{
	import flash.display.MovieClip;
	import flash.events.*;
	import Language.Execution.*;
	public class MovingObject extends ProgrammableObject //implements IProgrammable
	{
		public var STATIC_OBJECT:int = 0;
		public var ON_RAILS_OBJECT:int = 1;
		public var FREE_OBJECT:int = 2;
		public var xVelocity = 0;
		public var yVelocity = 0;
		public var mobility = 0;

		/* Constructor to pull out all properties available for call and edit */
		public function ProgrammableObject(txt:String = null)
		{
			codeString = txt;
			addEventListener(MouseEvent.ROLL_OVER, rolledOver);
		}

		public function handleCollision(b:MovingObject)
		{
		}


		public override function update(tick:Number)
		{
			updateProgrammable(tick);
			execute();
		}
	}
}
