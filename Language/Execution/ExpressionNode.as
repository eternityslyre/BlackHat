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

		public function assign(arg:Object, assignType:String)
		{
			if(children.length==1)
				children[0].assign(arg, assignType);
			else trace("ERROR: CANNOT ASSIGN TO EXPRESSION");

		}

		public override function precedenceSort(parent:ExecutionNode, grandParent:ExecutionNode = null)
		{
			if(children.length < 3) return;
			var leftChild = children[0];
			var operator = children[1];
			var rightChild = children[2];
			var currentPrecedence = precedence();

			rightChild.precedenceSort(this, parent);
			if(parent is ExpressionNode)
			{
				var parentPrecedence = ExpressionNode(parent).precedence();
				if(parentPrecedence > currentPrecedence)
				{
					var localIndex = 0;
					if(parent.getChild(parentIndex) == this)
					{
						localIndex = 2;
					}
					var parentIndex = -(parentIndex-2);
					parent.setChild(parentIndex, children[localIndex]);
					children[localIndex] = parent;
					grandParent.swapNodes(parent, this);
				}
			}
			leftChild.precedenceSort(this, parent);
		}

		private function precedence():int
		{
			if(children.length < 3) return 2;
			var operator = children[1].getOp();
			switch(operator)
			{
				case "%":
				case "*":
				case "/":
					return 2;
				case "+":
				case "-":
					return 1;
				case "==":
				case "&&":
				case "||":
					return 1;
				case "=":
				case "*=":
				case "+=":
				case "/=":
				case "%=":
				case "-=":
					return 0;
				default:
					return -1;
			}
		}

		public override function run():Object{
			if(children.length==1)
				return children[0].run();
			if(children.length==2)
			{
				var operator = children[0];
				var operand = children[1];
				if(children[0] is ExecutionNode)
				{
					operator = children[1];
					operand = children[0];
				}
				return operator.operate(operand);
			}
			var result = children[1].operate(children[0], children[2]);
			return result;
		}
		
	}
}
