/*****************************************************************
* This class represents a simple cirular object, ie. a ball.
*****************************************************************/

package World.Objects
{
	import flash.display.MovieClip;
	import flash.events.*;
	import World.*;

	public class Ball extends MovingObject
	{
		private var testString2 = "#0mif(xVelocity < 10)\n{\n    xVelocity = xVelocity + 1;\n}#0m"+
			"\ntrace(\"#15sHello World!!#15s\" + xVelocity);\n#0mif ( x > 500 ) { xVelocity = 0 - 20; } #0m";

		public function Ball(xPos:int, yPos:int, xVel:int = 0, yVel:int = 0)
		{
			super(FREE_OBJECT,testString2);
			trace("IM A BALL!!!!");
			x = xPos;
			y = yPos;
			xVelocity = xVel;
			yVelocity = yVel;
			mobility = 2;
		}

		public override function handleCollision(b:MovingObject)
		{
			
			if(b.mobility <= mobility)
			{
				var a = b;
				b = this;
				//lesser pushes greater back
				//determine angle of intersect.
				// y = mx + b
				// x = y/m - b/m
				
				var adjustedVelx = b.xVelocity - a.xVelocity;
				var adjustedVely = b.yVelocity - a.yVelocity;
				if(adjustedVelx == 0 && adjustedVely == 0)
					return;
				var slope = adjustedVely/adjustedVelx;
				var leftIntersect = (adjustedVelx > 0) && 
						lineIntersects(b.y, b.height, a.x - b.x - b.width, a.y, slope, a.height);
				var rightIntersect = (adjustedVelx < 0) && 
						lineIntersects(b.y, b.height, a.x + a.width - b.x, a.y, slope, a.height);
				var topIntersect = (adjustedVely > 0) && 
						lineIntersects(b.x, b.width, a.y - b.y - b.height, a.x, 1/slope, a.width);
				var bottomIntersect = (adjustedVely < 0) &&
						lineIntersects(b.x, b.width, a.y + a.height - b.y, a.x, 1/slope, a.width);

				if(leftIntersect)
				{
					xVelocity = -xVelocity;
				}

				if(rightIntersect)
				{
					xVelocity = -xVelocity;
				}

				if(topIntersect)
				{
					yVelocity = -yVelocity;
				}

				if(bottomIntersect)
				{
					yVelocity = -yVelocity;
				}
			}
		}

		public override function updateProgrammable(tick:Number)
		{
			x += xVelocity*tick;
			y += yVelocity*tick;
			if(x + width > 550 || x < 0) xVelocity*=-1;
			if(y + height > 400 || y < 0) yVelocity*=-1;
		}

		private function lineIntersects(intercept:Number, interceptRange:Number, 
										scalar:Number, boundary:Number, slope:Number, range:int):Boolean
		{
					var projectedCoord = slope*scalar + intercept;
					return (projectedCoord > boundary && projectedCoord < boundary + range)||
							(projectedCoord + interceptRange > boundary && projectedCoord +interceptRange < boundary + range)||
							(projectedCoord < boundary && projectedCoord + interceptRange > boundary + range);
		}
	}
}
