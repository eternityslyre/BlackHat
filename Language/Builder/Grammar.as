/*************************************************************************************
*   A simple class which holds rules and maps rules to numbers.
*   Apparently this will make my life much, much easier!
*******************************************************************************/
package Language.Builder {
	import flash.net.*;
	import flash.events.*;
	public class Grammar {
		//The array of all rules
		private var rules:Array;
		//maps rules to numbers
		private var ruleMap:Object;
		//maps Nonterminals to their derivations
		private var derivations:Object;
		//an array of all symbols; this is kind of useful.
		private var allSymbols:Array;
		//map for remembering lambda rules.
		private var lambda:Object;

		private var callback:Function;
		private var load:URLLoader;

		public function Grammar(file:String, call:Function){
			rules = new Array();
			ruleMap = new Object();
			derivations = new Object();
			lambda = new Object();
			load = new URLLoader();
			allSymbols = new Array();
			load.addEventListener(Event.COMPLETE, buildGrammar);
			load.load(new URLRequest(file));
			callback = call;
			
		}

		private function buildGrammar(e:Event){
			//build the grammar!!
			var loadText:String = load.data;
			
			var symbolSet = new TreeSet();
			//split rules
			var rule = loadText.split(/\n\s*\n/);
			trace(rules);
			var counter = 1;
			for(var i =0;i<rule.length;i++){
				var switched:String = rule[i].replace(/(\r|\n)+/g,"$$$");
				var sides = switched.split("->");
				var derivation = switched.split("$$");
				trace(sides)
				derivation.shift();
				derivation.pop();
				trace(derivations[sides[0]]);
				if(derivations[sides[0]]==undefined)
					derivations[sides[0]] = new Array();
				for(var j = 0; j < derivation.length; j++){
					//TODO: write out permutations for optional derivations
					var ruletext:String = sides[0]+" -> "+derivation[j];
					lambda[derivation[j]] = false;
					trace("adding rule: ["+ruletext+"] number "+(counter));
					ruleMap[ruletext] = counter;
					rules[counter] = ruletext;
					counter++;
					if(derivation[j] == "lambda")
					{
						lambda[derivation[j]] = true;
					}
					derivations[sides[0]].push(derivation[j]);
					var symbols = derivation[j].split(" ");
					for(var k in symbols)
					symbolSet.addString(symbols[k]);
				}
			}

			//construct the symbol array
			var symb:String;
			symbolSet.printAll();
			symbolSet.start();
			while((symb = symbolSet.nextString()) != null){
				allSymbols.push(symb);
			}

			callback.call();
		}

		public function addRule(lhs:String, rhs:String, ruleindex=-1){
			if(derivations[lhs] == undefined)
				derivations[lhs] = new Array();
			if(rhs.match(/\r|\n/g)!=null){
				var splits = rhs.split(/\r|\n/g);
				trace("ADDING RULE: ["+splits+"]");
				for(var s in splits){
					//TODO: make this permute for optional symbols.	
					var matched = rhs.match(/ [\w+.*]/)
					if(matched!= null)
					{
						var withString = rhs.replace(/ [\(\w+.*\)]/,"$&");
						var withoutString = rhs.replace(/ [\(\w+.*\)]/,"");
						addRule(lhs, withString, ruleindex);
						addRule(lhs, withoutString, ruleindex);
					}
					else
						derivations[lhs].push(splits[s]);
				}
			}
			rules[ruleindex] = lhs+" -> "+rhs;

		}

		public function getRule(ruleNumber:int):Rule{
			var ruletext = rules[ruleNumber];
			var sides = ruletext.split(/\s*->\s*/);
			return new Rule(sides[0], sides[1], ruleMap[ruletext]);
		}

		public function getNumber(rule:String):int{
			return ruleMap[rule];
		}

		public function getDerivations(symbol:String):Array{
			return derivations[symbol];
		}

		public function getSymbolSet():Array{
			return allSymbols;
		}

		public function lambdaRule(symbol:String):Boolean{
			return lambda[symbol];
		}

		public function printRules(){
			trace("GRAMMAR RULE PRINTAGE!!! "+rules.length);
			for(var i in rules)
				trace(i+": "+rules[i])
		}
	}
}

