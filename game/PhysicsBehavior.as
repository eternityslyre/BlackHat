/*****************************************************************
* This class represents aggergatable behaviors, which allow 
* the game engine to hook one location to give all objects
* appropriate behavior.
*****************************************************************/
package Game.Behaviors 
{
	class PhysicsBehavior 
	{
		public function updateState(obj:ProgrammableObject)
		{
			obj.x+= obj.xVelocity;
			obj.y+= obj.yVelocity;
			if(yVelocity < 15)
				obj.yVelocity += gravity*tick;
		}
	}
}

