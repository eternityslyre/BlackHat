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
	public class FunctionNode extends ExecutionNode {
		//return type, default void
		private var children:Array;
		private var type:String;
		private var scopeHandler:ScopeHandler;
		private var parameters:Array;
		private var statements:ExecutionNode;
		private var methodName:String;

		public function FunctionNode(lhs:String, args:Array, scope:ScopeHandler)
		{
			super(lhs, args);
			children = args;
			trace(args);
			parameters = new Array();
			scopeHandler = scope
			methodName = args[0].getSymbol();
			if(children[2] is ParametersNode)
			{
				parameters = new Array();
				children[2].toArray(parameters);
				statements = children[4];
				for(var i in parameters)
				{
					scopeHandler.define(parameters[i].getSymbol());
				}
			}
			else {
				statements = children[3];
			}
		}

		public function getMethod():Function
		{
			return invoke;
		}

		public function getMethodName()
		{
			return methodName;
		}

		public override function run():Object{
			//Case-by-case handling
			// case function Function 
			trace("How are you even calling this?");
			return null;
		}

		public function invoke(args:Array):Object
		{
			if(parameters.length != args.length)
			{
				throwError("Argument mismatch; expected "+parameters.length+", got "+args.length);
			}
			scopeHandler.enterScope(parameters, args);
			var out = statements.run();
			scopeHandler.exitScope();
			return out;
		}
	}
}
