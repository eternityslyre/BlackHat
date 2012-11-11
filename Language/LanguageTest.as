/*******************************************************************
*	This is the test file for the interpreter; its purpose is to 
*	guarantee all language features compile and execute correctly.
********************************************************************/

package Language
{
	public class LanguageTest
	{
		public var validTestStrings:Array =
		[	
			"trace(\"hello world\");",
			"while(true) {}",
			"for(var i =0; i < 10; i++){}",
			"while(true){}",
			"function test(x, y, z){}",
			"var x = new Array(); var y = x[2];",
			"var array = new Array();"
		];
		public var invalidTestStrings:Array =
		[
			"garbage",
			"trace(\"hello world\")",
			"varyxxx",
			"for(var x =0;blargh;)",
			"for(var i=0;i<10;i++)",
			"while(10){}",
			"while(true*4){}"
		];
		public function LanguageTest(parser:Parser)
		{
			//Check that all valid test strings are valid.
			for (var testString in validTestStrings)
			{
				trace("Testing: "+validTestStrings[testString]);
				var node = parser.parseString(validTestStrings[testString]);
				if(node == null) trace("===================!!======================Compilation failed===================!!=======================\n"+
					"on string: "+validTestStrings[testString]);
				else trace("Compilation successful, as expected.");
			}
			//Check that all invalid test strings are invalid.
			for (var testString in invalidTestStrings)
			{
				trace("Testing: "+invalidTestStrings[testString]);
				var node = parser.parseString(invalidTestStrings[testString]);
				if(node != null) trace("======================!!=====Compilation succeeded!?===============!!======================\n"+
					"on string: "+invalidTestStrings[testString]);
				else trace("Compilation failed, as expected.");
			}
		}

		

	}
}
