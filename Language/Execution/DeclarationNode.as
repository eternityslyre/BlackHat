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
	public class DeclarationNode extends ExecutionNode {
		//return type, default void
		private var children:Array;
		private var type:String;
		private var scopeHandler:ScopeHandler;

		public function DeclarationNode(lhs:String, args:Array, scope:ScopeHandler)
		{
			super(lhs, args);
			children = args;
			scopeHandler = scope;
			if(children[1] is Token)
				scopeHandler.define(children[1].getSymbol());
		}

		public override function run():Object{
			//Case-by-case handling

			// case "var x ;"
			var rhs = null;
			var innerType = "null";
			var variableName = children[1].getSymbol();
			// case var x = Expression ;
			if(children.length > 3)
			{
				rhs = children[3].run();
				innerType = children[3].getType();
			}
			scopeHandler.createAndAssign(rhs, variableName, innerType);
			return null;
		}
	}
}
