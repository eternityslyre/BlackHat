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
	public class WhileLoopNode extends ExecutionNode{
		//return type, default void
		private var returnType:int = 0;
		private var children:Array;

		public function WhileLoopNode(lhs:String, args:Array)
		{
			super(lhs, args);
			children = args;
		}
		
		public override function run():Object{
			var iter = 0;
			while(Boolean(children[2].run())){
				if(error){
					trace("terminating on error: "+errorString);
					return null;
				}
				children[4].run();
				if(iter>1000000)
				{
					throwError("You ran too long.");
				}
				iter++;
			}
			return null;
		}
	}
}
