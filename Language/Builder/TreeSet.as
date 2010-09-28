package Language.Builder {
	//WHY DOES FLASH NOT HAVE SETS AHHHH
	public class TreeSet{
		private var lhs:TreeSet;
		private var rhs:TreeSet;
		public var value:Rule;
		private var stringvalue:String;
		private var iterated:Boolean;
		private var size:int;

		public function TreeSet(){
			iterated = false;
			size = 0;
		}

		public function getSize():int{
			return size;
		}

		public function add(s:Rule):Boolean{
			if(value==null){
				value = s;
				size++;
				return true;
			}
			var compare = value.localeCompare(s);
			if(compare == 0) return false;
			if(compare > 0) {
				if(rhs == null) rhs = new TreeSet();
				if(rhs.add(s)){
					size++;
					return true;
				}
				return false;
			}
			if(lhs == null) lhs = new TreeSet();
			if(lhs.add(s)){
				size++;
				return true;
			}
			return false;
		}

		public function addString(s:String):Boolean{
			if(stringvalue==null){
				stringvalue = s;
				size++;
				return true;
			}
			var compare = stringvalue.localeCompare(s);
			if(compare == 0) return false;
			if(compare > 0) {
				if(rhs == null) rhs = new TreeSet();
				if(rhs.addString(s)){
					size++;
					return true;
				}
				return false;
			}
			if(lhs == null) lhs = new TreeSet();
			if(lhs.addString(s)){
				size++;
				return true;
			}
			return false;
		}
		
		public function containsString(key:String){
			//just in case
			if(stringvalue == null) return false;
			if(stringvalue==key) return true;
			if(stringvalue.localeCompare(key)<0)
				return lhs == null ? false : lhs.containsString(key);
			return rhs == null ? false : rhs.containsString(key);
		}

		public function contains(key:Rule){
			//just in case
			if(value == null) return false;
			if(value.localeCompare(key)==0) return true;
			if(value.localeCompare(key)<0)
				return lhs == null ? false : lhs.contains(key);
			return rhs == null ? false : rhs.contains(key);
		}

		public function removeString(key:String){
			size--;
			var compare = stringvalue.localeCompare(key);
			if(compare<0) lhs.removeString(key);
			if(compare>0) rhs.removeString(key);
			if(key==stringvalue){
				if(lhs == null && rhs == null) stringvalue = null;
				var chosen = null;
				if(lhs == null) chosen = rhs;
				if(rhs == null) chosen = lhs;
				if(chosen == null) chosen = Math.random()>0.5 ? rhs : lhs;
				stringvalue = chosen.stringvalue;
				chosen.remove(stringvalue);
			}
		}

		public function remove(key:Rule){
			size--;
			var compare = value.localeCompare(key);
			if(compare<0) lhs.remove(key);
			if(compare>0) rhs.remove(key);
			if(key==value){
				if(lhs == null && rhs == null) value = null;
				var chosen = null;
				if(lhs == null) chosen = rhs;
				if(rhs == null) chosen = lhs;
				if(chosen == null) chosen = Math.random()>0.5 ? rhs : lhs;
				value = chosen.value;
				chosen.remove(value);
			}
		}

		public function resetIterator(){
			iterated = false;
			if(lhs!=null)
			lhs.resetIterator();
			if(rhs!=null)
			rhs.resetIterator();
		}

		public function start(){
			resetIterator();
		}

		public function nextString():String{
			if(!iterated){
				iterated = true;
				return stringvalue;
			}
			var out:String;
			if(lhs!=null && (out = lhs.nextString()) !=null)
				return out;
			if(rhs != null && (out = rhs.nextString()) !=null)
				return out;
			return null;
		}

		public function next(){
			if(!iterated){
				iterated = true;
				return value;
			}
			var out:Rule;
			if(lhs!=null && (out = lhs.next())!=null)
				return out;
			if(rhs != null && (out = rhs.next())!=null)
				return out;
			return null;
		}

		private function hasIterated(){
			return iterated;
		}


		public function addAllStrings(set:TreeSet){
			set.start();
			var current = set.nextString();
			while(current!=null){
				add(current);
				current = set.nextString();
			}
		}

		public function addAll(set:TreeSet){
			set.start();
			var current = set.next();
			while(current!=null){
				add(current);
				current = set.next();
			}
		}

		public function printAll(){
			var rule = value;
			if(value!=null)
				rule = value.getAnnotatedForm()
			trace(rule+", "+stringvalue);
			if(lhs!=null)
			lhs.printAll();
			if(rhs!=null)
			rhs.printAll();
		}
	}
}
