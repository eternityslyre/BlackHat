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

	public class Player extends ProgrammableObject
	{
		private var leftdown:Boolean;
		private var rightdown:Boolean;
		private var updown:Boolean;
		private var downdown:Boolean;
		public var xVelocity;
		public var yVelocity;
		public var ground;
		public var gravity:Number= 2;
		public var xSpeed = 3;

		public function Player(stage:Stage, xPos:int, yPos:int, xVel:Number= 0, yVel:Number= 0)
		{
			super("gravity = 5#s25#s;\nxSpeed = #5s3#5s;");
			x = xPos;
			y = yPos;
			xVelocity = xVel;
			yVelocity = yVel;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
			ground = false;
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
			physics.updateState(this);
			boundary.updateState(this);
			if(leftdown)
				x-=xSpeed;
			if(rightdown)
				x+=xSpeed;
			if(updown && ground)
			{
				ground = false;
				yVelocity= -10;
			}
			if(downdown)
				xVelocity *= 0.5;
				trace("Down");
			if(y + height > 400)
			{
				ground = true;
			}
		}

	}
}

