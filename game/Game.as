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
	import flash.geom.*;
	import flash.filters.*;
	import flash.utils.getTimer;
	import flash.text.*;
	import World.Objects.*;

	public class Game extends MovieClip
	{
		/* Console Variables */
		private var showConsole:Boolean;
		private var console:Console;
		private var world:World;
		private var screenHeight:Number;
		private var consolePercentage = 0;
		/* Console constants */
		private var CONSOLE_MOVE_SPEED:Number = 1.5/100;

		/* FPS data */
		private var FPSTextField;
		private var previousTime:uint;

		/* Time and Speed control */
		private var CONSOLE_VISIBLE_GAME_SPEED = 0.5;
		private var CONSOLE_VISIBLE_GAME_FPS= 0;
		private var WORLD_SPEED = 1;
		private var WORLD_FPS = 1;
		private var cycles:uint;
		private var gameSpeed:Number = WORLD_SPEED;
		private var framesPerSecond = WORLD_FPS;

		/* Hacking target */
		private var target:ProgrammableObject;
		private var drawDistance:Number = 0;

		public function Game(stage:Stage, parse:Parser)
		{
			world = new World();
			addChild(world);
			console = new Console(10,10,200,150,parse);
			console.visible = false;
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

			initWorld();
		}

		public function initWorld()
		{
			for(var i = 0; i < 1; i++)
			{
				trace("create ball "+i);
				var ball2 = new Ball(50+200/10*i,10+350/10*i, Math.random()*10, Math.random()*10);
				world.addProtected(ball2);
				var ball3 = new Ball(50+200/10*i,10+350/10*i, Math.random()*10, Math.random()*10);
				world.addExposed(ball3);
				ball3.setConsoleCallback(loadConsole)
				trace("end create ball "+i);
			}
			
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
			graphics.clear();
			if(showConsole) 
			{
				if(consolePercentage<1){
					consolePercentage+=CONSOLE_MOVE_SPEED;
				}
				world.drawCurtain(0,0,stage.width, stage.height*consolePercentage);
				if(target != null)
				{
					drawToConsole();
					if(drawDistance < 1)
					{
						drawDistance+=0.02;
					}
					else
					{
						console.visible = true;
					}
							
				}
				drawTransition();
			}

			if(!showConsole)
			{
				if(consolePercentage>0){
					consolePercentage-=CONSOLE_MOVE_SPEED;
					world.drawCurtain(0,0,stage.width, stage.height*consolePercentage);
					console.visible = false;
					drawTransition();
				}
				else 
				{
					world.resume();
					gameSpeed = WORLD_SPEED;
					framesPerSecond = WORLD_FPS;
				}
			}
		}

		private function drawTransition()
		{
				var startx = 0;
				var endx = stage.width;
				var endy = stage.height*consolePercentage;
				var starty = endy;
				drawGradient(startx, starty - 100, endx, endy);
				drawLine(5, 0xffffff, 1, startx, starty, endx, endy);
		}
		public function drawGradient(startX:Number, startY:Number, endX:Number, endY:Number)
		{
			var fillType:String = GradientType.LINEAR;
			var colors:Array = [0x000000, 0xFFFFFF]
			var ratios:Array = [0x00,0xff];
			var alphas:Array = [0,1];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(stage.width,150,Math.PI/2,0,startY);
			var spreadMethod:String = SpreadMethod.PAD;
			this.graphics.beginGradientFill(fillType,colors,alphas,ratios,matr,spreadMethod);
			this.graphics.drawRect(startX,startY,endX-startX,endY-startY);
			this.graphics.endFill();

		}
		public function drawLine(width:Number, color:int, alpha:Number, startX, startY, endX, endY)
		{
			graphics.lineStyle(width, color, alpha);
			graphics.moveTo(startX, startY);
			graphics.lineTo(endX, endY);
		}

		public function drawToConsole()
		{
			//draw a line from the console to the object
			graphics.lineStyle(5, 0x00dd00, 1);
			var startx = target.x+target.width/2;
			var starty = target.y+target.height/2;
			var endx = console.x + console.width/2;
			var endy = console.y + console.height/2;
			graphics.moveTo(startx, starty);
			graphics.lineTo((endx-startx)*drawDistance + startx, (endy-starty)*drawDistance + starty);
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
						gameSpeed = CONSOLE_VISIBLE_GAME_SPEED;
						framesPerSecond = CONSOLE_VISIBLE_GAME_FPS;
					}
					else {
						showConsole = false;
						if(target != null)
							console.compileToTree();
						//TODO: Compile and Link to Object
					}
				break;
			}
		}
	}
}
