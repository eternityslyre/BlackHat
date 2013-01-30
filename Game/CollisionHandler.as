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
