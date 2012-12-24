/*******************************************************************************
*
*	ArrayAccess: Handles indexing into an array.
*
*   GENERAL OVERVIEW OF HOW A NODE WORKS:
*   Nodes are created with the necessary nodes, along with the rule they're
*   built with. The "build" function parses the rule accordingly and
*   generates the node. This is done to allow merging of classes of nodes
*   into one "super node" which can figure out which one it is, 
*   saving lots of boilerplate!!
*
*********************************************************************************/

package Language.Execution {

	import Language.Tokens.*
	import World.*;

	public class ArrayAccessNode extends ExecutionNode {
		private var children:Array;
		private var scopeHandler:ScopeHandler;

		public function ArrayAccessNode(lhs, args, scope:ScopeHandler)
		{
			super(lhs,args);
			children = args;
			scopeHandler = scope;
		}
		
		public override function run():Object
		{
			var index = children[2].run();
			return scopeHandler.resolve(children[0], "Array")[index];
		}

		public function getArrayName()
		{
			return children[0];
		}

		public override function getReturnType()
		{
			return "variable";
		}
	}
	
}
