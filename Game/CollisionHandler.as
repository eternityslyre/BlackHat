/********************************************************************************
* This class will be my collision detection and handling system.
* All objects should be in one of three classes:
* 1. Immobile: everything else gets pushed back, it doesn't move.
* 2. Rails: it stops against walls, but moves everything else.
*     Against other rails objects they become stuck.
* 3. Mobile: against railes or immobile it is pushed back. Against
*    other Mobile objects they resolve the collision (bouncing off each other)
*    or otherwise.
******************************************************************************/
package Game
{
	import World.*;
	public class CollisionHandler
	{
		private var objects:Array;
		
		public function CollisionHandler()
		{
			objects = new Array();
		}

		public function registerObject(obj:MovingObject)
		{
			objects.push(obj);
		}

		public function handleCollisions()
		{
			for(var i = 0; i < objects.length; i++)
			{
				for(var j = i+1; j < objects.length; j++)
				{
					if(intersects(objects[i],objects[j]))
					{
						resolveCollision(objects[i], objects[j]);
						objects[i].handleCollision(objects[j]);
						objects[j].handleCollision(objects[i]);

					}
				}
			}
		}

		private function intersects(a:MovingObject, b:MovingObject)
		{
			return !(a.x > b.x + b.width
					|| b.x > a.x + a.width
					|| a.y > b.y + b.height
					|| b.y > a.y + a.height);
		}

		private function resolveCollision(a:MovingObject, b:MovingObject)
		{
			if(a.mobility == b.mobility)
			{
				if(a.mobility == 1)
				{
					//Move everything back to where they were.
				}
				if(a.mobility == 2)
				{
					//momentum-based bounce?
				}
			}
			if(a.mobility > b.mobility) 
			{
				var temp = b;
				b = a;
				a = temp;
			}
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
				var newx = a.x - b.width - 1;
				b.x = newx;
			}

			if(rightIntersect)
			{
				var newx = a.x + a.width + 1;
				b.x = newx;
			}

			if(topIntersect)
			{
				var newy = a.y - b.height - 1;
				b.y = newy;
			}

			if(bottomIntersect)
			{
				var newy = a.y + a.height + 1;
				b.y = newy;
			}
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
