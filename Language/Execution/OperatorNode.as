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
	public class OperatorNode {
		//return type, default void
		private var returnType:int = 0;
		private var LHS:ExecutionNode;
		private var RHS:ExecutionNode;
		private var operator:String;

		public function OperatorNode(args:Array)
		{
			LHS = args.pop();
			operator = args.pop();
			RHS = args.pop();
		}

		//default implementation
		public function run():Object
		{
			//do a bit of type checking
			var LHSval = LHS.run();
			var RHSval = RHS.run();
			switch(operator)
			{
				case "+":
					return LHSval + RHSval;
				break;
				case "*":
					return LHSval * RHSval;
				break;
				case "/":
					return LHSval / RHSval;
				break;
				case "%":
					return LHSval % RHSval;
				break;
				case "&&":
					return LHSval && RHSval;
				break;
				case "||":
					return LHSval || RHSval;
				break;
				case ">":
					return LHSval > RHSval;
				break;
				case "<":
					return LHSval < RHSval;
				break;
				case "<=":
					return LHSval <= RHSval;
				break;
				case "==":
					return LHSval == RHSval;
				break;
				case "!=":
					return LHSval != RHSval;
				break;
				//assignment ops
				case "=":
					 LHSval = RHSval;
				break;
				case "*=":
					 LHSval *= RHSval;
				break;
				case "+=":
					 LHSval += RHSval;
				break;
				case "-=":
					 LHSval -= RHSval;
				break;
				case "/=":
					 LHSval /= RHSval;
				break;
				case ">=":
					 LHSval >= RHSval;
				break;
				// pre and postfix ops.
				case "-":
				break;
				case "++":
				break;
				case "--":
				break;

			}

		}
	}
}
