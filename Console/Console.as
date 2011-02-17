/*********************************************************************************
* The console, which allows text input and interprets it via the interpreter.
* It contains a textfield, and knows how to manipulate it to let the user
* see compiler errors and so forth.
*********************************************************************************/

package Console {
	import Language.*;
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	public class Console extends Sprite{
		private var text:TextField;
		private var output:TextField;
		private var runButton:RunButton;
		private var parser:Parser;
		private var objectScope:Object;
		private var cycleWindow:TextField;

		public function Console(x:int, y:int, width:int, height:int, backend:Parser){
			parser = backend;
			backend.setOutput(printOutput);
			text = new TextField();
			text.type = TextFieldType.INPUT;
			//text.background = true;
			text.backgroundColor = 0x000000;
			text.border = true;
			text.borderColor = 0x00dd00;
			text.x = x;
			text.y = y;
			text.width = width;
			text.height = height*0.5;
			text.multiline = true;
			text.wordWrap = true;
			text.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, TextKeyFocusChange);

			output = new TextField();
			output.type = TextFieldType.DYNAMIC;
			//output.background = true;
			output.backgroundColor = 0x000000;
			output.border = true;
			output.borderColor = 0x00dd00;
			output.x = x;
			output.y = y+height*0.5;
			output.width = width;
			output.height = height*0.5;
			output.multiline = true;
			output.wordWrap = true;
			output.mouseWheelEnabled = true;

            var format:TextFormat = new TextFormat();
            format.font = "Verdana";
            format.color = 0x00dd00;
            format.size = 10;

			text.defaultTextFormat = format;
			text.text = "x(0);y(0);";
			output.defaultTextFormat = format;

			addChild(text);
			addChild(output);

			cycleWindow = new TextField();
			cycleWindow.type = TextFieldType.INPUT;
			//cycleWindow.background = true;
			cycleWindow.backgroundColor = 0x000000;
			cycleWindow.border = true;
			cycleWindow.borderColor = 0x00dd00;
			cycleWindow.x = x + width + 10;
			cycleWindow.y = y+10;
			cycleWindow.width = 60;
			cycleWindow.height = 15;
			cycleWindow.multiline = true;
			cycleWindow.wordWrap = true;
			cycleWindow.mouseWheelEnabled = true;
			cycleWindow.defaultTextFormat = format;
			addChild(cycleWindow);

			runButton = new RunButton();
			runButton.x = x + width + 10;
			runButton.y = y + height -runButton.height;
			runButton.addEventListener(MouseEvent.CLICK, runCode);
			addChild(runButton);
		}


		private function TextKeyFocusChange(e:FocusEvent):void
		{
			e.preventDefault();

			var txt:TextField = TextField(e.currentTarget);

			txt.replaceText(txt.caretIndex,txt.caretIndex,"\t");
			txt.setSelection(txt.caretIndex+1, txt.caretIndex+1);
		}

		public function runCode(e:Event)
		{
			output.text="";
			trace("Begin!");
			trace("text is");
			try {
				trace(text.text);
				var tree = parser.parseString(text.text, objectScope);
				if(tree != null)
				{
					tree.printTree();
					//tree.attachScope(objectScope);
					if(cycleWindow.text.length>0)
					{
						var num = Number(cycleWindow.text);
						tree.setMaxCycle(num);
					}
					tree.run();
					printOutput(tree.report());
				}
				if (!parser.succeeded())
				{
					trace("highlight error");
					highlight(parser.currentPosition());
				}
				if(tree.error)
				{
					printOutput("ERROR: "+tree.errorString);
				}
			}
			catch (err:Error)
			{
				printOutput(err.message);
				printOutput(err.getStackTrace());
			}
		}

		public function printOutput(s:String)
		{
			output.appendText(s+"\n");
		}

		public function attachScope(symbol:Object)
		{
			objectScope = symbol;
		}

		public function highlight(s:String)
		{
			trace(s);
			var start = s.indexOf('[');
			var end = s.indexOf(']')-1;
            var format:TextFormat = new TextFormat();
            format.font = "Verdana";
            format.color = 0xdd0000;
            format.size = 13;
			text.setTextFormat(format, start, end);
			
		}
	}
}
