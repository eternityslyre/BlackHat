/*******************************************************************************
*
*	Abstract execution node; used for the execution tree to follow.
*	All execution nodes must implement:
*   1. Run - the execution of the node itself.
*   2. Construction, with the specific child nodes it expects.
*   Nodes return an object on completion, depending on what the result is.
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
	public dynamic class ExecutionNode {
		//return type, default void
		private var returnType:int = 0;
		private var arguments:Array;
		private var RHS:String;
		//default implementation
		public function ExecutionNode(rhs:String, args:Array) { RHS = rhs; arguments = args; build(); }
		public function run():Object{ return null; }
		public function isAssignable():Boolean{return false;}
		public function assign(arg:Object){trace("FAILED TO ASSIGN!!");}
		private function build(){ /*default: do nothing */}

	}
}
