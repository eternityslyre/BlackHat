/****************************************************************
* This class is the "screen" which is lowered over the game
* during console mode, which:
* 	1. Draws the blur filter over all "protected" objects
*	2. Manages and causes pulsation of all "exposed" objects
*	3. Attaches scope and loads the CodeField for any specific
*		object.
****************************************************************/

package Game
{
	public class Screen extends MovieClip
	{
		// Default movieclip that contains all objects. This is
		// the layer we draw to to show anything.
		private var world:MovieClip;
		// Movieclip for all the blurred objects which can't be edited
		private var backgroundLayer:MovieClip;
		// Movieclip for all "exposed" objects, which can be clicked
		// and edited in Hacker Mode.
		private var foregroundLayer:MovieClip;

		private var currentState:int;

		/* List of all modes */
		public static int MODE_RUNNING = 0; // Everything runs and moves
		public static int MODE_HACKER = 1; // World doesn't move, but can be hacked.
		public static int MODE_PAUSED = 2; // Nothing can be done. Shows hacker screen.
		
		public function Screen()
		{
			world = new MovieClip();
			backgroundLayer = new MovieClip();
			foregroundLayer = new MovieClip();
		}

		public function addBackground(mc:MovieClip)
		{
			world.addChild(mc);
			backgroundLayer.addChild(mc);
		}
		
		public function addExposed(obj:MovieClip)
		{
			world.addChild(obj);
			foregroundLayer.addChild(obj);
		}


		public function onEnterFrame()
		{
			switch (currentState)
			{
				case MODE_RUNNING:
				break;
				case MODE_HACKER:
					handleConsole();
				break;
				case MODE_PAUSED:
					handleConsole();
				break;
			}
		}
		
		public function handleConsole()
		{
			if(!showConsole)
			{
				if(console.y + console.height >= -20){
					console.y-=consoleMoveSpeed;
					trace(console.y+console.height);
					//world.drawCurtain(0,0,stage.width, console.height+console.y+consoleMoveSpeed);
				}
				else 
				{
					pause = false;
					world.resume();
				}
			}
			if(showConsole)
			{
				//world.drawCurtain(0,0,stage.width, console.height+console.y+consoleMoveSpeed);
				if(console.y + console.height < screenHeight)
				console.y+=consoleMoveSpeed;
				
				/* Create the buttons */

				/* Cause the programmable objects to pulsate */
			}
		}

		public function loadObject(exposedObject:ProgrammableObject)
		{
			var code = exposedObject.getCode();
			var codeField = new CodeField(exposedObject.x, exposedObject.y, 100,100);
			codeField.loadText(code);
		}
	}
}
