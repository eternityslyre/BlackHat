/************************************************************************************
* The abstract token class. It defines the methods all tokens need to support:
*    1. GetSymbol - returns the grammar-recognized symbol, which may not 
*       be what was seen by the tokenparser, for use by the parser.
*    2. GetType - returns the type of the token, for verification purposes.
*************************************************************************************/

package Language.Tokens {
	public class Token {
		private var type:String;
		private var symbol:String

		public function Token(tokentype:String, s:String){
			type = tokentype;
			symbol = s;
		}

		public function toString()
		{
			return symbol;
		}

		public function getType(){
			return type;
		}

		public function getSymbol(){
			return symbol;
		}
	}
}
