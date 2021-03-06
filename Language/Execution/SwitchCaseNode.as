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
	public class SwitchCaseNode{
		//return type, default void
		private var returnType:int = 0;
		private var children:Array;

		//SwitchCase->
		//switch ( Value ) { Cases }
		public function SwitchCaseNode(args:Array){
			SwitchValue = args[2];
			Cases = args[5];

		}

		public function run():Object{
			Cases.run(SwitchValue);
		}
	}
}
