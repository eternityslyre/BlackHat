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
						trace(objects[i] + " and " + objects[j] + " are intersecting.");
						objects[i].handleCollision(objects[j]);
						objects[j].handleCollision(objects[i]);
						resolveCollision(objects[i], objects[j]);

					}
				}
			}
		}

		private function intersects(a:MovingObject, b:MovingObject)
		{
			return !(a.x > b.x + b.width
					|| b.x > a.x + a.width
					|| a.y > b.y + b.height
					|| b.y > b.y + b.height);
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
			
			var adjustedVelx = b.xVelocity - a.xVelocity;
			var adjustedVely = b.yVelocity - a.yVelocity;
			var slope = adjustedVely/adjustedVelx;
			var leftIntersect = lineIntersects(b.y, b.x, a.y, slope, a.height);
			var rightIntersect = lineIntersects(b.y, b.x + b.width, a.y, slope, b.height);
			var topIntersect = lineIntersects(b.x, b.y, a.y, 1/slope, b.width);
			var bottomIntersect = lineIntersects(b.x, b.y, a.y + a.height, 1/slope, b.width);

			if(leftIntersect)
			{
				var newx = a.x - b.width;
				b.y = a.yVelocity/a.xVelocity*(newx - a.x);
				b.x = newx;
			}

			if(rightIntersect)
			{
				var newx = a.x + a.width;
				b.y = a.yVelocity/a.xVelocity*(newx - a.x);
				b.x = newx;
			}

			if(topIntersect)
			{
				var newy = b.y - a.height;
				b.x = a.xVelocity/a.yVelocity*(newy - a.y);
				b.y = newy;
			}

			if(bottomIntersect)
			{
				var newy = b.y + b.height;
				b.x = a.xVelocity/a.yVelocity*(newy - a.y);
				b.y = newy;
			}
		}

		private function lineIntersects(intercept:int, scalar:int, boundary:int, slope:Number, range:int):Boolean
		{
			var projectedCoord = slope*scalar + intercept;	
			return (projectedCoord > boundary && projectedCoord < boundary + range);
		}

		private function intersectTrajectory(x:int, y:int, xVel:Number, yVel:Number, 
								xbound:int, ybound:int, widthbound:int, heightbound:int)
		{
			var leftIntersection = yVel/xVel*(xbound - x) + y;
			if (leftIntersection > ybound && leftIntersection > ybound + heightbound)
			{
			}
			var rightIntersection = yVel/xVel*(xbound - x - widthbound) + y;
			if (rightIntersection > ybound && rightIntersection > ybound + heightbound)
			{
			}
			var topIntersection = xVel/yVel*(ybound - y) + x;
			if (topIntersection > xbound && topIntersection < xbound + widthbound)
			{
			}
			var bottomIntersection = xVel/yVel*(ybound - y - heightbound) + x;
			if (bottomIntersection > xbound && topIntersection < xbound + widthbound)
			{
			}

		}
	}
}
