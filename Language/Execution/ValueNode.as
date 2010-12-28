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
	public class ValueNode extends ExecutionNode {
		//return type, default void
		private var returnType:int = 0;
		private var variables:Object;
		private var number:Number;
		private var string:String;
		private var boolean:Boolean;
		private var variable:String;
		private var children:Array;
		private var type:String;

		public function ValueNode(lhs:String, args:Array, stackArgs:Array, vars:Object)
		{
			super(lhs, args);
			var out = stackArgs[0];
			variables = vars;
			type = out.getType();
			switch(out.getType())
			{
				case "variable":
					trace("Creating new variable "+stackArgs[0].getSymbol());
					variable = stackArgs[0].getSymbol();
					variables[variable] = 0;	
					returnType = 3;
				break;
				case "number":
					number = Number(stackArgs[0].getSymbol());
					returnType = 1;
				break;
				case "boolean":
					boolean = Boolean(stackArgs[0].getSymbol());
					returnType = 4;
				break;
				case "string":
					string = stackArgs[0].getSymbol();
					string = string.substring(1, string.length-1);
					returnType = 2;
				break;
				default:
					trace("Unrecognized type..."+out.getSymbol());
			}
		}

		public override function run():Object{
			switch (returnType)
			{
				case 1:
					return number;
				case 2:
					return string;
				case 3:
					return variables[variable];
				case 4:
					return boolean;
			}
			return null;
		}

		public function assign(arg:Object){
			variables[variable] = arg;
		}

		public function innerType():String
		{
			return "number";
		}

		public function getType()
		{
			return type;
		}
	}
}
