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

		private var allSymbolSet:TreeSet;

		private var callback:Function;
		private var load:URLLoader;

		public function Grammar(file:String, call:Function){
			rules = new Array();
			ruleMap = new Object();
			derivations = new Object();
			load = new URLLoader();
			allSymbols = new Array();
			load.addEventListener(Event.COMPLETE, buildGrammar);
			load.load(new URLRequest(file));
			callback = call;
			
		}

		private function buildGrammar(e:Event){
			//build the grammar!!
			var loadText:String = load.data;
			
			allSymbolSet = new TreeSet();
			//split rules
			var rule = loadText.split(/\n\s*\n/);
			rules.push("Reserved for S' rule.");
			var counter = 1;
			for(var i =0;i<rule.length;i++){
				var switched:String = rule[i].replace(/(\r|\n)+/g,"$$$");
				var sides = switched.split("->");
				var derivation = switched.split("$$");
				//trace(sides)
				derivation.shift();
				derivation.pop();
				//trace(derivations[sides[0]]);
				if(derivations[sides[0]]==undefined)
					derivations[sides[0]] = new Array();
				for(var j = 0; j < derivation.length; j++){
					recurseRule(sides[0], derivation[j]);
					counter++;
				}
			}

			//construct the symbol array
			var symb:String;
			//allSymbolSet.printAll();
			allSymbolSet.start();
			while((symb = allSymbolSet.nextString()) != null){
				allSymbols.push(symb);
			}

			callback.call();
		}

		private function recurseRule(lhs:String, rhs:String)
		{
			if(rhs.match(/^\/\//)) return;
			if(rhs.match(/\[\S|\S\]/))
			{
				var matched = rhs.match(/\[\S+( \S+)*?\]/);
				//remove first optional portion
				var newRHS = rhs.replace(/\[(\S(.*\S)*)\]/, "$1");
				trace("recursing on "+newRHS);
				recurseRule(lhs, newRHS);
			}
			var cleanedRHS = rhs.replace(/ ?\[\S+( \S+)*?\]/g,"");
			addRule(lhs, cleanedRHS, rules.length);
		}

		public function addRule(lhs:String, rhs:String, ruleindex=-1){
			if(derivations[lhs] == undefined)
				derivations[lhs] = new Array();
			var ruletext = lhs+" -> "+rhs;
			//trace("adding rule: ["+ruletext+"] number "+(ruleindex));
			if(ruleindex < 0 ) 
				ruleindex = rules.length;
			rules[ruleindex] = ruletext;
			derivations[lhs].push(rhs);
			ruleMap[ruletext] = ruleindex;
			var symbols = rhs.split(/\s+/);
			for(var k = 0; k < symbols.length; k++){
				if(symbols[k].length < 1)
					continue;
				//trace("adding "+symbols[k]+" to symbol set");
				allSymbolSet.addString(symbols[k]);
			}

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

		public function printRules(){
			trace("GRAMMAR RULE PRINTAGE!!! "+rules.length);
			for(var i in rules)
				trace(i+": "+rules[i])
		}
	}
}

