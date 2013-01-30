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
	import Game.Behaviors.*

	public class Player extends ProgrammableObject
	{
		public var MAX_X_SPEED:Number = 5;
		private var leftdown:Boolean;
		private var rightdown:Boolean;
		private var updown:Boolean;
		private var downdown:Boolean;
		public var xVelocity;
		public var yVelocity;
		public var ground;
		public var gravity:Number= 0.25;
		public var xSpeed = 3;
		public var physics:PhysicsBehavior;
		public var boundary:BoundaryBehavior;

		public function Player(stage:Stage, xPos:int, yPos:int, xVel:Number= 0, yVel:Number= 0)
		{
			super("gravity = #5s0.25#5s;\nxSpeed = #5s3#5s;");
			x = xPos;
			y = yPos;
			xVelocity = xVel;
			yVelocity = yVel;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
			ground = false;
			physics = new PhysicsBehavior();
			boundary = new BoundaryBehavior();
		}

		public function keyPressed(e:KeyboardEvent)
		{
			switch(e.keyCode)
			{
				case 37:
				leftdown = true;
				break;
				case 38:
				updown = true;
				break;
				case 39:
				rightdown = true;
				break;
				case 40:
				downdown = true;
				break;
			}

		}

	
		public function keyReleased(e:KeyboardEvent)
		{
			switch(e.keyCode)
			{
				case 37:
				leftdown = false;
				break;
				case 38:
				updown = false;
				break;
				case 39:
				rightdown = false;
				break;
				case 40:
				downdown = false;
				break;
			}

		}

		public override function updateProgrammable(tick:Number)
		{
			xVelocity = 0;
			if(leftdown && -xVelocity < MAX_X_SPEED)
				xVelocity=-xSpeed;
			if(rightdown && xVelocity < MAX_X_SPEED)
				xVelocity=xSpeed;
			if(y + height >= 400)
			{
				ground = true;
			}
			if(updown && ground)
			{
				ground = false;
				yVelocity= -10;
			}
			if(downdown)
				xVelocity *= 0.5;
			if(yVelocity < 10)
				yVelocity += gravity;
			x+=xVelocity;
			y+=yVelocity;
			//physics.updateState(this, tick);
			boundary.updateState(this);
		}

	}
}

