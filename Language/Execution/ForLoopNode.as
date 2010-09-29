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
	public class ForLoopNode {
		private var Initialization:ExecutionNode;
		private var Conditional:ExecutionNode;
		private var Iteration:ExecutionNode;
		private var initialized:Boolean;
		public function ForLoopNode(args:Array){
			Initialization = args.pop();
			Conditional = args.pop();
			Iteration = args.pop();
			Statements = args.pop();
		}
		//default implementation
		public function run():Object{ 
			if(!initialized){
				initialized = true;
				Initalization.run();
			}
			if(Boolean(Conditional.run())){
				Statements.run();
				Iteration.run();
			}
				
		}
	}
}
