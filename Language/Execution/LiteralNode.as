/*******************************************************************************
*
*	Abstract execution node; used for the execution tree to follow.
*	All execution nodes must implement:
*   1. Run - the execution of the node itself.
*   2. Construction, with the specific child nodes it expects.
*   Nodes return an object on completion, depending on what the result is.
*
*********************************************************************************/

package Language.Execution {
	public class LiteralNode {
		//return type, default void
		private var returnType:int = 0;
		private var children:Array;
		private var myValue;
		
		public function LiteralNode(val:Object){
			//parse the value
			myValue = vale;

		}
		//Run here should be the equivalent of "evaluate", which means that it should return 
		// the corresponding literal it's got stored. Do whatever parsing is necesaary to get
		// the correct PRIMITIVE and return it out here.
		public function run():Object{ return myValue; }
	}
}
