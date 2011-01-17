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
		public static const TYPE_VOID:int = 0;
		public static const TYPE_BOOLEAN:int = 1;
		public static const TYPE_NUMBER:int = 2;
		public static const TYPE_STRING:int = 3;
		public static const TYPE_VARIABLE:int = 4;

		//return type, default void
		private var returnType:int = TYPE_VOID;
		private var children:Array;
		
		//flag for execution complete
		public var complete:Boolean;
		private var cycle:int;
		private var maxCycle:int = -1;
		private var scopeHandler:ScopeHandler;

		//Error reporting
		public var error:Boolean;
		public var errorString:String;

		//profiler
		public var profiler:Profiler;

		//used for tree printing
		private var name:String;
		public var parent:ExecutionNode;

		public function ExecutionNode(lhs:String, args:Array)
		{
			//trace("Node created with args:");
			children = args;
			name = lhs;
			error = false;
			errorString = "";
			cycle = 0;

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
			if(error){
				trace("ERROR: "+errorString);
				return null;
			}
			if(children.length>0) 
				return runFirst(); 
			else trace("no children.");
			return null; 
		}

		public function setMaxCycle(max:int)
		{
			profiler = new Profiler();
			profiler.setMaxCycle(max);
			setProfiler(profiler);
		}

		private function setProfiler(prof:Profiler)
		{
			profiler = prof;
			if(children.length>0)
			{
				for(var child in children)
				{
					if(children[child] is ExecutionNode)
						children[child].setProfiler(prof);
				}
			}
		}

		public function fullName():String
		{
			var out = name;
			if(parent!= null)
			{
				out = parent.fullName() +"." + out;
			}
			return out;
		}

		//Function calls can be rerun!
		public function reset()
		{
			complete = false;
			if(children.length>0)
			{
				for(var child in children)
				{
					if(children[child] is ExecutionNode)
						children[child].reset();
				}
			}
		}

		public function throwError(errString:String)
		{
			if(error) return;
			error = true;
			errorString = errString;
			if(parent != null){
				parent.throwError(errString);
			}
			if(children.length>0)
			{
				for(var child in children)
				{
					if(children[child] is ExecutionNode)
					children[child].throwError(errString);
				}
			}
		}

		private function runFirst():Object{
			var out = null;
			if(name=="Statement" && profiler != null)
			{
				profiler.tick(fullName());
				if(profiler.exceeded())
					throwError("Maximum execution time execeeded.");
			}
			for(var child in children)
			{
				if(children[child] is ExecutionNode)
				{
					if(error){
						trace("ERROR: "+errorString);
						return null;
					}
					out = children[child].run();
				}
			}
			complete = true;
			return out;
		}

		private function getChildren():Array
		{
			return children;
		}

		public function getReturnType()
		{
			return returnType;
		}

		public function report():String
		{
			if(profiler == null) return "";
			return profiler.report();
		}

		public function setReturnType(type:int)
		{
			returnType = type;
		}

		public function setScope(scope:ScopeHandler)
		{
			scopeHandler = scope;
		}

		public function attachScope(scope:Object)
		{
			if(scopeHandler!=null)
			scopeHandler.enterObjectScope(scope);
		}

/************************* TREE SORTING FUNCTIONALITY, FOR EXPRESSION SORTING **********/
		public function swapNodes(current:ExecutionNode, replace:ExecutionNode)
		{
			for(var child in children)
			{
				if(children[child] == current)
					children[child] = replace;
			}
		}

		public function precedenceSort(parent:ExecutionNode, grandParent:ExecutionNode = null){
			for(var child in children)
			{
				if(children[child] is ExecutionNode)
				{
					children[child].precedenceSort(this);
				}
			}
		}

		public function getChild(index:int)
		{
			return children[index];
		}

		public function setChild(index:int, arg:ExpressionNode)
		{
			children[index] = arg;
		}



/***************** TREE PRINTING FUNCTIONALITY, FOR DEBUG USE *********************/
		private function getName():String{
			return name;
		}

		public function printData():String{
			return ""+children;
		}

		public function setParent(par:ExecutionNode)
		{
			parent = par;
			if(error)
				throwError(errorString);
		}

		public function printTree(recurse:String = ""){
			if(children.length<1){
				trace(recurse+"+--"+getName()+" LEAF: "+printData());
			}
			else{
				trace(recurse+"+--"+getName()+": "+printData()+" cycle "+cycle);
			}
			for(var i =0;i<children.length;i++){
				if(children[i] is Token){
					continue;
				}
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
