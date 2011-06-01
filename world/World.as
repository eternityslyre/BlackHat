/**********************************************************************
* This class holds all the items in the world, and animates them.
* It also handles going out of range and thus ceasing to exist, etc.
**********************************************************************/

package World
{
	import flash.events.*;
	import flash.display.*;
	import flash.filters.*;
	import flash.geom.*;
	import World.Objects.*;

	public class World extends MovieClip
	{
		// Objects in the world that can't be affected
		// by the player via hacking
		private var protectedObjects:MovieClip;
		// Objects in the world that can be modified 
		// by the player.
		private var exposedObjects:MovieClip;

		// The canvas we draw to for blur effects
		private var backgroundData:BitmapData;
		// The buffer for the background
		private var backgroundBuffer:BitmapData;

		private var background:Bitmap;

		//rectangle representing the curtain.
		private var curtain:Rectangle;


		private var blur_x = 12;
		private var blur_y = 6;
		private var blur_quality = 1;
		private var blurArray;
		private var emptyArray;
		private var glowArray;
		
		private var ball;

		public function World()
		{
			protectedObjects = new MovieClip();
			protectedObjects.visible = false;
			exposedObjects = new MovieClip();
			ball = new Ball(150, 150,2,2);
			for(var i = 0; i < 5; i++)
			{
				var ball2 = new Ball(50+400/10*i,50+400/10*i, 10*Math.random(), 0);//10*Math.random());
				protectedObjects.addChild(ball2);
			}
			addChild(protectedObjects);
			blurArray = new Array();
			blurArray.push(new BlurFilter(blur_x, blur_y, blur_quality));
			glowArray = new Array();
			glowArray.push(new GlowFilter(0xefffcc, 1, 12, 12, 2, 1, false, false));
			glowArray.push(new GlowFilter(0xefffcc, 1, 12, 12, 2, 1, true, false));
			glowArray.push(new BlurFilter(blur_x, blur_y, blur_quality));
			emptyArray = new Array();

			background = new Bitmap();
			backgroundData = new BitmapData(550,400);
			backgroundBuffer = new BitmapData(550,400);
			addChild(background);
			exposedObjects.addChild(ball);
			addChild(exposedObjects);
			curtain = new Rectangle(550,400);
		}

		public function getBall()
		{
			return ball;
		}

		public function resume()
		{
			//set up the blur filter
			var rectangle = new Rectangle(0,0,550,400);

			//draw black background
			backgroundBuffer.fillRect(rectangle, 0x000000);
			backgroundBuffer.draw(protectedObjects);
			background.bitmapData = backgroundBuffer;
		}

		public function drawCurtain(x:Number, y:Number, width:Number, height:Number) 
		{
			curtain.x = x;
			curtain.y = y;
			curtain.width = width;
			curtain.height = height + 10;

			trace(height);

			//draw black background
			var rectangle = new Rectangle(0,0,550,400);
			backgroundData.fillRect(rectangle, 0x000000);
			backgroundBuffer.fillRect(rectangle, 0x000000);
			//set up the blur filter
			backgroundBuffer.draw(protectedObjects);
			backgroundData.draw(protectedObjects);
			backgroundData.applyFilter(backgroundBuffer, curtain, new Point(0,0), blurArray[0]);
			background.bitmapData = backgroundData;
		}

		public function freeze()
		{
			
			trace("pausing game...");


			//flag the world to pause
		}
	}
}
