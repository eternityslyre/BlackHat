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
			//greater pushes lesser back
			//determine angle of intersect.
			var adjustedVelx = a.xVelocity - b.xVelocity;
			var adjustedVely = a.yVelocity - b.yVelocity;
			var slope = adjustedVely/adjustedVelx;
			var leftIntersect = lineIntersects(a.x, a.y, b.x, b.y, slope, b.height);
			var rightIntersect = lineIntersects(a.x, a.y, b.x + b.width, b.y, slope, b.height);
			var topIntersect = lineIntersects(a.x, a.y, b.x, b.y, 1/slope, b.width);
			var bottomIntersect = lineIntersects(a.x, a.y, b.x, b.y + b.height, 1/slope, b.width);

			if(leftIntersect)
			{
				var newx = b.x - a.width;
				a.y = a.yVelocity/a.xVelocity*(newx - a.x);
				a.x = newx;
			}

			if(rightIntersect)
			{
				var newx = b.x + b.width;
				a.y = a.yVelocity/a.xVelocity*(newx - a.x);
				a.x = newx;
			}

			if(topIntersect)
			{
				var newy = b.y - a.height;
				a.x = a.xVelocity/a.yVelocity*(newy - a.y);
				a.y = newy;
			}

			if(bottomIntersect)
			{
				var newy = b.y + b.height;
				a.x = a.xVelocity/a.yVelocity*(newy - a.y);
				a.y = newy;
			}
		}

		private function lineInterescts(origin:int, intercept:int, scalar:int, boundary:int, slope:Number, range:int):Boolean
		{
			var projectedCoord = slope*(scalar - origin) + intercept;	
			return (projectedCoord > boundary && projectedCoord < boundary + range);
		}

		private function intersectTrajectory(x:int, y:int, xVel:Number, yVel:Number, 
								xbound:int, ybound:int, widthbound:int, heightbound:int)
		{
			var leftIntersection = yVel/xVel(xbound - x) + y;
			if (leftIntersection > yBound && leftIntersection > yBound + heightbound)
			{
			}
			var rightIntersection = yVel/xVel(xbound - x - widthbound) + y;
			if (rightIntersection > yBound && rightIntersection > yBound + heightbound)
			{
			}
			var topIntersection = xVel/yVel(ybound - y) + x;
			if (topIntersection > xbound && topIntersection < xbound + widthbound)
			{
			}
			var bottomIntersection = xVel/yVel(ybound - y - heightbound) + x;
			if (bottomIntersection > xbound && topIntersection < xbound + widthbound)
			{
			}

		}
	}
}
