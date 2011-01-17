/**********************************************************************
* This class holds all the items in the world, and animates them.
* It also handles going out of range and thus ceasing to exist, etc.
**********************************************************************/

package World
{
	import flash.events.*;
	import flash.display.*;
	import flash.filters.*;

	public class World extends MovieClip
	{
		// Objects in the world that can't be affected
		// by the player via hacking
		private var protectedObjects:MovieClip;
		// Objects in the world that can be modified 
		// by the player.
		private var exposedObjects:MovieClip;


		private var blur_x = 6;
		private var blur_y = 6;
		private var blur_quality = 1;
		private var blurArray;
		private var emptyArray;
		private var glowArray;

		public function World()
		{
			protectedObjects = new MovieClip();
			exposedObjects = new MovieClip();
			addChild(protectedObjects);
			addChild(exposedObjects);
			var ball = new Ball();
			ball.x = 150;
			ball.y = 150;
			exposedObjects.addChild(ball);
			var ball2 = new Ball();
			ball2.x = 250;
			ball2.y = 250;
			protectedObjects.addChild(ball2);
			blurArray = new Array();
			blurArray.push(new BlurFilter(blur_x, blur_y, blur_quality));
			glowArray = new Array();
			glowArray.push(new GlowFilter(0xefffcc, 1, 12, 12, 2, 1, false, false));
			glowArray.push(new GlowFilter(0xefffcc, 1, 12, 12, 2, 1, true, false));
			glowArray.push(new BlurFilter(blur_x, blur_y, blur_quality));
			emptyArray = new Array();
		}

		public function resume()
		{
			protectedObjects.filters = emptyArray;
			exposedObjects.filters = emptyArray;
		}

		public function freeze()
		{
			trace("pausing game...");
			//set up the blue filter
			protectedObjects.filters = blurArray;
			exposedObjects.filters = glowArray;

			//flag the world to pause
			stop();
		}
	}
}
