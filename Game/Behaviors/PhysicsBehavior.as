/*****************************************************************
* This class represents aggergatable behaviors, which allow 
* the game engine to hook one location to give all objects
* appropriate behavior.
*****************************************************************/
package Game.Behaviors 
{
	import World.Objects.*;
	public class PhysicsBehavior 
	{
		public var gravity = 0.2;
		public function updateState(obj:Player, tick:Number)
		{
			obj.x+= obj.xVelocity;
			obj.y+= obj.yVelocity;
			if(obj.yVelocity < 15)
				obj.yVelocity += gravity*tick;
		}
	}
}

