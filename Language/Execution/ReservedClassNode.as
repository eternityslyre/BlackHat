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

	public class ReservedClassNode extends ExecutionNode {
		private var children:Array;
		private var scopeHandler:ScopeHandler;

		public function ReservedClassNode(lhs, args, scope:ScopeHandler)
		{
			super(lhs,args);
			children = args;
			scopeHandler = scope;
		}
		
		public override function run():Object
		{
			trace("ReservedClass returning string "+children[0]);
			return children[0];
		}
	}
	
}
