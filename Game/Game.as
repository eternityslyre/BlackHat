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
		private var CONSOLE_MOVE_SPEED:Number = 2/100;

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

		private var collisionHandler:CollisionHandler;

		/* Hacking target */
		private var target:ProgrammableObject;
		private var drawDistance:Number = 0;
		private var colorIndex = 0;

		public function Game(stage:Stage, parse:Parser)
		{
			world = new World();
			collisionHandler = new CollisionHandler();
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

			initWorld(stage);
		}

		public function initWorld(stage:Stage)
		{
			var player = new Player(stage, 100,100,0,0);
			world.addExposed(player);
			world.registerMovingObject(player);
			player.setConsoleCallback(loadConsole);

			var platform = new Platform(stage, player, 300,300,0,0);
			world.addExposed(platform);
			world.registerMovingObject(platform);
			platform.setConsoleCallback(loadConsole);

			for(var i = 0; i < 1; i++)
			{
				trace("create ball "+i);
				var ball2 = new Ball(50+200/10*i,10+350/10*i, 5 + Math.random()*10,  5+ Math.random()*10);
				world.addProtected(ball2);
				world.registerMovingObject(ball2);
				var ball3 = new Ball(50+200/10*i,10+350/10*i, 2 + Math.random()*10,  6 +Math.random()*10);
				world.addExposed(ball3);
				world.registerMovingObject(ball3);
				ball3.setConsoleCallback(loadConsole);
				trace("end create ball "+i);
			}
			
		}

		public function loadConsole(p:ProgrammableObject)
		{
			if(!showConsole || target == p) return;
			if(target != null)
				writeChanges();
			console.visible = false;
			console.attachScope(p);
			//console.x = stage.width/2 - console.width/2;
			//console.y = stage.height/2 - console.height/2;
			target = p;
			drawDistance = 0;
			console.loadText(p.codeString);
		}

		private function writeChanges()
		{
			target.codeString = console.getCodeString();
		}

		private function addListeners(stage:Stage)
		{
			stage.addEventListener(KeyboardEvent.KEY_UP, handleKeys);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		public function handleConsole()
		{
			colorIndex+=0.05;
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
				console.pulsate(colorIndex);
				world.pulsate(colorIndex);
			}

			if(!showConsole)
			{
				if(consolePercentage>0){
					consolePercentage-=CONSOLE_MOVE_SPEED;
					world.drawCurtain(0,0,stage.width, stage.height*consolePercentage);
					console.visible = false;
					drawTransition();
				}
				else if(consolePercentage == 1)
				{
					writeChanges();
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
			graphics.lineStyle(2, 0x00dd00, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE);
			var startx = target.x+target.width/2;
			var starty = target.y+target.height/2;
			var endx = console.x;//+ console.width;
			var endy = console.y;// + console.height;
			graphics.drawEllipse(endx,endy,2,2);
			
			var deltax = endx - startx;
			var deltay = endy - starty;
			var SEGMENT_LENGTH = 15;
			var BLANK_LENGTH = 10;
			var repeat = SEGMENT_LENGTH+BLANK_LENGTH;
			var fullDistance = Math.sqrt(deltax*deltax +deltay*deltay);
			var distance = drawDistance*fullDistance;
			var repeats = distance/repeat;
			var extra = drawDistance;
			var xComponent = deltax/fullDistance;
			var yComponent = deltay/fullDistance;
			var peats = int(repeats);

			/*
			graphics.lineStyle(3, 0x0000dd, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE);
			graphics.moveTo(startx, starty);
			graphics.lineTo(startx + distance*xComponent, starty + distance*yComponent);
			*/
			
			graphics.lineStyle(2, 0x00dd00, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE);

			for(var i = 0; i < peats; i++)
			{
				var fraction = i/repeats;
				var startingx = startx+distance*xComponent*fraction+BLANK_LENGTH*xComponent;
				var startingy = starty+distance*yComponent*fraction+BLANK_LENGTH*yComponent;
				graphics.moveTo(startingx, startingy);
				//graphics.moveTo(startx, starty);
				graphics.lineTo(startingx + SEGMENT_LENGTH*xComponent, SEGMENT_LENGTH*yComponent + startingy);
				//graphics.lineTo(10*i,0);
			}
			var remainder = distance/repeat - peats;
			//peats+=0.05
			if(distance > repeat*peats + BLANK_LENGTH)
			{
				graphics.moveTo(startx + (BLANK_LENGTH+repeat*peats)*xComponent, 
					starty + (BLANK_LENGTH+repeat*peats)*yComponent);
				graphics.lineTo(startx + distance*xComponent, starty + distance*yComponent);
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
						world.pause();
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
