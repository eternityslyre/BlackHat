/******************************************************************************************************
* This is the Syntax Parsing class, which reads in the action table, and then reads in the code file
* (or a string, provided by the user) and returns the execution tree. It does not execute the tree,
* for modularity purposes.
*******************************************************************************************************/

package Language {
	import Language.Execution.*;
	import Language.Tokens.*;
	import Language.Builder.*;
	public class Parser{
		private var table:Object;
		private var token:TokenParser;
		private var stack:Array;
		private var executionTree:Array;
		private var scopeHandler:ScopeHandler;
		private var grammar:Grammar;
		private var callback:Function;
		private var error:Boolean;
		private var errorString:String;
		private var printOutput:Function;
		
		public function Parser(grammarFile:String, tokenFile:String, lexicon:String, call:Function){
			grammar = new Grammar(grammarFile, catchCall);
			token = new TokenParser(tokenFile, lexicon, catchCall);
			callback = call;
			printOutput = consoleOut;
		}

		private function consoleOut(s:String)
		{
			trace(s);
		}

		private var called:int = 0;
		private function catchCall(){
			called++;
			if(called>1){
				var builder:TableBuilder = new TableBuilder();
				table = builder.Build(grammar);
				//builder.printAll(grammar);
				callback.call();
			}
			else {
				trace("hi!");
			}
		}


		public function setOutput(out:Function)
		{
			printOutput = out;
		}

		private function initParser()
		{
			error = false;
			scopeHandler = new ScopeHandler();
			stack = new Array();
			executionTree = new Array();
			stack.push("ZZ");
			stack.push(0);
		}

		public function parseString(input:String, attachedScope:Object = null):ExecutionNode {
			initParser();
			scopeHandler.enterObjectScope(attachedScope);
			var next:Token;
			token.loadString(input+"$");
			next = token.nextToken();
			while(next!=null){
				var s = next.getType();
				//get state
				var state:int = stack.pop();
				//trace("state "+state+", token "+s);
				if(table[state][s]==null){
					error = true;
					trace("SYNTAX ERROR: "+"type "+s+", symbol "+next.getSymbol());
					printOutput("SYNTAX ERROR: "+"type "+s+", symbol "+next.getSymbol());
					printOutput(token.locateError());
					trace("possible values: ");
					for( var s2 in table[state])
					{
						trace(s2);
					}
					return null;
				}
				//move scope
				switch(table[state][s].charAt(0)){
					case "s":
						stack.push(state);
						stack.push(next);
						executionTree.push(next);
						stack.push(table[state][s].substring(1,table[state][s].length));
						next = token.nextToken();
						if(next.getSymbol() == "{")
						{
							scopeHandler.enterScope();
						}
					break;
					case "r":
						//construct a node from what we have here.
						var rule = grammar.getRule(int(table[state][s].substring(1,table[state][s].length)));
						//trace("reduce with rule "+rule);
						var productions = rule.getProductions();
						var args = new Array();
						var stackArgs = new Array();
						for(var i in productions){
							if(executionTree.length>0){
								var popped = executionTree.pop();
								args.push(popped);
							}
							stackArgs.push(stack.pop());
							state = stack.pop();
						}
						var newtoken = new Token(rule.getLHS(), rule.getLHS());
						stack.push(state);
						stack.push(newtoken);
						//trace("last state "+state+" GOTO: "+table[state][newtoken.getType()].substring(1,table[state][newtoken.getType()].length));
						stack.push(table[state][newtoken.getType()].substring(1,table[state][newtoken.getType()].length))

						//reverse the stacks
						stackArgs.reverse();
						args.reverse();
						var newNode = makeNode(rule.getLHS(),args, stackArgs);
						if(newNode.error){
							trace("Terminating compilation on error: "+newNode.errorString);
							printOutput("Terminating compilation on error: "+newNode.errorString);
							error = true;
							return null;
						}
						executionTree.push(newNode);
					break;
					//accept case
					case "a":
						var tree = executionTree.pop();
						tree.precedenceSort(tree);
						tree.setScope(scopeHandler);
						return tree;
					default:
						error = true;
						trace("SYNTAX ERROR: "+s.getSymbol());
						return null;
				}
				
			}
			return null;
			
		}

		public function currentPosition():String
		{
			return token.locateError();
		}

		public function succeeded()
		{
			return !error;
		}

		private function makeNode(lhs:String, args:Array, stackArgs:Array){
			switch(lhs){
				case "ControlFlow":
					return new ControlFlowNode(lhs, args, scopeHandler);
				case "FunctionCall":
					return new FunctionCallNode(lhs, args, scopeHandler);
				case "Function":
					return new FunctionNode(lhs, args, scopeHandler);
				case "Arguments":
					return new ArgumentsNode(lhs, args, scopeHandler);
				case "Parameters":
					return new ParametersNode(lhs, args, scopeHandler);
				case "Declaration":
					return new DeclarationNode(lhs,args, scopeHandler);
				case "ForLoop":
					return new ForLoopNode(lhs, args);
				case "InfixOp":
					return new InfixOpNode(lhs, args);
				case "PrefixOp":
					return new PrefixOpNode(lhs, args);
				case "PostfixOp":
					return new PostfixOpNode(lhs, args);
				case "Expression":
					return new ExpressionNode(lhs, args);
				case "Value":
				case "variable":
				case "number":
					return new ValueNode(lhs, args, stackArgs, scopeHandler);
				case "Trace":
					return new TraceNode(lhs, args, printOutput);
				case "IfElse":
					return new IfElseNode(lhs, args);
				case "WhileLoop":
					return new WhileLoopNode(lhs, args);
				case "Block":
					scopeHandler.enterScope();
					var out = new ExecutionNode(lhs, args);	
					scopeHandler.exitScope();
					return out;
				case "Instantiation":
					return new InstantiationNode(lhs, args);
				case "ArrayAccess":
					return new ArrayAccessNode(lhs, args, scopeHandler);
				case "ReservedClass":
					return new ReservedClassNode(lhs, args, scopeHandler);
				default:
					return new ExecutionNode(lhs, args);

			}
		}
	};
}
