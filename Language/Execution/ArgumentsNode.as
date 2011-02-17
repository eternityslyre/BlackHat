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
	public class ArgumentsNode extends ExecutionNode {
		//return type, default void
		private var children:Array;
		private var type:String;
		private var scopeHandler:ScopeHandler;
		private var arguments:Array;

		public function ArgumentsNode(lhs:String, args:Array, scope:ScopeHandler)
		{
			super(lhs, args);
			children = args;
			scopeHandler = scope;
		}

		public function toArray(arr:Array)
		{
			if(children.length>1){
				arr.push(children[2]);
				children[0].toArray(arr);
			}
			else arr.push(children[0]);
		}

		public override function run():Object{
			//Case-by-case handling
			// case function Function 
			scopeHandler.enterScope(arguments);
			return null;
		}
	}
}
