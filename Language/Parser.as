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
		
		public function Parser(grammarFile:String, tokenFile:String, lexicon:String, callback:Function){
			grammar = new Grammar(grammarFile, catchCall);
			token = new TokenParser(tokenFile, lexicon, catchCall);
		}

		private var called:int = 0;
		private function catchCall(){
			trace("hihi");
			called++;
			if(called>1){
				var builder:TableBuilder = new TableBuilder();
				table = builder.Build(grammar);
				parseString("1+1*0*0*1*1+1+1+0*0*1+1");
				callback.call();
			}
			else {
			}
		}

		public function parseString(input:String):ExecutionNode {
			trace("Parse begin");
			stack = new Array();
			executionTree = new Array();
			stack.push("ZZ");
			stack.push(0);
			var next:Token;
			token.loadString(input+"$");
			trace("original input: "+input);
			next = token.nextToken();
			trace("WHAAA? "+next);
			while(next!=null){
				trace("in loop: "+stack);
				var s = next.getSymbol();
				//get state
				var state:int = stack.pop();
				//build the execution stack
				trace("current symbol: "+next.getSymbol()+", state: "+state);
				if(table[state][s]==null){
					trace("UNEXPECTED TOKEN: "+s);
					return null;
				}
				switch(table[state][s].charAt(0)){
					case "s":
						trace("push "+s);
						stack.push(state);
						stack.push(s);
						executionTree.push(s);
						stack.push(table[state][s].substring(1,table[state][s].length));
					break;
					case "r":
						trace("reduce!");
						//construct a node from what we have here.
						var rule = grammar.getRule(int(table[state][s].substring(1,table[state][s].length)));
						var productions = rule.getProductions();
						var args = new Array();
						var lastState = 0;
						for(var i in productions){
							args.push(executionTree.pop());
							stack.pop();
							trace("nom "+i+", "+productions[i]+", "+s);
							lastState = stack.pop();
						}
						stack.push(lastState);
						stack.push(new Token(rule.getLHS(), rule.getLHS()));
						stack.push(table[lastState][rule.getLHS()].substring(1,table[state][s].length));
						trace("pushing "+rule.getLHS());
						//executionTree.push(makeNode(rule.getLHS(), rule.getRHS(), args));
					break;
					//accept case
					case "a":
						//finish!
						trace("Accepted!");
						return executionTree.pop();
					default:
						return null;
				}
				next = token.nextToken();
				
			}
			return null;
			
		}
/*
		private function makeNode(lhs:String, rhs:String,  args:Array){
			switch(lhs){
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
				case "Literal":
					return new LiteralNode(rhs, args);
				break;
				case "FunctionReturn":
					return new FunctionReturnNode(rhs, args);
				break;

			}
		}*/
	};
}
