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
		
		public function InfixOpNode(lhs:String, args:Array)
		{
			if(operations == null)
				initOperations();
			super(lhs, args);
			operation = args[0].getSymbol();;

		}

		public function getOp():String
		{
			return operation;
		}


		public function operate(lhs:ExpressionNode, rhs:ExpressionNode):Object
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
						"variable": function(lhs, rhs) { return Number(lhs.run()) + Number(rhs.run()) },
						"number": function(lhs, rhs) { return Number(lhs.run()) + "" + String(rhs) }
					},
					"variable": {
						"string": function(lhs, rhs) { return operations["+"][lhs.innerType()][rhs.getType()](lhs,rhs); },
						"number": function(lhs, rhs) { return operations["+"][lhs.innerType()][rhs.getType()](lhs,rhs); },
						"variable": 
							function(lhs, rhs) {
								return operations["+"][lhs.innerType()][rhs.innerType()](lhs, rhs); 
								}
					},
					"null": { 
						"string": function(lhs, rhs) { this.throwError("CANNOT ADD NULL"); },
						"number": function(lhs, rhs) { this.throwError("CANNOT ADD NULL"); },
						"variable": function(lhs, rhs) { this.throwError("CANNOT ADD NULL"); }
					}
				},
				"-": {
					"number": {
						"number": function(lhs, rhs) { return Number(lhs.run()) - Number(rhs.run()); },
						"variable": function(lhs, rhs) { return Number(lhs.run()) - Number(rhs.run()) } 
					},
					"variable": {
						"number": function(lhs, rhs) { return Number(lhs.run()) - Number(rhs.run()); },
						"variable": 
							function(lhs, rhs) {
								return operations["-"][lhs.innerType()][rhs.innerType()](lhs, rhs); 
								}
					},
					"null": { 
						"string": function(lhs, rhs) { this.throwError("CANNOT SUBTRACT NULL"); },
						"number": function(lhs, rhs) { this.throwError("CANNOT SUBTRACT NULL"); },
						"variable": function(lhs, rhs) { this.throwError("CANNOT SUBTRACT NULL"); }
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
					},
					"null": { 
						"string": function(lhs, rhs) { this.throwError("CANNOT MULTIPLY NULL"); },
						"number": function(lhs, rhs) { this.throwError("CANNOT MULTIPLY NULL"); },
						"variable": function(lhs, rhs) { this.throwError("CANNOT MULTIPLY NULL"); }
					}
				},
				"=": {
					"variable": {
						"string": function(lhs, rhs) { return lhs.assign(String(rhs.run()), "string"); },
						"number": function(lhs, rhs) { return lhs.assign(Number(rhs.run()), "number"); },
						"variable": 
							function(lhs, rhs) {
								lhs.assign(rhs.run(),rhs.innerType());
								}
					}
				},
				"==": {
					"boolean": {
						"boolean": function(lhs, rhs) { return Boolean(lhs.run()) == Boolean(rhs.run()); },
						"variable": function(lhs, rhs) { return Boolean(lhs.run()) == Boolean(rhs.run()); }
					},
					"string": {
						"string": function(lhs, rhs) { return String(lhs.run()) == String(rhs.run()); },
						"variable": function(lhs, rhs) { return String(lhs.run()) == String(rhs.run()); }
					},
					"number": {
						"number": function(lhs, rhs) { return Number(lhs.run()) == Number(rhs.run()); },
						"variable": function(lhs, rhs) { return Number(lhs.run()) == Number(rhs.run()) } 
					},
					"variable": {
						"string": function(lhs, rhs) { return String(lhs.run()) == String(rhs.run()); },
						"number": function(lhs, rhs) { return Number(lhs.run()) == Number(rhs.run()); },
						"boolean": function(lhs, rhs) { return Number(lhs.run()) == Number(rhs.run()); },
						"variable": 
							function(lhs, rhs) {
								return operations["=="][lhs.innerType()][rhs.innerType()](lhs,rhs);
								}
					}
				},
				"!=":{
					"boolean": {
						"boolean": function(lhs, rhs) { return Boolean(lhs.run()) != Boolean(rhs.run()); },
						"variable": function(lhs, rhs) { return Boolean(lhs.run()) != Boolean(rhs.run()); }
					},
					"string": {
						"string": function(lhs, rhs) { return String(lhs.run()) != String(rhs.run()); },
						"variable": function(lhs, rhs) { return !String(lhs.run()) != String(rhs.run()); }
					},
					"number": {
						"number": function(lhs, rhs) { return Number(lhs.run()) != Number(rhs.run()); },
						"variable": function(lhs, rhs) { return Number(lhs.run()) != Number(rhs.run()) } 
					},
					"variable": {
						"string": function(lhs, rhs) { return String(lhs.run()) != String(rhs.run()); },
						"number": function(lhs, rhs) { return Number(lhs.run()) != Number(rhs.run()); },
						"boolean": function(lhs, rhs) { return Number(lhs.run()) != Number(rhs.run()); },
						"variable": 
							function(lhs, rhs) {
								return operations["!="][lhs.innerType()][rhs.innerType()](lhs,rhs);
								}
					}
				},
				"<": {
					"number": {
						"number": function(lhs, rhs) { return Number(lhs.run()) < Number(rhs.run()); },
						"variable": function(lhs, rhs) { return Number(lhs.run()) < Number(rhs.run()) } 
					},
					"variable": {
						"number": function(lhs, rhs) { return Number(lhs.run()) < Number(rhs.run()); },
						"variable": 
							function(lhs, rhs) {
								return operations["<"][lhs.innerType()][rhs.innerType()](lhs, rhs); 
								}
					},
					"null": { 
						"string": function(lhs, rhs) { this.throwError("CANNOT COMPARE NULL"); },
						"number": function(lhs, rhs) { this.throwError("CANNOT COMPARE NULL"); },
						"variable": function(lhs, rhs) { this.throwError("CANNOT COMPARE NULL"); }
					}
				},
				">":{
					"number": {
						"number": function(lhs, rhs) { return Number(lhs.run()) > Number(rhs.run()); },
						"variable": function(lhs, rhs) { return Number(lhs.run()) > Number(rhs.run()) } 
					},
					"variable": {
						"number": function(lhs, rhs) { return Number(lhs.run()) > Number(rhs.run()); },
						"variable": 
							function(lhs, rhs) {
								return operations[">"][lhs.innerType()][rhs.innerType()](lhs, rhs); 
								}
					},
					"null": { 
						"string": function(lhs, rhs) { this.throwError("CANNOT COMPARE NULL"); },
						"number": function(lhs, rhs) { this.throwError("CANNOT COMPARE NULL"); },
						"variable": function(lhs, rhs) { this.throwError("CANNOT COMPARE NULL"); }
					}
				},
				"<=":{
					"number": {
						"number": function(lhs, rhs) { return Number(lhs.run()) <= Number(rhs.run()); },
						"variable": function(lhs, rhs) { return Number(lhs.run()) <= Number(rhs.run()) } 
					},
					"variable": {
						"number": function(lhs, rhs) { return Number(lhs.run()) <= Number(rhs.run()); },
						"variable": 
							function(lhs, rhs) {
								return operations["<="][lhs.innerType()][rhs.innerType()](lhs, rhs); 
								}
					},
					"null": { 
						"string": function(lhs, rhs) { this.throwError("CANNOT COMPRE NULL"); },
						"number": function(lhs, rhs) { this.throwError("CANNOT COMPARE NULL"); },
						"variable": function(lhs, rhs) { this.throwError("CANNOT COMPARE NULL"); }
					}
				},
				">=":{
					"number": {
						"number": function(lhs, rhs) { return Number(lhs.run()) >= Number(rhs.run()); },
						"variable": function(lhs, rhs) { return Number(lhs.run()) >= Number(rhs.run()) } 
					},
					"variable": {
						"number": function(lhs, rhs) { return Number(lhs.run()) >= Number(rhs.run()); },
						"variable": 
							function(lhs, rhs) {
								return operations[">="][lhs.innerType()][rhs.innerType()](lhs, rhs); 
								}
					},
					"null": { 
						"string": function(lhs, rhs) { this.throwError("CANNOT COMPRE NULL"); },
						"number": function(lhs, rhs) { this.throwError("CANNOT COMPARE NULL"); },
						"variable": function(lhs, rhs) { this.throwError("CANNOT COMPARE NULL"); }
					}
				}

			};



		}

	}
}
