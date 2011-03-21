/**************************************************************************************
* This class extends the TextField so as to allow highlighting and modification of 
* only select portions of itself, while still drawing and storing the results
* as if it were a normal TextField.
**************************************************************************************/

package Console
{
	import flash.display.*;
	import flash.text.*;
	import flash.filters.*;
	import flash.events.*;
	import flash.geom.*;
	public class CodeField extends Sprite
	{
		private var inputFields:Array;
		private var displayField:TextField;
		private var text:String;
		private var endIndex:int;
		private var colorIndex:Number;
		private var DEFAULT_FORMAT;

		public function CodeField(x:int, y:int, width:int, height:int)
		{
			colorIndex = 0;
			inputFields = new Array();
			displayField = new TextField();
			displayField.type = TextFieldType.DYNAMIC;
			displayField.backgroundColor = 0x000000;
			displayField.border = true;
			displayField.borderColor = 0x00dd00;
			displayField.x = x;
			displayField.y = y;
			displayField.width = width;
			displayField.height = height;
			displayField.multiline = true;
			displayField.wordWrap = true;
			displayField.selectable = false;

            DEFAULT_FORMAT = new TextFormat();
            DEFAULT_FORMAT.font = "Verdana";
            DEFAULT_FORMAT.color = 0x00dd00;
            DEFAULT_FORMAT.size = 10;
			displayField.defaultTextFormat = DEFAULT_FORMAT;
			addChild(displayField);
		}

		private function pulse(event:Event)
		{
			var pulseValue = (1-Math.cos(colorIndex))/2;
			var blur = new GlowFilter(0xffffff, pulseValue, pulseValue*2, pulseValue*2);
			for (var fieldIndex in inputFields)
			{
				var field = inputFields[fieldIndex];
				var pulseRed = Math.floor(pulseValue*(field.endRed-field.red));
				var pulseGreen= Math.floor(pulseValue*(field.endGreen-field.green));
				var pulseBlue = Math.floor(pulseValue*(field.endBlue-field.blue));
				field.textColor = rgbToHex(field.red+pulseRed, field.green+pulseGreen, field.blue+pulseBlue);
				field.filters = [blur]; 
			}
			colorIndex += 0.05;
			var xStart = displayField.getCharBoundaries(20);
			var xEnd = displayField.getCharBoundaries(75);
			graphics.lineStyle(2,0x0000ff);
			graphics.drawRect(displayField.x+xStart.x, displayField.y+xStart.y, xStart.width, xStart.height);
			graphics.drawRect(displayField.x+xEnd.x, displayField.y+xEnd.y, xEnd.width, xEnd.height);
			var startx = Math.min(xStart.x, xEnd.x);
			if(Math.random() > 0.9)
				electrify(indexesToRectangle(20,75));
			else if(Math.random()<0.2) graphics.clear();
		}

		private function rgbToHex(red:int, green:int, blue:int):uint
		{
			return (red<<16)+(green<<8)+blue;
		}

		public function propagate(index:int, count:int)
		{
			for(var i = index+1; i < inputFields.length; i++)
			{
				inputFields[i].shift(count);
			}
		}

		public function electrify(rect:Rectangle)
		{
			graphics.clear();
			trace("drawing from "+rect.x+", "+rect.y+" to "+(rect.x+rect.width)+", "+(rect.y+rect.height));
			graphics.lineStyle(2, 0x990000, 1);
			graphics.moveTo(rect.x, rect.y);
			var x = rect.x;
			var y = rect.y;
			var variance = 15;
			while(x<rect.x+rect.width)
			{
				x += rect.width*(0.01+0.1*Math.random());
				if(Math.random()>0.2)
				graphics.lineTo(x,y+variance*(0.5*(Math.random()-0.5)));
				else 
				graphics.moveTo(x,y+variance*(0.5*(Math.random()-0.5)));
			}
			while(y<rect.y+rect.height)
			{
				y += rect.height*(0.01+0.1*Math.random());
				if(Math.random()>0.2)
				graphics.lineTo(x+variance*(0.5*(Math.random()-0.5)),y);
				else
				graphics.moveTo(x+variance*(0.5*(Math.random()-0.5)),y);
			}
			while(x>rect.x)
			{
				x -= rect.width*(0.01+0.1*Math.random());
				if(Math.random()>0.2)
				graphics.lineTo(x,y+variance*(0.5*(Math.random()-0.5)));
				else
				graphics.moveTo(x,y+variance*(0.5*(Math.random()-0.5)));
			}
			while(y>rect.y)
			{
				y -= rect.height*(0.01+0.1*Math.random());
				if(Math.random()>0.2)
				graphics.lineTo(x+variance*(0.5*(Math.random()-0.5)),y);
				else 
				graphics.moveTo(x+variance*(0.5*(Math.random()-0.5)),y);
			}
		}

		public function indexesToRectangle(start:int, end:int):Rectangle
		{
			trace("getting for "+start+" to "+end);
			var xStart = displayField.getCharBoundaries(start);
			var xEnd = displayField.getCharBoundaries(end-1);
			graphics.lineStyle(2,0x0000ff);
			graphics.drawRect(xStart.x, xStart.y, xStart.width, xStart.height);
			graphics.drawRect(xEnd.x, xEnd.y, xEnd.width, xEnd.height);
			var startx = Math.min(xStart.x, xEnd.x);
			var starty = Math.min(xStart.y, xEnd.y);
			var endx = Math.max(xStart.x+xStart.width, xEnd.x+xEnd.width);
			var endy = Math.max(xStart.y+xStart.height, xEnd.y+xEnd.height);
			return new Rectangle(displayField.x + startx, displayField.y + starty, endx - startx, endy-starty);
		}

		public function loadText(s:String)
		{
			displayField.text = s.replace(/\d+#\w/g,"");
			var soFar = 0;
			var marks = s.match(/\d+#\w/g)
			var parts = s.split(/\d+#\w/);
			for ( var i = 0; i < parts.length; i++)
			{
				trace("line is : "+parts[i]);
				if(i%2==1)
				{
					var maxLength = int(marks[i].substring(0, marks[i].indexOf('#')));
					var field = new InputField(displayField, (i-1)/2, soFar, soFar+parts[i].length, propagate, maxLength);
					field.type = TextFieldType.INPUT;
					field.defaultTextFormat = DEFAULT_FORMAT;
					field.multiline = marks[i].charAt(marks[i].length-1) == 'm';
					field.textColor = 0xff0000;
					field.text = parts[i];
					inputFields.push(field);
					addChild(field);
				}
				soFar += parts[i].length;

			}
			addEventListener(Event.ENTER_FRAME, pulse);
		}

		public function getText()
		{
		}

	}
}
