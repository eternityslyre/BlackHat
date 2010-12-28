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
	public class ExpressionNode extends ExecutionNode {
		//return type, default void
		private var returnType:int = 0;
		private var children:Array;
		private var type:String;
		
		public function ExpressionNode(lhs:String, args:Array)
		{
			super(lhs, args);
			children = args;
			type = args[0].getType();
		}

		public function getType()
		{
			return type;
		}

		public function innerType(){
			return children[0].innerType();
		}

		public override function run():Object{
			if(children.length==1)
				return children[0].run();
			var result = children[1].operate(children[0], children[2]);
			return result;
		}
	}
}
