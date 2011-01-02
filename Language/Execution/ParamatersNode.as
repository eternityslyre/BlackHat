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
	public class ParametersNode extends ExecutionNode {
		//return type, default void
		private var children:Array;
		private var type:String;
		private var scopeHandler:ScopeHandler;
		private var arguments:Array;

		public function ParametersNode(lhs:String, args:Array, scope:ScopeHandler)
		{
			super(lhs, args);
			children = args;
			scopeHandler = scope;
			define();
		}

		private function define()
		{
			scopeHandler.define(children[0].getSymbol());
			if(children.length>1){
				children[2].define();
			}
		}

		public function toArray(arr:Array)
		{
			arr.push(children[0]);
			if(children.length>1){
				children[2].toArray(arr);
			}
		}

		public override function run():Object{
			//Case-by-case handling
			// case function Function 
			scopeHandler.enterScope(arguments);
			return null;
		}
	}
}
