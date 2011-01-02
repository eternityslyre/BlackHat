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
	public class FunctionCallNode extends ExecutionNode {
		//return type, default void
		private var children:Array;
		private var type:String;
		private var scopeHandler:ScopeHandler;
		private var arguments:Array;
		private var functionName:String;

		public function FunctionCallNode(lhs:String, args:Array, scope:ScopeHandler)
		{
			super(lhs, args);
			children = args;
			scopeHandler = scope;
			functionName = children[0].getSymbol();

		}

		public override function run():Object{
			//Case-by-case handling
			// case function Function 
			arguments = new Array();
			if(children[2] is ArgumentsNode){
				children[2].toArray(arguments);
			}
			var fromTable = scopeHandler.resolve(functionName)
			var out = fromTable(arguments);
			return out;
		}
	}
}
