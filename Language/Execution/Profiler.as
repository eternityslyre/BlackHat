/************************************************
* Dodgy profiler. Dodgy.
************************************************/
package Language.Execution
{
	public class Profiler 
	{
		private var profile:Object;
		private var cycle:int;
		private var maxCycle:int;
		public function Profiler()
		{
			cycle = 0;
			maxCycle = -1;
			profile = new Object();
		}

		public function tick(name:String, count:int = 1)
		{
			cycle+=count;
			if(profile[name] === undefined)
				profile[name] = 0;
			profile[name]++;
		}

		public function exceeded()
		{
			return maxCycle > 0 && cycle > maxCycle;
		}

		public function setMaxCycle(max:int)
		{
			maxCycle = max;
		}

		public function report():String
		{
			var out = "";
			trace("total cycles spent: "+cycle);
			out +="total cycles spent: "+cycle+"\n";
			for( var name in profile)
			{
				trace(name+": "+profile[name]);
				out+=name+": "+profile[name]+"\n";
			}
			return out;
		}
	}
}
