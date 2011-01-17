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
	public class TraceNode extends ExecutionNode {
		//return type, default void
		private var returnType:int = 0;
		private var children:Array;
		private var printOutput:Function;

		public function TraceNode(lhs:String, args:Array, outputFunc:Function)
		{
			super(lhs, args);
			children = args;
			printOutput = outputFunc;
		}

		public override function run():Object
		{
			trace("TRACE: "+children[2].run());
			printOutput(children[2].run());
			complete = true;
			return null;
		}
	}
}
