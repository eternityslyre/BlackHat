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

		public function Player(stage:Stage, xPos:int, yPos:int, xVel:Number= 0, yVel:Number= 0)
		{
			trace("IM A BALL!!!!");
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
			x+= xVelocity;
			y+= yVelocity;
			if(y < 0) y = 0;
			if(leftdown)
				x-=10;
			if(rightdown)
				x+=10;
			if(updown && ground)
			{
				ground = false;
				yVelocity= -10;
			}
			if(downdown)
				xVelocity *= 0.5;
				trace("Down");
			if(yVelocity < 15)
			yVelocity += gravity*tick;
			if(y + height > 400)
			{
				yVelocity = 0;
				y = 400 - height;
				ground = true;
			}
			if(x + width > 550 || x < 0) xVelocity*=-1;
		}

	}
}

