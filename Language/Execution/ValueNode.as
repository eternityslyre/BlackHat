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
	public class ValueNode extends ExpressionNode {
		//return type, default void
		private var number:Number;
		private var string:String;
		private var boolean:Boolean;
		private var variable:String;
		private var children:Array;
		private var type:String;
		private var scopeHandler:ScopeHandler;

		public function ValueNode(lhs:String, args:Array, stackArgs:Array, scope:ScopeHandler)
		{
			super(lhs, args);
			var out = stackArgs[0];
			scopeHandler = scope;
			type = out.getType();
			switch(out.getType())
			{
				case "variable":
					variable = stackArgs[0].getSymbol();
					var resolved = scopeHandler.resolve(variable) === undefined; 
					trace("resolved "+resolved);
					if(scopeHandler.resolve(variable) === undefined || scopeHandler.error())
					{
						throwError("Unresolved variable "+variable+" referenced.");
					}
					setReturnType(TYPE_VARIABLE);
				break;
				case "number":
					number = Number(stackArgs[0].getSymbol());
					setReturnType(TYPE_NUMBER);
				break;
				case "boolean":
					boolean = Boolean(stackArgs[0].getSymbol());
					setReturnType(TYPE_BOOLEAN);
				break;
				case "string":
					string = stackArgs[0].getSymbol();
					string = string.substring(1, string.length-1);
					setReturnType(TYPE_STRING);
				break;
				default:
					trace("Unrecognized type..."+out.getSymbol());
			}
		}

		public override function run():Object{
			switch (getReturnType())
			{
				case TYPE_NUMBER:
					return number;
				case TYPE_STRING:
					return string;
				case TYPE_VARIABLE:
					var out = scopeHandler.resolve(variable);
					if(scopeHandler.resolve(variable) === undefined)
					{
						throwError("Unresolved variable "+variable);
					}
					return out;
				case TYPE_BOOLEAN:
					return boolean;
			}
			return null;
		}

		public override function assign(arg:Object, typeAssigned:String){
			if(getReturnType() != TYPE_VARIABLE)
			{
				throwError("CANNOT ASSIGN TO A NON-REFERENCE VARIABLE");
				return;
			}
			scopeHandler.assign(arg, variable, typeAssigned);
		}

		public override function innerType()
		{
			switch (getReturnType())
			{
				case TYPE_NUMBER:
					return "number";
				case TYPE_STRING:
					return "string";
				case TYPE_VARIABLE:
					return scopeHandler.getType(variable);
				case TYPE_BOOLEAN:
					return "boolean";
			}

		}

		public override function getType()
		{
			return type;
		}
	}
}
