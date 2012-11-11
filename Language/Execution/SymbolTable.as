/********************************************************************
* The symbol table handles scope and arguments. I leave the coersion
* process to the underlying layer (which means I still crash 
* gracelessly for now.
*********************************************************************/
package Language.Execution
{
	class SymbolTable{
		private var data:Object;
		private var types:Object;
		public function SymbolTable()
		{
			data = new Object();
			types = new Object();
		}

		public function get(identifier:String, expectedtype:String)
		{
			if(data[identifier]===undefined)
			{
				trace("VARIABLE NOT DECLARED OR DOES NOT EXIST: "+identifier);
			}
			if(expectedtype!=null && types[identifier] != expectedtype)
			{
				trace("INCORRECT TYPE EXPECTED: "+expectedtype+",ACTUAL:"+types[identifier]);
				return null;
			}
			return data[identifier];
		}

		public function set(arg:Object, identifier:String, type:String, newVariable:Boolean = false):Boolean
		{
			if(!newVariable && data[identifier] === undefined)
			{
				trace("SET FAILED! VARIABLE NOT DECLARED OR DOES NOT EXIST: "+identifier);
				return false;;
			}
			data[identifier] = arg;
			types[identifier] = type;
			return true;
		}

		private function printAll()
		{
			trace("printing all of "+data.toString());
			for(var a in data)
			{
				trace(a+": "+data[a]+", "+types[a]);
			}
		}

		public function getType(identifier:String):String
		{
			if(types[identifier] == undefined)
				return "null";
			return types[identifier];
		}
	}

}
