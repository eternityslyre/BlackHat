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

		private var showConsole:Boolean;
		private var console:Console;
		private var pause:Boolean;
		private var world:World;
		private var screenHeight:Number;
		private var consoleMoveSpeed:Number = 5;

		private var FPSTextField;
		private var previousTime:uint;
		private var cycles:uint;

		public function Game(stage:Stage, parse:Parser)
		{
			world = new World();
			addChild(world);
			console = new Console(10,10,400,360,parse);
			addListeners(stage);
			screenHeight = 360;
			addChild(console);

			FPSTextField = new TextField();
			FPSTextField.width = 70;
			FPSTextField.height = 30;
			FPSTextField.x = 360;
			FPSTextField.y = 0;
			FPSTextField.background = true;
			addChild(FPSTextField);


		}

		private function addListeners(stage:Stage)
		{
			stage.addEventListener(KeyboardEvent.KEY_UP, handleKeys);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		public function handleConsole()
		{
			if(showConsole && console.y + console.height < screenHeight){
				console.y+=consoleMoveSpeed;
				world.drawCurtain(0,0,stage.width, console.height+console.y+consoleMoveSpeed);
			}
			if(!showConsole){
				if(console.y + console.height >= -20){
					console.y-=consoleMoveSpeed;
					trace(console.y+console.height);
					world.drawCurtain(0,0,stage.width, console.height+console.y+consoleMoveSpeed);
				}
				else 
				{
					pause = false;
					world.resume();
				}
			}
		}

		public function onEnterFrame(e:Event)
		{
			calculateFPS();
			handleConsole();
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
			trace("key pressed: "+e.keyCode);
			switch(e.keyCode)
			{
				case 192: 
					if(!showConsole)
					{
						showConsole = true;
						world.freeze();
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