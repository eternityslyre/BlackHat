﻿package Language.Tokens{
	
	public class Trie {
		//consts representing types

		private var children:Object;
		private var type:int;
		private var hasChildren:Boolean;
		
		public function Trie() {
			children = new Object();
			hasChildren = false;
			type = -1; //TYPE_INVALID;
		}

		public function parseTokenType(s:String, index:int = 0):int{
			if(s.length == index)
				return type;
			if(children[s.charAt(index)] == null) 
				return -1;
			return children[s.charAt(index)].parseTokenType(s,index+1);
		}

		public function isSubstring(s:String, index:int = 0){
			if(s.length == index )
				return hasChildren;
			if(children[s.charAt(index)] == null)
				return false;
			return children[s.charAt(index)].isSubstring(s,index+1);
		}
		
		public function add(s:String, tokentype:int, index:int = 0){
			if(index  == s.length)
				type = tokentype;
			else {
				var character:String = s.charAt(index);
				if(children[character]==null){
					children[character] = new Trie();
					hasChildren = true;
				}
				children[character].add(s, tokentype, index+1);
			}
		}
		
	}
}
