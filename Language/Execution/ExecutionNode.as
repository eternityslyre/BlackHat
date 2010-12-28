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

	import Language.Tokens.*

	public class ExecutionNode {
		//return type, default void
		private var returnType:int = 0;
		private var children:Array;
		private var name:String;
		public var parent:ExecutionNode;

		public function ExecutionNode(lhs:String, args:Array)
		{
			//trace("Node created with args:");
			children = args;
			name = lhs;

			if(args.length < 1)
				return;
			for( var a in args)
			{
			//	trace(args[a]);
				if(args[a] is ExecutionNode)
				args[a].setParent(this);
			}
		}
		//default implementation
		public function run():Object{ 
			if(children.length>0) 
				return runFirst(); 
			else trace("no children.");
			return null; 
		}

		private function runFirst():Object{
			var out = null;
			for(var child in children)
			{
				if(children[child] is ExecutionNode)
				{
					out = children[child].run();
				}
			}
			return out;
		}

		public function setParent(par:ExecutionNode)
		{
			parent = par;
		}

		private function getName():String{
			return name;
		}

		private function printData():String{
			return ""+children;
		}

		private function getChildren():Array
		{
			return children;
		}

		public function printTree(recurse:String = ""){
			if(children.length<1){
				trace(recurse+"+--"+getName()+" LEAF: "+printData());
			}
			else{
				trace(recurse+"+--"+getName()+": "+printData());
			}
			for(var i =0;i<children.length;i++){
				if(children[i] is Token) continue;
				if(parent!=null){
					var grampa:ExecutionNode = parent.parent;
					if(parent!=null&&parent.getChildren().length>1&&
					   parent.children[parent.getChildren().length-1]!=this)
					{
						children[i].printTree(recurse+"| ");
					}
					else 
					{
						children[i].printTree(recurse+"  ");
					}
				}
				else children[i].printTree(recurse+"  ");
			}
		}
	}
}
