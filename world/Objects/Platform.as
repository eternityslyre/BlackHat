/*****************************************************************
* This class represents a simple cirular object, ie. a ball.
*****************************************************************/

package World.Objects
{
	import flash.display.MovieClip;
	import flash.display.*;
	import flash.events.*;
	import flash.events.*;
	import World.*;
	import World.Objects.*;
	import Game.Behaviors.*

	public class Platform extends MovingObject
	{
		public var xStart = 20;
		public var xEnd = 400;
		public var gravity:Number= 2;
		public var xSpeed = 3;
		public var physics:PhysicsBehavior;
		public var boundary:BoundaryBehavior;
		private var player:Player;
		private var xOld;
		private var yOld;

		public function Platform(stage:Stage, p:Player, xPos:int, yPos:int, xVel:Number= 0, yVel:Number= 0)
		{
			super(ON_RAILS_OBJECT,"#30mx = x + 2;#30m");
			player = p;
			x = xPos;
			y = yPos;
			xVelocity = xVel;
			yVelocity = yVel;
			boundary = new BoundaryBehavior();
			xOld = x;
			yOld = y;
		}

		public override function updateProgrammable(tick:Number)
		{
			boundary.updateState(this);
			var deltaX = x-xOld;
			var deltaY = y-yOld;
			/*
			if(player.x+player.width/2>x && player.x+player.width/2 <x+width)
			{
				if(player.y + player.height >y && player.y < y && player.yVelocity >0)
				{
					player.ground = true;
					player.y = y - player.height;
					player.x += deltaX;
					player.yVelocity = Math.max(0,deltaY);
				}
			}
			*/
			//physics.updateState(this, tick);
			boundary.updateState(this);
			xOld = x;
			yOld = y;
		}

	}
}

