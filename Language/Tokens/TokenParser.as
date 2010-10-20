/*****************************************************************************************
* The token parsing class; given the source file that lists all characters and tokens,
* it builds a Trie and returns tokens.
* NOTE: I'm putting the regex recognition code in here... I don't really want to 
* make a whole other Tokenizer class.
******************************************************************************************/

package Language.Tokens {
	import flash.events.*;
	import flash.net.*;
	public class TokenParser {
		//declare constants

		private var tokenMapping:Object;
		private var dictionary:Trie;
		private var regularTypes:Object;
		private var lastError:String;
		private var code:String;
		private var scanIndex;
		private var index:int;
		private var isToken:Object;
		private var punctuation:Object;
		private var lexicon:Object;
		private var load:URLLoader;
		private var lexload:URLLoader;
		private var callback:Function;

		//SIGH
		private var loadtime:int;

		public function TokenParser(tokens:String, characters:String, call:Function){
			tokenMapping = new Object();
			loadtime = 0;
			regularTypes = new Object();
			lexicon = new Object();
			punctuation = new Object();
			dictionary = new Trie();
			load = new URLLoader();
			load.addEventListener(Event.COMPLETE, loadWords);
			load.load(new URLRequest(tokens));
			lexload = new URLLoader();
			lexload.addEventListener(Event.COMPLETE, loadLexicon);
			lexload.load(new URLRequest(characters));
			callback = call;
		}

		private function tryParse(){
			loadtime++;
			if(loadtime>1)
				callback.call();
		}

		private function loadLexicon(e:Event){
			var loadText:String = lexload.data;
			var types = loadText.split(/\s+/);
			//load alphanumeric
			for(var i = 0; i < types[0].length; i++){
				//trace("adding "+types[0].charAt(i));
				lexicon[types[0].charAt(i)] = true;
			}
			for(var i = 0; i < types[1].length; i++){
				//trace("adding "+types[1].charAt(i));
				lexicon[types[1].charAt(i)] = true;
				punctuation[types[1].charAt(i)] = true;
			}
			lexicon["$"] = true;
			tryParse();
		}
		
		private function loadWords(e:Event){
			//trace("Words loaded! Initializing...");
			//split out the token classes.
			var loadText:String = load.data;
			var tokenClasses:Array = loadText.match(/\w+:/g);
			var tokenClassTypes:Array = loadText.split(/\w+:/);
			//trace(tokenClasses.length+", "+tokenClassTypes.length);
			for(var i = 0; i < tokenClasses.length; i++){
				//build the tokenclass
				tokenMapping[i] = [tokenClasses[i].substring(0,tokenClasses[i].length-1)];
				tokenMapping[tokenClasses[i].substring(0, tokenClasses[i].length-1)] = i;
				//trace("mapping: "+tokenMapping[i]+", to "+i+", as shown: "+tokenMapping[tokenClasses[i].substring(0, tokenClasses[i].length-1)]);
				//if it's a regex, handle it accordingly.
				//trace("match test: "+tokenClassTypes[i+1].match(/\/\S+\//));
				if(tokenClassTypes[i+1].match(/\/\S+\//)!=null){
					//trace("adding regex: "+tokenClasses[i].substring(0, tokenClasses[i].length-1)+" "+tokenClassTypes[i+1].replace(/\s+/g,"")+"end");
					regularTypes[i] = new RegExp(tokenClassTypes[i+1].replace(/\/|\s+|\n|\r/g,""));
				}
				else{
					var tokens:Array = tokenClassTypes[i+1].split(/\s+/);
					for(var s:String in tokens){
						//trace(tokenClasses[i]+" added "+tokens[s]);
						if(tokens[s].length >0)
						dictionary.add(tokens[s], i);
					}
				}
				dictionary.add("$",0);
			}
			tryParse();
			
		}


		private function identify(s:String) : int{
			if(dictionary.isToken(s)>=0)
				return tokenMapping[dictionary.isToken(s)];
			else {
				for(var typename in regularTypes){
					//trace("testing [["+s+"]] for type "+tokenMapping[typename]+", index: "+tokenMapping[typename]);
					//trace(regularTypes[typename]);
					if(regularTypes[typename].test(s))
						return typename;
				}
				return -1;
			}
		}

		//if this returns null, call getErrorString to get
		// the error.
		public function loadString(s:String){
			index = 0;
			code = s;
		}
		
		//should always be a single character
		private function invalidCharacter(s:String){
			//trace("checking "+s+": "+lexicon[s]+", "+punctuation[s]);
			return lexicon[s] == undefined;// || punctuation[s] != undefined;
		}

		public function nextToken():Token{
			//trace("start: "+code+", "+index+", ["+code.charAt(index)+"]");
			scanIndex = index;
			var current = "";
			//if current character is invalid, check if it's a 
			//keyword. If not, ignore it.
			if(invalidCharacter(code.charAt(index))){
				index++;
				if(identify(code.charAt(index-1))>=0){
					return tokenify(code.charAt(index-1));
				}
					
			}

			//skip invalid characters
			while(lexicon[code.charAt(scanIndex)] == undefined && scanIndex < code.length){
				//trace("skip "+code.charAt(scanIndex)+", next is ["+code.charAt(scanIndex+1)+"]");
				scanIndex++;
			}
			//parse until the next invalid character
				//trace((invalidCharacter(code.charAt(scanIndex)))+", "+(scanIndex<code.length));
			while(!invalidCharacter(code.charAt(scanIndex))&&scanIndex<code.length){
				//trace("append");
				//trace((invalidCharacter(code.charAt(scanIndex)))+", "+(scanIndex<code.length));
				current+=code.charAt(scanIndex);
				scanIndex++;
			}

			var out = tokenify(current);
			if(out!=null){
				//trace("Moving index! Found "+out.getSymbol() +", "+scanIndex+", "+index);
				index = scanIndex;
			}
			else {
				lastError = "INVALID TOKEN: ["+current+"]";
				trace(lastError);
			}
			return out;
		}
		
		private function tokenify(s:String){
			if(s.length <= 0) return null;
			if(identify(s) > 0)
				return new Token(tokenMapping[identify(s)],s);
			if(identify(s)==0)
				return new Token(s,s);
			
			//trace("backtrack! "+s+", scanindex at "+scanIndex);
			//no valid token found; backtrack one character and try again.
			scanIndex--;
			return tokenify(s.substring(0,scanIndex-index));		
		}
	}
}

