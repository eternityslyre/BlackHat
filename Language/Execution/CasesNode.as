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
	public class CasesNode{
		//return type, default void
		private var returnType:int = 0;
		private var children:Array;

		/*  Case->
			case Literal : Statements
			case Literal : Statements break ;
			case Literal : break ;
			default : 
			default : break ;
		*/
		public function CasesNode(args:Array){
			var colon = args[2] == ":" ? 2 : 1;	
			LiteralValue = args[colon - 1];
			Statements = args[colon + 1];
			shouldBreak = args[args.length-1] == ";";
		}

		public function run(arg:Object):Object{
			//if it's default there's no Literal

			if(!LiteralValue typeof Literal || arg.equals(LiteralValue)){
				Statements.run();
				if(shouldBreak)
					return;
			}
			Cases.run(arg);	
		}
	}
}
