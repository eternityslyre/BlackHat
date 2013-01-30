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
	import World.*;
	import Game.*;

	public class World extends MovieClip
	{
		// Objects in the world that can't be affected
		// by the player via hacking
		private var protectedObjects:MovieClip;
		// Objects in the world that can be modified 
		// by the player.
		private var exposedObjects:MovieClip;

		private var objects:Array;

		// The canvas we draw to for blur effects
		private var backgroundData:BitmapData;
		// The buffer for the background
		private var backgroundBuffer:BitmapData;

		private var background:Bitmap;
		private var foreground:Bitmap;

		//Rectangle representing the curtain.
		private var curtain:Rectangle;
		private var BACKGROUND_RECTANGLE = new Rectangle(0,0,550,400);
		private var origin = new Point(0,0);
		private var colorIndex:Number;


		private var blur_x = 20;
		private var blur_y = 12;
		private var blur_quality = 1;
		private var blurArray;
		private var emptyArray;
		private var glowArray;
		private var backgroundMatrix = [
						0,0.7,0,0,0,
						0,1,0,0,0,
						0,0.7,0,0,0,
						0,0,0,0.5,0
						];
		
		private var ticks = 0;
		private var glowFilter = new GlowFilter(0xffffff,0,0,0,2);

		public function World()
		{
			trace("world creation");
			colorIndex = 0;
			objects = new Array();
			protectedObjects = new MovieClip();
			protectedObjects.visible = false;
			exposedObjects = new MovieClip();

			addChild(protectedObjects);
			blurArray = new Array();
			blurArray.push(new BlurFilter(blur_x, blur_y, blur_quality));
			blurArray.push(new ColorMatrixFilter(backgroundMatrix));
			glowArray = new Array();
			glowArray.push(glowFilter);
			emptyArray = new Array();

			background = new Bitmap();
			foreground = new Bitmap();
			backgroundData = new BitmapData(550,400);
			backgroundBuffer = new BitmapData(550,400);
			addChild(background);
			addChild(foreground);
			addChild(exposedObjects);
			curtain = new Rectangle(550,400);
		}

		public function addProtected (a:ActiveObject)
		{
			protectedObjects.addChild(a);
			objects.push(a);
		}

		public function addExposed(p:ProgrammableObject)
		{
			exposedObjects.addChild(p);
			objects.push(p);
		}

		public function pulsate()
		{
			return;
			var pulseValue = (1-Math.sin(colorIndex))/2*8;
			glowArray[0].alpha = pulseValue;
			glowArray[0].blurX = pulseValue*2;
			glowArray[0].blurY = pulseValue*2;
			exposedObjects.filters = glowArray;
			colorIndex += 0.05;
		}

		public function update(tick:Number, frameRate:int)
		{
			ticks++;
			if(frameRate == 0 || ticks<frameRate) return;
			ticks = 0;
			for(var clip in objects)
			{
				objects[clip].update(tick);
			}
		}

		public function pause()
		{
			showCurtain();
		}

		public function resume()
		{
			protectedObjects.visible = true;
			hideCurtain();
		}

		private function hideCurtain()
		{
			background.visible = false;
			foreground.visible = false;
		}

		private function showCurtain()
		{
			background.visible = true;
			foreground.visible = true;
		}

		public function drawCurtain(x:Number, y:Number, width:Number, height:Number) 
		{
			curtain.x = x;
			curtain.y = y;
			curtain.width = width;
			curtain.height = height;
			drawObjects();
			drawFilters();
		}

		private function drawFilters()
		{
			var pulseValue = (1-Math.cos(colorIndex))/2*8;
			glowArray[0].alpha = pulseValue;
			glowArray[0].blurX = pulseValue*2;
			glowArray[0].blurY = pulseValue*2;
			colorIndex += 0.05;
			backgroundData.applyFilter(backgroundData, curtain, origin, blurArray[0]);
			backgroundData.applyFilter(backgroundData, curtain, origin, blurArray[1]);
			backgroundBuffer.applyFilter(backgroundBuffer, curtain, origin, glowArray[0]);
			background.bitmapData = backgroundData;
			foreground.bitmapData = backgroundBuffer;
		}

		private function drawObjects()
		{
			//draw black background
			var backgroundColor = 0x0;
			backgroundData.fillRect(BACKGROUND_RECTANGLE, backgroundColor);
			backgroundBuffer.fillRect(BACKGROUND_RECTANGLE, backgroundColor);
			//set up the blur filter
			backgroundBuffer.draw(exposedObjects);
			protectedObjects.visible = true;
			backgroundData.draw(protectedObjects);
			protectedObjects.visible = false;
		}

	}
}
