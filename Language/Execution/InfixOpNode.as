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
	public class InfixOpNode extends ExecutionNode {
		//return type, default void
		private var returnType:int = 0;
		private var children:Array;
		private var operation:String;
		private static var operations:Object;
		
		public function InfixOpNode(lhs:String, args:Array, stackArgs:Array)
		{
			if(operations == null)
				initOperations();
			super(lhs, args);
			operation = args[0].getSymbol();;

		}


		public function operate(lhs:ValueNode, rhs:ExpressionNode):Object
		{
			return operations[operation][lhs.getType()][rhs.getType()](lhs, rhs);
		}

		
		//hooray, hard-coded list of operations!
		private static function initOperations()
		{

			operations = {
				"+": {
					"string": {
						"string": function(lhs, rhs) { return String(lhs.run()) + String(rhs.run()); },
						"number": function(lhs, rhs) { return String(lhs.run()) + "" + Number(rhs) },
						"variable": function(lhs, rhs) { return String(lhs.run()) + String(rhs.run()) }
					},
					"number": {
						"number": function(lhs, rhs) { return Number(lhs.run()) + Number(rhs.run()); },
						"variable": function(lhs, rhs) { return Number(lhs.run()) + Number(rhs.run()) } 
					},
					"variable": {
						"string": function(lhs, rhs) { return String(lhs.run()) + String(rhs.run()) },
						"number": function(lhs, rhs) { return Number(lhs.run()) + Number(rhs.run()) },
						"variable": 
							function(lhs, rhs) {
								return operations["+"][lhs.getType()][rhs.getType()](lhs, rhs); 
								}
					}
				},
				"-": {
					"number": {
						"number": function(lhs, rhs) { return Number(lhs.run()) - Number(rhs.run()); },
						"variable": function(lhs, rhs) { return Number(lhs.run()) - Number(rhs.run()) } 
					}
				},
				"*": {
					"number": {
						"number": function(lhs, rhs) { return Number(lhs.run()) * Number(rhs.run()); },
						"variable": function(lhs, rhs) { return Number(lhs.run()) * Number(rhs.run()) } 
					},
					"variable": {
						"number": function(lhs, rhs) { return Number(lhs.run()) * Number(rhs.run()); },
						"variable": 
							function(lhs, rhs) {
								return operations["*"][lhs.innerType()][rhs.innerType()](lhs, rhs); 
								}
					}
				},
				"=": {
					"variable": {
						"string": function(lhs, rhs) { return lhs.assign(String(rhs.run())); },
						"number": function(lhs, rhs) { return lhs.assign(Number(rhs.run())); },
						"variable": 
							function(lhs, rhs) {
								lhs.assign(rhs.run());
								}
					}
				}
			};



		}

	}
}
