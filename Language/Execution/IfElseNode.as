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
	public class IfElseNode extends ExecutionNode{
		//return type, default void
		private var returnType:int = 0;
		private var children:Array;

		public function IfElseNode(lhs:String, args:Array)
		{
			super(lhs, args);
			children = args;
		}

		//default implementation
		public override function run():Object{
			if(children[2].run() == true){
				children[4].run();
			}
			else if (children.length>=6){
				children[6].run();
			}
			return null;
		}
	}
}
