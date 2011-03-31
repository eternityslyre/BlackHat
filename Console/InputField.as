/**************************************************************************
* This class represents InputFields, which are special fields that,
* in addition to being everything the standard TextField is,
* track: 
* 1. The number of characters input, which can be limited.
* 2. Their corresponding position in the TextField they allow 
*	 Allow editing of.
**************************************************************************/

package Console
{
	import flash.text.*;
	import flash.events.*;
	public class InputField extends TextField
	{
		private var startIndex:int;
		private var endIndex:int;
		private var startLine:int;
		private var displayField:TextField;
		private var maxLength:int;
		private var line:int;
		public var red:int;
		public var green:int;
		public var blue:int;
		public var endRed:int;
		public var endGreen:int;
		public var endBlue:int;
		private var updateCallback:Function;
		private var id:int;
		public function InputField(fullText:TextField, index:int, start:int, end:int, callback:Function, max = -1)
		{
			startIndex = start;
			endIndex = end;
			displayField = fullText;
			updateCallback = callback;
			id = index;
			line = displayField.getLineIndexOfChar(startIndex);
			realign();
			maxLength = max;
			text = fullText.text.substring(start, end);
			red = 0;
			green = 0xdd;
			blue = 0;
			endRed = 0xff;
			endGreen = 0xff;
			endBlue = 0xff;
			addEventListener(Event.CHANGE , textEdited);
			addEventListener(TextEvent.TEXT_INPUT , lengthCheck);
			addEventListener(FocusEvent.KEY_FOCUS_CHANGE, TextKeyFocusChange);
		}

		public function realign()
		{
			var line = displayField.getLineIndexOfChar(startIndex);
			var xStart = displayField.getCharBoundaries(startIndex);
			var xEnd = displayField.getCharBoundaries(endIndex-1);
			var newWidth = xEnd.x + xEnd.width - xStart.x;
			var metrics = displayField.getLineMetrics(line);
			x = displayField.x + xStart.x - 2;
			y = displayField.y + metrics.height*line;
			width = displayField.width;
			height = metrics.height*20+2;
		}

		private function lengthCheck(e:TextEvent)
		{
			if(maxLength > 0 &&e.text.length + text.length > maxLength)
				e.preventDefault();
		}

		public function setColorRGB(r:int, g:int, b:int)
		{
			red = r;
			green = g;
			blue = b;
		}

		public function setColor(color:uint)
		{
			red = (color>>16);
			green = (color>>8)%256;
			blue = color%256;
		}

		public function setEndColor(color:uint)
		{
			endRed = (color>>16);
			endGreen = (color>>8)%256;
			endBlue = color%256;
		}

		public function shift(count:int)
		{
			startIndex+=count;
			endIndex+=count;
			realign();
		}

		private function TextKeyFocusChange(e:FocusEvent):void
		{
			e.preventDefault();
			var txt:TextField = TextField(e.currentTarget);
			txt.replaceText(txt.caretIndex,txt.caretIndex,"    ");
			txt.setSelection(txt.caretIndex+4, txt.caretIndex+4);
			displayField.replaceText(startIndex, endIndex, text);
			updateCallback(id, startIndex+e.target.text.length - endIndex);
			endIndex = startIndex+text.length; 
		}

		private function textEdited(event:Event)
		{
			if(maxLength > 0 && text.length > maxLength)
				return;
			displayField.replaceText(startIndex, endIndex, event.target.text);
			updateCallback(id, startIndex+event.target.text.length - endIndex);
			endIndex = startIndex+event.target.text.length; 
		}


	}
}
