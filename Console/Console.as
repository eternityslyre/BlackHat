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
		private var text:CodeField;
		private var output:TextField;
		private var runButton:RunButton;
		private var parser:Parser;
		private var objectScope:Object;
		private var cycleWindow:TextField;

		public function Console(x:int, y:int, width:int, height:int, backend:Parser){
			parser = backend;
			backend.setOutput(printOutput);
			text = new CodeField(x, y, width, height);
			var testString = "0#mif(xVelocity < 10)\n{\n    xVelocity = xVelocity + 1;\n}0#m"+
			"\ntrace(\"15#sHello World!!15#s\");\n0#mif ( x > 500 ) { xVelocity = 0 - 20; } 0#m";
			text.loadText(testString);

			output = new TextField();
			/*
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
			*/

            var format:TextFormat = new TextFormat();
            format.font = "Verdana";
            format.color = 0x00dd00;
            format.size = 10;

			output.defaultTextFormat = format;

			addChild(text);
			//addChild(output);

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
		}

		public function addRunButton()
		{
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

		public function compileToTree()
		{
			// Attach the objectScope to the generated ExecutionTree
			var tree = parser.parseString(text.getText(), objectScope);
			objectScope.setCode(tree);
		}

		public function runCode(e:Event)
		{
			output.text="";
			trace("Begin!");
			trace("text is");
			try {
				trace(text.getText());
				var tree = parser.parseString(text.getText(), objectScope);
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
					text.highlight(parser.currentPosition());
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

	}
}
