/**********************************************************************
* The main class, which runs everything. It also
* listens for key events while the consoles 
* aren't available.
**********************************************************************/

package Game
{
	import Language.*;
	import Console.*;
	import World.*;
	import flash.events.*;
	import flash.display.*;
	import flash.filters.*;
	import flash.utils.getTimer;
	import flash.text.*;

	public class Game extends MovieClip
	{
		/* Console Variables */
		private var showConsole:Boolean;
		private var console:Console;
		private var pause:Boolean;
		private var world:World;
		private var screenHeight:Number;
		private var consoleMoveSpeed:Number = 1.5;
		private var consolePercentage = 0;

		/* FPS data */
		private var FPSTextField;
		private var previousTime:uint;

		/* Time and Speed control */
		private var cycles:uint;
		private var CONSOLE_DOWN_SPEED = 0.5;
		private var CONSOLE_DOWN_FPS= 0;
		private var WORLD_SPEED = 1;
		private var WORLD_FPS = 1;
		private var gameSpeed:Number = WORLD_SPEED;
		private var framesPerSecond = WORLD_FPS;


		/* Hacking target */
		private var target:ProgrammableObject;

		public function Game(stage:Stage, parse:Parser)
		{
			world = new World();
			world.game = this;
			addChild(world);
			console = new Console(10,10,200,150,parse);
			console.visible = false;
			console.attachScope(world.getBall());
			addListeners(stage);
			screenHeight = 360;
			addChild(console);

			FPSTextField = new TextField();
			FPSTextField.width = 70;
			FPSTextField.height = 30;
			FPSTextField.x = 420;
			FPSTextField.y = 80;
			FPSTextField.background = true;
			addChild(FPSTextField);


		}

		public function loadConsole(p:ProgrammableObject)
		{
			if(!showConsole) return;
			console.visible = true;
			console.attachScope(p);
			console.x = p.x+50;
			console.y = p.y-50;
			target = p;
		}

		private function addListeners(stage:Stage)
		{
			stage.addEventListener(KeyboardEvent.KEY_UP, handleKeys);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		public function handleConsole()
		{
			if(showConsole) 
			{
				if(consolePercentage<100){
					consolePercentage+=consoleMoveSpeed;
					world.drawCurtain(0,0,stage.width, stage.height*consolePercentage/100);
				}
				world.pulsate();
				graphics.clear();
				if(console.visible && target != null)
				{
					//draw a line from the console to the object
					graphics.lineStyle(5, 0x00dd00, 1);
					graphics.moveTo(target.x+target.width/2, target.y+target.height/2);
					graphics.lineTo(console.x, console.y+console.height/2);
				}
				graphics.lineStyle(5, 0xffffff, 1);
				graphics.moveTo(0,stage.height*consolePercentage/100);
				graphics.lineTo(stage.width,stage.height*consolePercentage/100);
			}

			if(!showConsole)
			{
				if(consolePercentage>0){
					consolePercentage-=consoleMoveSpeed;
					world.drawCurtain(0,0,stage.width, stage.height*consolePercentage/100);
					console.visible = false;
					graphics.clear();
					graphics.clear();
					graphics.lineStyle(5, 0xffffff, 1);
					graphics.moveTo(0,stage.height*consolePercentage/100);
					graphics.lineTo(stage.width,stage.height*consolePercentage/100);
				}
				else 
				{
					pause = false;
					world.resume();
					gameSpeed = WORLD_SPEED;
					framesPerSecond = WORLD_FPS;
				}
			}
		}

		public function onEnterFrame(e:Event)
		{
			calculateFPS();
			handleConsole();
			world.update(gameSpeed, framesPerSecond);
		}


		public function calculateFPS()
		{
			var now:uint = getTimer();
			var delta = now - previousTime;
			cycles++;
			if(delta < 100) return;
			previousTime = now;
			var FPS:Number = cycles/(delta)*1000;
			FPSTextField.text = "FPS: "+ FPS;
			cycles = 0;
		}

		public function handleKeys(e:KeyboardEvent)
		{
			//trace("key pressed: "+e.keyCode);
			switch(e.keyCode)
			{
				case 192: 
					if(!showConsole)
					{
						showConsole = true;
						world.freeze();
						gameSpeed = CONSOLE_DOWN_SPEED;
						framesPerSecond = CONSOLE_DOWN_FPS;
						pause = true;
					}
					else {
						showConsole = false;
					}
				break;
			}
		}
	}
}
