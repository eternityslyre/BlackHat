/******************************************************************
* A simple class to store rules and pointers to where the "stack"
* might be.
*
******************************************************************/
package Language.Builder {
	public class Rule {
		private var lhs:String;
		private var rhs:String;
		private var productions:Array;
		private var index:int;
		private var ruleNumber:int;

		public function Rule(left:String, right:String, num:int, ind:int = 0){
			index = ind;
			ruleNumber = num;
			lhs = left.replace(/\s+/g, "");;
			rhs = right;
			trace(rhs.match(/\s+/));
			if(rhs.match(/\s+/) == null){
				productions = new Array();
				productions[0] = rhs;
			}
			else 
				productions = rhs.split(/\s+/g);
			//trace(left+", ["+right+"], ["+productions+"]");
		}

		public function getLHS(){
			return lhs;
		}

		public function getMarked(){
			return productions[index];
		}

		public function toString(){
			return lhs + " -> "+rhs;
		}

		public function acceptToken(tok:String){
			if(productions[index] == tok)
				return new Rule(lhs, rhs, ruleNumber, index+1);
		}

		public function complete():Boolean{
			return (index == productions.length);
		}

		public function getRuleNumber():int{
			return ruleNumber;
		}

		public function localeCompare(otherRule:Rule){
			//trace("comparing myself: "+getAnnotatedForm()+" to "+otherRule.getAnnotatedForm());
			if(toString().localeCompare(otherRule.toString()) != 0)
				return toString().localeCompare(otherRule.toString());
			return index - otherRule.getIndex();
		}

		public function getAnnotatedForm():String {
			var out = lhs + " ->";
			for(var s in productions){
				var prefix = s == index ? " _" : " ";
				out += prefix + productions[s];
			}
			return out;
		}

		public function getIndex():int{
			return index;
		}

		public function getProductions():Array{
			return productions;
		}




	}
}
