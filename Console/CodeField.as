﻿/**************************************************************************************
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
		private var filterArray;

		public function CodeField(x:int, y:int, width:int, height:int)
		{
			colorIndex = 0;
			filterArray = new Array();
			filterArray[0] = new GlowFilter(0xffffff,0,0,0);
			inputFields = new Array();
			displayField = new TextField();
			displayField.type = TextFieldType.DYNAMIC;
			displayField.backgroundColor = 0x000000;
			displayField.background = true;
			displayField.border = true;
			displayField.borderColor = 0x00dd00;
			displayField.x = x;
			displayField.y = y;
			displayField.width = width;
			displayField.height = height;
			displayField.multiline = true;
			displayField.wordWrap = true;
			//displayField.selectable = false;

            DEFAULT_FORMAT = new TextFormat();
            DEFAULT_FORMAT.font = "Verdana";
            DEFAULT_FORMAT.color = 0x00dd00;
            DEFAULT_FORMAT.size = 10;
			var tabArray = new Array();
			for(var i = 0; i < 1000; i+=40)
			{
				tabArray.push(i);
			}
			DEFAULT_FORMAT.tabStops = [];///tabArray;
			displayField.defaultTextFormat = DEFAULT_FORMAT;
			addChild(displayField);
		}

		public function pulsate(colorIndex:Number)
		{
			var pulseValue = (1-Math.cos(colorIndex))/2;
			filterArray[0].alpha = pulseValue;
			filterArray[0].blurX = pulseValue*2;
			filterArray[0].blurY = pulseValue*2;
			for (var fieldIndex in inputFields)
			{
				var field = inputFields[fieldIndex];
				var pulseRed = Math.floor(pulseValue*(field.endRed-field.red));
				var pulseGreen= Math.floor(pulseValue*(field.endGreen-field.green));
				var pulseBlue = Math.floor(pulseValue*(field.endBlue-field.blue));
				field.textColor = rgbToHex(field.red+pulseRed, field.green+pulseGreen, field.blue+pulseBlue);
				field.filters = filterArray; 
			}
			colorIndex += 0.05;
			if(Math.random() > 0.95)
				electrify(new Rectangle(displayField.x, displayField.y, displayField.width, displayField.height));
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
			return;
			graphics.clear();
			graphics.lineStyle(2, 0x990000, 1);
			graphics.moveTo(rect.x, rect.y);
			var x = rect.x;
			var y = rect.y;
			var variance = 50;
			var base = 0.01;
			var ybase = 0.04;
			var grow = 0.01;
			var draw = 0.4;
			var thickness = 3;
			var baseThickness = 1;
			while(x<rect.x+rect.width)
			{
				graphics.lineStyle(thickness*Math.random()+baseThickness, 0x990000, 1);
				x += rect.width*(base+grow*Math.random());
				if(Math.random()>draw)
				graphics.lineTo(x,y+variance*(0.5*(Math.random()-0.5)));
				else 
				graphics.moveTo(x,y+variance*(0.5*(Math.random()-0.5)));
			}
			graphics.moveTo(rect.x+rect.width, rect.y);
			while(y<rect.y+rect.height)
			{
				graphics.lineStyle(thickness*Math.random()+baseThickness, 0x990000, 1);
				y += rect.height*(ybase+grow*Math.random());
				if(Math.random()>draw)
				graphics.lineTo(x+variance*(0.5*(Math.random()-0.5)),y);
				else
				graphics.moveTo(x+variance*(0.5*(Math.random()-0.5)),y);
			}
			graphics.moveTo(rect.x+rect.width, rect.y+rect.height);
			while(x>rect.x)
			{
				graphics.lineStyle(thickness*Math.random()+baseThickness, 0x990000, 1);
				x -= rect.width*(base+grow*Math.random());
				if(Math.random()>draw)
				graphics.lineTo(x,y+variance*(0.5*(Math.random()-0.5)));
				else
				graphics.moveTo(x,y+variance*(0.5*(Math.random()-0.5)));
			}
			graphics.moveTo(rect.x, rect.y+rect.height);
			while(y>rect.y)
			{
				graphics.lineStyle(thickness*Math.random()+baseThickness, 0x990000, 1);
				y -= rect.height*(ybase+grow*Math.random());
				if(Math.random()>draw)
				graphics.lineTo(x+variance*(0.5*(Math.random()-0.5)),y);
				else 
				graphics.moveTo(x+variance*(0.5*(Math.random()-0.5)),y);
			}
		}

		public function indexesToRectangle(start:int, end:int):Rectangle
		{
			var startBounds = displayField.getCharBoundaries(start);
			var endBounds = displayField.getCharBoundaries(end);
			var startx = Math.min(startBounds.x, endBounds.x);
			var starty = Math.min(startBounds.y, endBounds.y);
			var endx = Math.max(startBounds.x+startBounds.width, endBounds.x+endBounds.width);
			var endy = Math.max(startBounds.y+startBounds.height, endBounds.y+endBounds.height);
			return new Rectangle(displayField.x + startx, displayField.y + starty, endx - startx, endy-starty);
		}

		public function loadText(s:String)
		{
			text = s;
			for(var inputField in inputFields)
			{
				inputFields[inputField].visible = false;
			}
			//trace("loading ["+s+"]");
			displayField.text = "";
			displayField.text = s.replace(/#\d+[sm]/g,"");
			var soFar = 0;
			var marks = s.match(/#\d+[sm]/g)
			var parts = s.split(/#\d+[sm]/);
			for ( var i = 0; i < parts.length; i++)
			{
				//trace("line is : "+parts[i]);
				//trace("mark is : "+marks[i]);
				if(i%2==1)
				{
					var maxLength = int(marks[i].substring(1, marks[i].length-1));
					//trace("length is "+maxLength);
					if(inputFields[(i-1)/2] == null)
					{
						inputFields[(i-1)/2] = new InputField(displayField, (i-1)/2, soFar, soFar+parts[i].length, propagate, maxLength);
						addChild(inputFields[(i-1)/2]);
					}
					var field = inputFields[(i-1)/2];
					field.reload(displayField, (i-1)/2, soFar, soFar+parts[i].length, propagate, maxLength);
					field.visible = true;
					field.type = TextFieldType.INPUT;
					field.defaultTextFormat = DEFAULT_FORMAT;
					field.multiline = marks[i].charAt(marks[i].length-1) == 'm';
					//trace(marks[i].charAt(marks[i].length-1));
					field.wordWrap = field.multiline;
					field.textColor = 0xff0000;
					field.text = parts[i];
					field.realign();
				}
				soFar += parts[i].length;

			}
			//addEventListener(Event.ENTER_FRAME, pulse);
		}

		public function getText()
		{
			return displayField.text;
		}

		public function getCodeString():String
		{
			var output = "";
			var parts = text.split(/#\d+[sm]/);
			var marks = text.match(/#\d+[sm]/g)
			var append = "";
			for(var i = 0; i < parts.length; i++)
			{
				append = parts[i];
				if(i%2==1)
				{
					append = marks[i]+inputFields[(i-1)/2].text+marks[i];
				}
				output+=append;
			}
			//trace("regenerated code is: ["+output+"]");
			return output;
		}

		public function highlight(s:String)
		{
			trace(s);
			var start = s.indexOf('[');
			var end = s.indexOf(']')-1;
            var format:TextFormat = new TextFormat();
            format.font = "Verdana";
            format.color = 0xdd0000;
			displayField.setTextFormat(format, start, end);
			
		}

	}
}
