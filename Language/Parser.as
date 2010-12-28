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
		private var variables:Object;
		private var grammar:Grammar;
		private var callback:Function;
		
		public function Parser(grammarFile:String, tokenFile:String, lexicon:String, call:Function){
			grammar = new Grammar(grammarFile, catchCall);
			token = new TokenParser(tokenFile, lexicon, catchCall);
			variables = new Object();
			callback = call;
		}

		private var called:int = 0;
		private function catchCall(){
			//trace("hihi");
			called++;
			if(called>1){
				var builder:TableBuilder = new TableBuilder();
				table = builder.Build(grammar);
				callback.call();
			}
			else {
			}
		}

		public function parseString(input:String):ExecutionNode {
			//trace("BEGIN PARSE");
			stack = new Array();
			executionTree = new Array();
			stack.push("ZZ");
			stack.push(0);
			var next:Token;
			token.loadString(input+"$");
			next = token.nextToken();
			while(next!=null){
				var s = next.getType();
				//get state
				var state:int = stack.pop();
				//build the execution stack
				trace("State "+state+", Symbol "+s);
				//trace("EXECUTION STACK");
				for(var t in executionTree)
				{
					//trace(executionTree[t]);
				}
				//trace("END STACK");
				if(table[state][s]==null){
					trace("UNEXPECTED TOKEN: "+s);
					return null;
				}
				switch(table[state][s].charAt(0)){
					case "s":
						trace("Shift "+table[state][s].substring(1,table[state][s].length)+", "+s);
						stack.push(state);
						stack.push(next);
						executionTree.push(next);
						stack.push(table[state][s].substring(1,table[state][s].length));
						next = token.nextToken();
						trace("next token is "+next.getSymbol());
					break;
					case "r":
						//construct a node from what we have here.
						var rule = grammar.getRule(int(table[state][s].substring(1,table[state][s].length)));
						trace("rule number: "+int(table[state][s].substring(1,table[state][s].length)))
						trace("Reduce with rule "+rule);
						var productions = rule.getProductions();
						var args = new Array();
						var stackArgs = new Array();
						for(var i in productions){
							if(executionTree.length>0){
								var popped = executionTree.pop();
								trace("popping from execution: "+popped);
								args.push(popped);
							}
							stackArgs.push(stack.pop());
							state = stack.pop();
						}
						var newtoken = new Token(rule.getLHS(), rule.getLHS());
						stack.push(state);
						stack.push(newtoken);
						//placeholders.
						stack.push(table[state][newtoken.getType()].substring(1,table[state][newtoken.getType()].length))
						//reverse the stacks
						stackArgs.reverse();
						args.reverse();
						executionTree.push(makeNode(rule.getLHS(),args, stackArgs));
					break;
					//accept case
					case "a":
						//finish!
						trace("Accepted!");
						return executionTree.pop();
					default:
						trace("SYNTAX ERROR: "+s.getSymbol());
						return null;
				}
				next = token.nextToken();
				
			}
			return null;
			
		}

		private function makeNode(lhs:String, args:Array, stackArgs:Array){
			trace("Making a node for "+lhs);
			//trace("Stack Arguments provided:");
			for(var a in stackArgs){
			//	if(stackArgs[a] is Token) trace(stackArgs[a].getSymbol());
			//	else trace(stackArgs[a]);
			}
			//trace("Execution Arguments provided:");
			for(var a in args){
			//	trace(args[a]);
			}
			switch(lhs){
				/*
				case "ForLoop":
					return new ForLoopNode(rhs, args);
				break;
				case "WhileLooop":
					return new WhileLoopNode(rhs, args);
				break;
				case "IfClause":
					return new IfClause(rhs, args);
					break;
				case "ElseClause":
					return new ElseClause(rhs, args);
					break;
				case "Statements":
				case "Statement":
					return new StatementsNode(rhs, args);
				break;
				case "Arguments":
				case "Argument":
					return new ArgumentsNode(rhs, args);
				break;
				case "Program":
					return new ExecutionNode(rhs, args);
				break;
				case "Expression":
					return new ExpressionNode(rhs, args);
				break;
				case "Literal":
					return new LiteralNode(rhs, args);
				break;
				case "Value":
					return new ValueNode(rhs, args);
				break;
				case "FunctionReturn":
					return new FunctionReturnNode(rhs, args);
				break;
				*/
				case "InfixOp":
					return new InfixOpNode(lhs, args, stackArgs);
				break;
				case "Expression":
					return new ExpressionNode(lhs, args);
				break;
				case "Value":
				case "variable":
				case "number":
					return new ValueNode(lhs, args, stackArgs, variables);
				break;
				case "Trace":
					return new TraceNode(lhs, args);
				break;
				default:
					return new ExecutionNode(lhs, args);

			}
		}
	};
}
