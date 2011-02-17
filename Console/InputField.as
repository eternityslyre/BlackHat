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
	public class InputField extends TextField
	{
		private var startIndex:int;
		private var endIndex:int;
		private var startLine:int;
		private var displayField:TextField;
		private var maxLength:int;
		public function InputField(fullText:TextField, start:int, end:int, max = -1)
		{
			startIndex = start;
			endIndex = end;
			displayField = displayText;
			realign();
			maxLength = max;
			text = fullText.text.substring(start, end);
			addEventListener(Event.CHANGE , textEdited);
			addEventListener(TextEvent.TEXT_INPUT , lengthCheck);
			addEventListener(FocusEvent.KEY_FOCUS_CHANGE, TextKeyFocusChange);
		}

		public function realign()
		{
			var line = displayText.getLineIndexOfChar(startIndex);
			var xStart = displayText.getCharBoundaries(startIndex);
			var xEnd = displayText.getCharBoundaries(endIndex);
			var newWidth = xEnd.x + xEnd.width - xStart;
			var metrics = displayText.getTextLineMetrics(line);
			x = xPosition;
			y = displayText.y + metrics.height*line;
			width = newWidth;
			height = metrics.height;
		}

		private function lengthCheck(e:TextEvent)
		{
			if(maxLength > 0 &&e.text.length + text.length > maxLength)
				e.preventDefault();
		}

		private function TextKeyFocusChange(e:FocusEvent):void
		{
			e.preventDefault();
			var txt:TextField = TextField(e.currentTarget);
			txt.replaceText(txt.caretIndex,txt.caretIndex,"\t");
			txt.setSelection(txt.caretIndex+1, txt.caretIndex+1);
		}

		private function textEdited(event:Event)
		{
			if(text.length > maxLength)
				return;
			displayField.replaceText(displayField.getLineOffset(1),endIndex, event.target.text);
			endIndex = displayField.getLineOffset(1)+event.target.text.length; 
		}


	}
}
