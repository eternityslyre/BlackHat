/*****************************************************************
* This class represents a simple cirular object, ie. a ball.
*****************************************************************/

package World.Objects
{
	import flash.display.MovieClip;
	import flash.events.*;
	import World.*;

	public class Ball extends ProgrammableObject
	{
		public var xVelocity;
		public var yVelocity;

		public function Ball(xPos:int, yPos:int, xVel:int = 0, yVel:int = 0)
		{
			trace("IM A BALL!!!!");
			x = xPos;
			y = yPos;
			xVelocity = xVel;
			yVelocity = yVel;
		}

		public override function updateInner(tick:Number)
		{
			x += xVelocity*tick;
			y += yVelocity*tick;
			if(x + width > 550 || x < 0) xVelocity*=-1;
			if(y + height > 400 || y < 0) yVelocity*=-1;
		}

	}
}
