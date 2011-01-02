/*******************************************************************
* The ScopeHandler produces scoped variables, which allow recursion
* and so forth. It contains a stack (array, really) of symbol tables.
*********************************************************************/
package Language.Execution
{
	public class ScopeHandler
	{
		private var stack:Array;
		private var scope:int;
		private var err:Boolean;

		public function ScopeHandler()
		{
			err = false;
			stack = new Array();
			scope = 0;
			stack[scope] = new SymbolTable();
		}

		public function assign(arg:Object, identifier:String, type:String)
		{
			stack[scope].set(arg, identifier, type);
		}


		public function createAndAssign(arg:Object, identifier:String, type:String)
		{
			stack[scope].set(arg, identifier, type, true);
		}

		public function define(identifier:String)
		{
			createAndAssign(null, identifier, "null");
		}

		public function resolve(identifier:String, expectedType:String = null)
		{
			var out;
			var currentScope = scope;
			err = false;
			while(currentScope >= 0 && out === undefined )
			{
				out = stack[currentScope].get(identifier, expectedType);
				currentScope--;
			}
			if(out === undefined)
			{
				err = true;
				trace("sad");
			}
			return out; 
		}

		public function error()
		{
			return err;
		}

		public function getType(identifier:String)
		{
			var out;
			var type;
			var currentScope = scope;
			while(currentScope >= 0 && out === undefined )
			{
				out = stack[currentScope].get(identifier, null);
				type = stack[currentScope].getType(identifier);
				currentScope--;
			}
			return type; 
		}

		public function enterScope(scopeVariables:Array=null, scopeVariableValues:Array=null) {
			stack.push(new SymbolTable());
			scope++;
			if(scopeVariables == null) return;
			for(var v in scopeVariables)
			{
				createAndAssign(scopeVariableValues[v].run(), scopeVariables[v].getSymbol(), scopeVariableValues[v].innerType());
			}
		}

		public function exitScope() {
			if(scope<1) {
				trace("EXITED TOO MANY SCOPES...!?");
			}
			stack.pop();
			scope--;
		}
	}
}
