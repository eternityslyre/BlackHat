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
		private var testString2 = "#0mif(xVelocity < 10)\n{\n    xVelocity = xVelocity + 1;\n}#0m"+
			"\ntrace(\"#15sHello World!!#15s\" + xVelocity);\n#0mif ( x > 500 ) { xVelocity = 0 - 20; } #0m";

		public function Ball(xPos:int, yPos:int, xVel:int = 0, yVel:int = 0)
		{
			super(testString2);
			trace("IM A BALL!!!!");
			x = xPos;
			y = yPos;
			xVelocity = xVel;
			yVelocity = yVel;
		}

		public override function updateProgrammable(tick:Number)
		{
			x += xVelocity*tick;
			y += yVelocity*tick;
			if(x + width > 550 || x < 0) xVelocity*=-1;
			if(y + height > 400 || y < 0) yVelocity*=-1;
		}

	}
}
