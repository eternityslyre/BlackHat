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
	public class PostfixOpNode extends ExecutionNode {
		//return type, default void
		private var returnType:int = 0;
		private var children:Array;
		private var operation:String;
		private static var operations:Object;
		
		public function PostfixOpNode(lhs:String, args:Array)
		{
			if(operations == null)
				initOperations();
			super(lhs, args);
			operation = args[0].getSymbol();

		}

		public function getOp():String
		{
			return operation;
		}


		public function operate(rhs:ExpressionNode):Object
		{
			return operations[operation][rhs.getType()](rhs);
		}

		
		//hooray, hard-coded list of operations!
		private static function initOperations()
		{
			operations = {
				"++": {
					"number": function(operand) { this.throwError("++ MUST BE USED ON A VARIABLE"); },
					"variable": function(operand) {
						if(operand.innerType() != "number") { 
							trace("Incorrect type, type is: "+operand.getType()); 
							this.throwError("CANNOT ADD NON-NUMBER VARIABLE");
						}
						trace( "Executing ++ postfix");
						var result = operand.run();
						trace("Original result: "+result);
						operand.assign(result + 1, operand.innerType());
						var newResult = operand.run();
						trace("New result: "+newResult);
						return result;
						},
					"null": function(operand) { this.throwError("CANNOT ADD NULL"); } 
				},
				"--": {
					"number": function(operand) { this.throwError("-- MUST BE USED ON A VARIABLE"); },
					"variable": function(operand) {
						if(operand.innerType() != "number") this.throwError("CANNOT SUBTRACT NON-NUMBER VARIABLE");
						var result = operand.run();
						operand.assign(result - 1, operand.innerType());
						return result; 
						},
					"null": function(operand) { this.throwError("CANNOT SUBTRACT NULL"); } 
				}
			};



		}

	}
}
