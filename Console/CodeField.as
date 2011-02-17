/**************************************************************************************
* This class extends the TextField so as to allow highlighting and modification of 
* only select portions of itself, while still drawing and storing the results
* as if it were a normal TextField.
* I HAVE NO IDEA HOW TO DO THIS aHHHHHHHHHHHHHHHHHAHAHAHAHHHHHHHHHH
**************************************************************************************/

package Console
{
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	public class CodeField extends Sprite
	{
		private var inputFields:Object;
		private var displayField:TextField;
		private var text:String;
		private var endIndex:int;
		private var colorIndex:Number;
		private var DEFAULT_FORMAT;

		public function CodeField(x:int, y:int, width:int, height:int)
		{
			colorIndex = 0;
			inputFields = new Object();
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
            DEFAULT_FORMAT.size = 20;
			displayField.defaultTextFormat = DEFAULT_FORMAT;
			displayField.text = "This is a test string.\nThis is an editable line.\nThis is a line with THIS PART editable.";

			var metrics = displayField.getLineMetrics(1);
			var field = createField(metrics.x-2, displayField.y + metrics.height, width, metrics.height*20);
			field.text = "This is an editable line.\n";
			field.addEventListener(Event.CHANGE , textEdited);
			field.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, TextKeyFocusChange);
			endIndex = displayField.getLineOffset(1)+field.text.length; 
			addChild(displayField);
			addChild(field);
			field.addEventListener(Event.ENTER_FRAME, pulse);
		}

		private function pulse(event:Event)
		{
			var pulseRed = Math.floor((1-Math.cos(colorIndex))/2*0xff);
			var pulseGreen= Math.floor((1-Math.cos(colorIndex))/2*0x22);
			var pulseBlue = Math.floor((1-Math.cos(colorIndex))/2*0xff);
			for (var field in inputFields)
			{
				inputFields[field].textColor = rgbToHex(0x00+pulseRed, 0xdd+pulseGreen, 0x00+pulseRed);
			}
			colorIndex += 0.05;
		}

		private function rgbToHex(red:int, green:int, blue:int):uint
		{
			return (red<<16)+(green<<8)+blue;
		}


		private function createInputField(fullText:TextField, startIndex:int, endIndex:int, restrictions:String)
		{
			var line = fullText.getLineIndexOfChar(startIndex);
			var xPosition = fullText.getCharBoundaries(startIndex);
			var metrics = fullText.getTextLineMetrics(line);

		}

		private function createField(x:int, y:int, width:int, height:int):TextField
		{
			var field = new TextField();
			field.type = TextFieldType.INPUT;
			field.backgroundColor = 0x000000;
			field.x = x;
			field.y = y;
			field.width = width;
			field.height = height;
			field.multiline = true;
			field.wordWrap = true;

			field.defaultTextFormat = DEFAULT_FORMAT;

			return field;
		}

		public function loadText(s:String)
		{
			displayField.text = s;
		}

		public function getText()
		{
		}

	}
}
