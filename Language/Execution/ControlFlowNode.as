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
	import Language.Tokens.*;
	public class ControlFlowNode extends ExecutionNode {
		//return type, default void
		private var children:Array;
		private var type:String;
		private var scopeHandler:ScopeHandler;

		public function ControlFlowNode(lhs:String, args:Array, scope:ScopeHandler)
		{
			super(lhs, args);
			children = args;
			scopeHandler = scope;
		}

		public override function run():Object{
			// case function Function 
			if(children.length == 2 && children[1] is FunctionNode){
				scopeHandler.createAndAssign(children[1].getMethod(), children[1].getMethodName(), "function");
				return null;
			}
			else
				return children[0].run();
		}
	}
}
