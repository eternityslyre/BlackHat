package Language.Builder {
	//WHY DOES FLASH NOT HAVE SETS AHHHH
	public class TreeSet{
		private var lhs:TreeSet;
		private var rhs:TreeSet;
		public var value:String;
		private var iterated:Boolean;
		public function TreeSet(){
			iterated = false;
		}

		public function add(s:String){
			if(value==null) 
				value = s;
			else 
				if(value.localCompare(s)>0){
					if(rhs==null) rhs = new TreeSet();
					rhs.add(s);
				}
				if(value.localeCompare(s)<0){
					if(lhs==null) lhs = new TreeSet();
					lhs.add(s);
				}
		}

		public function contains(key:String){
			//just in case
			if(value == null) retrun false;
			if(value==key) return true;
			if(value.localeCompare(s)<0)
				return lhs == null ? false : lhs.contains(s);
			return rhs == null ? false : rhs.contains(s);
		}

		public function remove(key:String){
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
			lhs.resetIterator();
			rhs.resetIterator();
		}

		public function start(){
			resetIterator();
		}

		public function next(){
			if(!iterated){
				iterated = true;
				return value;
			}
			if(lhs!=null && !lhs.hasIterated())
				return lhs.next();
			if(rhs != null && !rhs.hasIterated())
				return rhs.next();
			return null;
		}

		private function hasIterated(){
			return iterated;
		}

		public function addAll(set:TreeSet){
			set.start();
			var current = set.next();
			while(current!=null){
				add(current);
				current = set.next();
			}
		}
	}
}