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
		private var drawDistance:Number = 0;

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
			if(!showConsole || target == p) return;
			console.visible = false;
			console.attachScope(p);
			console.x = stage.width/2 - console.width/2;
			console.y = stage.height/2 - console.height/2;
			target = p;
			drawDistance = 0;
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
				}
				world.drawCurtain(0,0,stage.width, stage.height*consolePercentage/100);
				graphics.clear();
				if(target != null)
				{
					if(drawDistance < 1)
					{
						drawDistance+=0.02;
					}
					else
					{
						console.visible = true;
					}
					//draw a line from the console to the object
					graphics.lineStyle(5, 0x00dd00, 1);
					var startx = target.x+target.width/2;
					var starty = target.y+target.height/2;
					var endx = console.x + console.width/2;
					var endy = console.y + console.height/2;
					graphics.moveTo(startx, starty);
					graphics.lineTo((endx-startx)*drawDistance + startx, (endy-starty)*drawDistance + starty);
							
				}
				graphics.lineStyle(5, 0xffffff, 1);
				graphics.moveTo(0, stage.height*consolePercentage/100);
				graphics.lineTo(stage.width, stage.height*consolePercentage/100);
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
			calculateAndDisplayFPS();
			handleConsole();
			world.update(gameSpeed, framesPerSecond);
		}

		public function calculateAndDisplayFPS()
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
						console.compileToTree();
						//TODO: Compile and Link to Object
					}
				break;
			}
		}
	}
}
