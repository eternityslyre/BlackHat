/*****************************************************************
* This class represents aggergatable behaviors, which allow 
* the game engine to hook one location to give all objects
* appropriate behavior.
*****************************************************************/
package Game.Behaviors 
{
	class BoundaryBehavior 
	{
		public function updateState(obj:ProgrammableObject)
		{
			if(obj.x < 0) obj.x = 0;
			if(obj.y < 0) obj.y = 0;
			if(obj.x + obj.width > 550)
			{
				obj.x = 550 - obj.width;
			}

			if(obj.y + obj.height > 400)
			{
				obj.y = 400 - obj.height;
			}
			
		}
	}
}

