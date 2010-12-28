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
	public class VariableNode {
		//return type, default void
		private var returnType:int = 0;
		private var children:Array;
		//default implementation
		public function run():Object{ if(children.length>0) return children[0].run(); return null; }
		public function isAssignable():Boolean
		{
			return true;
		}
		public function assign(arg:Object)
		{
			VariableMap.put(this.name, arg);
		}
	}
}
