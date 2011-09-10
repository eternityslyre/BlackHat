/*******************************************************************
*	This is the test file for the interpreter; its purpose is to 
*	guarantee all language features compile and execute correctly.
********************************************************************/

package Language
{
	public class LanguageTest
	{
		public var validTestStrings:Object =
		{
			"trace(\"hello world\");",
			"while(true) {}",
			"for(var i =0; i < 10; i++){}",
			"function test(x, y, z){}"
		};
		public var invalidTestStrings:Object =
		{
			"garbage",
			"trace(\"hello world\")",
			"varyxxx",
			"for(var x =0;blargh;)",
			"for(var i=0;i<10;i++)",
			"while(10){}",
			"while(true*4){}",
			"while(true){}"
		};
		public function LanguageTest()
		{
		}

		

	}
}
