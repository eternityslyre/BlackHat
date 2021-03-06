/************************************************************************************
* The abstract token class. It defines the methods all tokens need to support:
*    1. GetSymbol - returns the grammar-recognized symbol, which may not 
*       be what was seen by the tokenparser, for use by the parser.
*    2. GetType - returns the type of the token, for verification purposes.
*************************************************************************************/

package Language.Tokens {
	public class AbstractToken {
		//copy-pasted! bad!!
		public static const TYPE_KEYWORD:int = 0;
		public static const TYPE_VALUE:int = 1;
		public static const TYPE_VARIABLE:int = 2;
		private var type:int;
		private var symbol:String

		public function AbstractToken(tokentype:int, s:String){
			symbol = s;
			type = tokentype;
		}

		public function getType(){
			return type;
		}

		public function getSymbol(){
			return symbol;
		}
	}
}
