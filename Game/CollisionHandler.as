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
		public function handleCollisions(objects:Array)
		{
			for(var i = 0; i < objects.length; i++)
			{
				for(var j = i+1; j < objects.length; j++)
				{
					if(intersects(objects[i],objects[j]))
					{
						objects[i].handleCollision(objects[j]);
						objects[j].handleCollision(objects[i]);
					}
				}
			}
		}

		private function intersects(a:ProgrammableObject, b:ProgrammableObject)
		{
			return !(a.x > b.x + b.width
					|| b.x > a.x + a.width
					|| a.y > b.y + b.height
					|| b.y > b.y + b.height);
		}
	}
}
