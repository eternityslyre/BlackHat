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
		private var terminate:Boolean;
		

		public function TableBuilder(){
			//do nothing.
		}
		/* Takes in a pointer to a space-delimited string. */
		public function Build(grammar:Grammar):Object{
			buildTable(grammar);
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
				for(var symb in symbols){
					if(actionTable[a][symbols[s]] != undefined){
						stringrow += actionTable[a][symbols[symb]]+" ";
						if(actionTable[a][symbols[symb]].length<3)
							stringrow+=" ";
					}
					else stringrow += "    ";
				}
				stringrow += actionTable[a]["$"]+" ";
				trace(stringrow);
			}
		}

		public function printStates()
		{
			for(var state in states)
			{
				states[state].start();
				trace("STATE: "+state+" =====================================");
				var rule = states[state].next();
				while((rule = states[state].next()) != null)
				{
					trace(rule.getAnnotatedForm());
				}
				trace("END STATE: "+state+" =====================================");
			}
		}


		public function buildTable(grammar:Grammar){
			terminate = false;
			actionTable = new Object();
			actionTable[0] = new Object();
			queue = new Array();
			var firstSymbol = grammar.getRule(1).getLHS();
			//trace(firstSymbol);
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
			queue.push(0);
			while(queue.length>0){
				processState(grammar, queue.shift(), queue.shift(), queue);
				if(terminate)break;
			}
		}

		function processState(grammar:Grammar, set:TreeSet, index:int, queue:Array){
			//compute closure
			var lastSize = set.getSize();
			var tokens = expand(set, grammar);
			while(set.getSize() != lastSize){
				//trace(lastSize+", "+set.getSize());
				lastSize = set.getSize();
				tokens = expand(set,grammar);
				if(terminate)break;
			}
			traverse(tokens, index, queue, grammar);	

		}

		private function expand(set:TreeSet, grammar:Grammar):TreeSet{
			set.start();
			var markedSymbols = new TreeSet();
			var rule = set.next();
			while(rule != null){
				if(!rule.complete()){ 
					markedSymbols.addString(rule.getMarked());
				}
				rule = set.next();
				if(terminate)break;
			}
			markedSymbols.start();
			var symbol;// = markedSymbols.nextString();
			while((symbol = markedSymbols.nextString()) != null){
				//trace("checking "+symbol+" : "+grammar.getDerivations(symbol));
				var productions = grammar.getDerivations(symbol);
				if(productions == undefined) continue;
				for(var i = 0; i < productions.length; i++){
					set.add(new Rule(symbol, productions[i], grammar.getNumber(symbol+" -> "+productions[i])));
				}
				if(terminate)break;
				//symbol = markedSymbols.nextString();
			}
			return markedSymbols;
		}

		private function traverse(tokens:TreeSet, startNode:int, queue:Array, grammar:Grammar){
			tokens.start();
			var next = tokens.nextString();
			while(next != null) {
				////trace(next);
				var rules = states[startNode];
				rules.start();
				var currentRule = rules.next();
				while(currentRule!=null){
					////trace(currentRule.getAnnotatedForm());
					if(currentRule.getMarked() == next){
						var newRule = currentRule.acceptToken(next);
						linkOrAdd(newRule, next, startNode, queue, grammar);
					}
					currentRule = rules.next();
					if(terminate)break;
				}
				next = tokens.nextString();
			}
		}

		private function linkOrAdd(newRule:Rule, symb:String, lastID:int, queue:Array, grammar:Grammar){
			//trace("processing new rule "+newRule.getAnnotatedForm()+", "+lastID+", "+symb+", "+stateMap[lastID][symb]);
			if(stateMap[lastID][symb] == undefined){
				if(ruleStateMap[newRule.getAnnotatedForm()] != undefined){
					stateMap[lastID][symb] = ruleStateMap[newRule.getAnnotatedForm()];
				}
				else {
					for(var key in ruleStateMap)
					{
						//trace(key+": "+ruleStateMap[key]);
					}
					var next = nextID();
					//trace("making new state for this rule: "+next);
					actionTable[next] = new Object();
					stateMap[lastID][symb] = next;
					stateMap[next] = new Object();
					states[next] = new TreeSet();
					states[next].add(newRule);
					queue.push(states[next]);
					queue.push(next);
					writeRule(grammar, newRule, next);
					ruleStateMap[newRule.getAnnotatedForm()] = next;
				}
			}
			else if(stateMap[lastID][symb] != lastID && !states[stateMap[lastID][symb]].contains(newRule)){
				//trace("Is this rule in here already?? "+newRule.getAnnotatedForm());
				//trace(states[stateMap[lastID][symb]].contains(newRule));
				ruleStateMap[newRule.getAnnotatedForm()] = stateMap[lastID][symb];
				var nextState = stateMap[lastID][symb];
				writeRule(grammar, newRule, nextState);
				states[stateMap[lastID][symb]].add(newRule);
				queue.push(states[stateMap[lastID][symb]]);
				queue.push(stateMap[lastID][symb]);
			}
			var original = actionTable[lastID][symb];
			//if(original !== undefined && original != "s"+stateMap[lastID][symb])
				//trace("replacing "+original+" with "+"s"+stateMap[lastID][symb]);
			actionTable[lastID][symb] = "s"+stateMap[lastID][symb];
		}

		private function writeRule(grammar:Grammar, newRule:Rule, next:int)
		{
			if(newRule.complete())
			{
				//trace("STATE "+next+" ACCEPTS "+symb+" to complete rule: "+newRule.getAnnotatedForm()+" number "+newRule.getRuleNumber());
				//EVERY ACTION MUST RESULT IN A REDUCE!
				var symset = grammar.getSymbolSet();
				//THE END!!
				if(newRule.getRuleNumber() != 0)
				{
					for(var s in symset)
					{
						var originalValue = actionTable[next][symset[s]];
						if(originalValue !== undefined)
						{
							//trace("replacing "+original+" with "+"r"+newRule.getRuleNumber());
						}
						if(actionTable[next][symset[s]]!= undefined){
							trace("OVERWRITING A SHIFT RUEL!!:!");
							trace("state "+next+", symbol "+symset[s]+",  original rule "+actionTable[next][symset[s]]);
							trace("replacing with "+"r"+newRule.getRuleNumber());
							terminate = true;
							return;
						}
						actionTable[next][symset[s]] = "r"+newRule.getRuleNumber();
					}
					actionTable[next]["$"] = "r"+newRule.getRuleNumber();
				}
				else actionTable[next]["$"] = "acc";
			}
		}

		private function nextID():int {
			return states.length;
		}

	}
}
