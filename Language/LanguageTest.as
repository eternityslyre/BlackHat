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
			"function test(x, y, z){}"
		];
		public var invalidTestStrings:Array =
		[
			"garbage",
			"trace(\"hello world\")",
			"varyxxx",
			"for(var x =0;blargh;)",
			"for(var i=0;i<10;i++)",
			"while(10){}",
			"while(true*4){}",
			"while(true){}"
		];
		public function LanguageTest(parser:Parser)
		{
			//Check that all valid test strings are valid.
			for (var testString in validTestStrings)
			{
				trace("Testing: "+validTestStrings[testString]);
				var node = parser.parseString(validTestStrings[testString]);
				if(node == null) trace("Compilation failed.");
				else trace("Compilation successful, as expected.");
			}
			//Check that all invalid test strings are invalid.
			for (var testString in invalidTestStrings)
			{
				trace("Testing: "+invalidTestStrings[testString]);
				var node = parser.parseString(invalidTestStrings[testString]);
				if(node != null) trace("Compilation succeeded!?.");
				else trace("Compilation failed, as expected.");
			}
		}

		

	}
}
