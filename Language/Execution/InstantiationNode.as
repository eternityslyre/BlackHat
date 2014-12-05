/*******************************************************************************
*
*	Instantiation Node: Handles class lookups and calls "new".
*	All execution nodes must implement:
*   1. Run - the execution of the node itself.
*   2. Construction, with the specific child nodes it expects.
*   Nodes return an object on completion, depending on what the result is.
*
*   GENERAL OVERVIEW OF HOW A NODE WORKS:
*   Nodes are created with the necessary nodes, along with the rule they're
*   built with. The "build" function parses the rule accordingly and
*   generates the node. This is done to allow merging of classes of nodes
*   into one "super node" which can figure out which one it is, 
*   saving lots of boilerplate!!
*
*********************************************************************************/

package Language.Execution {

	import Language.Tokens.*
	import World.*;

	public class InstantiationNode extends ExecutionNode {
		private var children:Array;
		// New functionality: A constructor dictionary that can attempt to call any constructores
		// available.
		private static var constructors:Object;

		public function InstantiationNode(lhs, args)
		{
			super(lhs,args);
			children = args;
			if(constructors == null)
				initConstructors();
		}

		private function initConstructors()
		{
			constructors =  
			{
				"Array": function() { return new Array();}
			}
		}

		public override function run():Object
		{
			setReturnType(children[1].getReturnType());
			var result = children[1].run();
			trace("Trying to make a new "+result);
			if(result == "Array")
			{
				var out = new Array();
				return out;
			}
			throwError("We don't know how to make anything other than arrays.");
			return null;
		}

		public function getType():String
		{
			return "variable";
		}

	}
}
