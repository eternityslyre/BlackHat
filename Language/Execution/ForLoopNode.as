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
	public class ForLoopNode extends ExecutionNode{
		private var Initialization:ExecutionNode;
		private var Conditional:ExecutionNode;
		private var Iteration:ExecutionNode;
		private var Statements:ExecutionNode;
		private var initialized:Boolean;
		private var children;
		public function ForLoopNode(lhs:String, args:Array){
			super(lhs, args);
			children = args;
			Initialization = children[2];
			Conditional = children[4];
			Iteration = children[6];
			Statements = children[8];
		}
		//default implementation
		public override function run():Object{ 
			if(!initialized){
				initialized = true;
				Initialization.run();
			}
			while(Boolean(Conditional.run())){
				if(error){
					trace("error, terminating");
					return null;
				}
				Statements.run();
				Iteration.run();
			}
			return null;
		}
		
		public function step():Object{
			if(!initialized){
				initialized = true;
				Initialization.run();
			}
			if(Boolean(Conditional.run())){
				Statements.run();
				Iteration.run();
			}
			return null;
		}
	}
}
