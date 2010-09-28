/******************************************************************************************
*  This class implements the table-building algorithms for converting a grammar
*  into an action table for shift-reduce parsers to use.
*****************************************************************************************/
package Language.Builder {
	import flash.events.*;
	import flash.net.*;
	public class TableBuilder{

		private var ruleMap:Object;
		private var queue:Array;
		private var actionTable;
		private var states:Array;
		//maps state-symbol pairs to new states
		private var stateMap:Array;
		private var ruleStateMap:Object;
		private var grammar:Grammar;
		

		public function TableBuilder(){
			//do nothing.
		}
		/* Takes in a pointer to a space-delimited string. */
		public function Build(grammar:Grammar):Object{
			buildTable(grammar);
			printAll(grammar);
			return actionTable;
		}

		public function buildFromGrammarFile(file:String){
			grammar = new Grammar(file, printAll);
		}

		public function printAll(grammar:Object){
			grammar.printRules();
			var symbols = grammar.getSymbolSet();
			var toprow = "    "
			for(var s in symbols){
				var append = symbols[s].substring(0,3);
				while(append.length < 4) append+=" ";
				toprow += append;
			}
			toprow += "$   ";
			trace(toprow);
			for(var a in actionTable){
				var stringrow = a+": "
				if(stringrow.length<4)
					stringrow = " "+stringrow;
				//trace(actionTable[a]);
				for(var s in symbols){
					if(actionTable[a][symbols[s]] != undefined){
						stringrow += actionTable[a][symbols[s]]+" ";
						if(actionTable[a][symbols[s]].length<3)
							stringrow+=" ";
					}
					else stringrow += "    ";
				}
				stringrow += actionTable[a]["$"]+" ";
				trace(stringrow);
			}

			for(var e in states){
				trace("state "+e+":");
				states[e].printAll();
			}
		}


		public function buildTable(grammar:Grammar){
			actionTable = new Object();
			actionTable[0] = new Object();
			queue = new Array();
			var firstSymbol = grammar.getRule(1).getLHS();
			trace(firstSymbol);
			grammar.addRule("SS",firstSymbol,0);
			states = new Array();
			ruleStateMap = new Object();
			ruleStateMap[grammar.getRule(0).getAnnotatedForm()] = 0;
			stateMap = new Array();
			states[0] = new TreeSet();
			stateMap[0] = new Object();
			stateMap[0][firstSymbol] = undefined;
			states[0].add(new Rule("SS", firstSymbol, 0));
			queue.push(states[0]);
			while(queue.length>0){
				trace(queue.length);
				processState(grammar, queue.shift(), queue.shift(), queue);
			}
				
			
		}

		function processState(grammar:Grammar, set:TreeSet, index:int, queue:Array){
			//compute closure
			var lastSize = set.getSize();
			var tokens = expand(set, grammar);
			while(set.getSize() != lastSize){
				trace(lastSize+", "+set.getSize());
				lastSize = set.getSize();
				tokens = expand(set,grammar);
			}
			set.printAll();
			traverse(tokens, index, queue, grammar);	

		}

		private function expand(set:TreeSet, grammar:Grammar):TreeSet{
			set.start();
			var markedSymbols = new TreeSet();
			var rule = set.next();
			while(rule != null){
				if(!rule.complete()) 
					markedSymbols.addString(rule.getMarked());
				rule = set.next();
			}
			markedSymbols.start();
			var symbol;// = markedSymbols.nextString();
			while((symbol = markedSymbols.nextString()) != null){
				trace("checking "+symbol+" : "+grammar.getDerivations(symbol));
				var productions = grammar.getDerivations(symbol);
				if(productions == undefined) continue;
				for(var i = 0; i < productions.length; i++){
					set.add(new Rule(symbol, productions[i], grammar.getNumber(symbol+" -> "+productions[i])));
				}
				//symbol = markedSymbols.nextString();
			}
			return markedSymbols;
		}

		private function traverse(tokens:TreeSet, startNode:int, queue:Array, grammar:Grammar){
			tokens.start();
			var next = tokens.nextString();
			while(next != null) {
				//trace(next);
				var rules = states[startNode];
				rules.start();
				var currentRule = rules.next();
				while(currentRule!=null){
					//trace(currentRule.getAnnotatedForm());
					if(currentRule.getMarked() == next){
						var newRule = currentRule.acceptToken(next);
						linkOrAdd(newRule, next, startNode, queue, grammar);
					}
					currentRule = rules.next();
				}
				next = tokens.nextString();
			}
		}

		private function linkOrAdd(newRule:Rule, symb:String, lastID:int, queue:Array, grammar:Grammar){
			trace("processing new rule "+newRule.getAnnotatedForm()+", "+lastID+", "+symb+", "+stateMap[lastID][symb]);
			if(stateMap[lastID][symb] == undefined){
				if(ruleStateMap[newRule.getAnnotatedForm()] != undefined){
					stateMap[lastID][symb] = ruleStateMap[newRule.getAnnotatedForm()];
				}
				else {
					var next = nextID();
					trace("making new state for this rule: "+next);
					actionTable[next] = new Object();
					stateMap[lastID][symb] = next;
					stateMap[next] = new Object();
					states[next] = new TreeSet();
					states[next].add(newRule);
					queue.push(states[next]);
					queue.push(next);
					if(newRule.complete()){
						trace("accepting "+symb+" completes rule: "+newRule.getAnnotatedForm()+" number "+newRule.getRuleNumber());
						//EVERY ACTION MUST RESULT IN A REDUCE!
						var symset = grammar.getSymbolSet();
						//THE END!!
						if(newRule.getRuleNumber() != 0){
							for(var s in symset)
								actionTable[next][symset[s]] = "r"+newRule.getRuleNumber();
							actionTable[next]["$"] = "r"+newRule.getRuleNumber();

						}
						else actionTable[next]["$"] = "acc";
					}
					ruleStateMap[newRule.getAnnotatedForm()] = next;
				}
			}
			else if(stateMap[lastID][symb] != lastID && !states[stateMap[lastID][symb]].contains(newRule)){
				states[stateMap[lastID][symb]].printAll();
				trace("Is this rule in here already?? "+newRule.getAnnotatedForm());
				trace(states[stateMap[lastID][symb]].contains(newRule));

				states[stateMap[lastID][symb]].add(newRule);
				queue.push(states[stateMap[lastID][symb]]);
				queue.push(stateMap[lastID][symb]);
			}
			actionTable[lastID][symb] = "s"+stateMap[lastID][symb];
		}

		private function nextID():int {
			return states.length;
		}

	}
}
