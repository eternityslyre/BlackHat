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
	public class StatementsNode {
		private var Statements:ExecutionNode;
		private var Statement:ExecutionNode;
		public function StatementsNode(statement:ExecutionNode, statements:ExecutionNode = null){
			Statements = statements;
			Statement = statement;
		}
		//default implementation
		public function run():Object{ 
			if(Statements != null) Statements.run();
			Statement.run();
		}
	}
}
