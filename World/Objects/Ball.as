/*****************************************************************
* This class represents a simple cirular object, ie. a ball.
*****************************************************************/

package World.Objects
{
	import flash.display.MovieClip;
	import flash.events.*;

	public class Ball extends MovieClip
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
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		public function onEnterFrame(e:Event)
		{
			x += xVelocity;
			y += yVelocity;
			if(x + width/2 > 550 || x - width/2 < 0) xVelocity*=-1;
			if(y + height/2 > 400 || y - height/2 < 0) yVelocity*=-1;
		}

	}
}
