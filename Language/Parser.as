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
				//parseString("1+1");
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
				//trace("State "+state+", Symbol "+s);
				if(table[state][s]==null){
					//trace("UNEXPECTED TOKEN: "+s);
					return null;
				}
				switch(table[state][s].charAt(0)){
					case "s":
						//trace("Shift "+table[state][s].substring(1,table[state][s].length)+", "+s);
						stack.push(state);
						stack.push(s);
						stack.push(table[state][s].substring(1,table[state][s].length));
						next = token.nextToken();
					break;
					case "r":
						//construct a node from what we have here.
						var rule = grammar.getRule(int(table[state][s].substring(1,table[state][s].length)));
						//trace("rule number: "+int(table[state][s].substring(1,table[state][s].length)))
						//trace("Reduce with rule "+rule);
						var productions = rule.getProductions();
						var args = new Array();
						for(var i in productions){
							args.push(executionTree.pop());
							var popped = stack.pop();
							state = stack.pop();
						}
						var newtoken = new Token(rule.getLHS(), rule.getLHS());
						stack.push(state);
						stack.push(newtoken);
						stack.push(table[state][newtoken.getType()].substring(1,table[state][newtoken.getType()].length))
						executionTree.push(makeNode(rule.getLHS(),args));
					break;
					//accept case
					case "a":
						//finish!
						//trace("Accepted!");
						return executionTree.pop();
					default:
						return null;
				}
				
			}
			return null;
			
		}

		private function makeNode(lhs:String, args:Array){
			trace("Making a node for "+lhs);
			switch(lhs){
				/*
				case "ForLoop":
					return new ForLoopNode(args);
				break;
				case "WhileLooop":
					return new WhileLoopNode(args);
				break;
				case "IfClause":
					return new IfClause(args);
					break;
				case "ElseClause":
					return new ElseClause(args);
					break;
				case "Statements":
				case "Statement":
					return new StatementsNode(args);
				break;
				case "Arguments":
				case "Argument":
					return new ArgumentsNode(args);
				break;
				case "Program":
					return new ExecutionNode(args);
				break;
				case "Expression":
					return new ExpressionNode(args);
				break;
				case "Literal":
					return new LiteralNode(args);
				break;
				case "Value":
					return new ValueNode(args);
				break;
				case "FunctionReturn":
					return new FunctionReturnNode(args);
				break;
				*/
				case "InfixOp":
					return new InfixOpNode(args);
				break;
				case "Expression":
					return new ExpressionNode(args);
				break;
				case "Value":
				case "variable":
				case "number":
					return new ValueNode(args);
				break;

			}
		}
	};
}
