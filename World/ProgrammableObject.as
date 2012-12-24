/***********************************************************************
* This class defines the basics of any object which has in-game code  
* components. Most notably, it provides an override for 
* OnEnterFrame, which calls Animate and Execute.
***********************************************************************/
package World
{
	import flash.display.MovieClip;
	import flash.events.*;
	import Language.Execution.*;
	public class ProgrammableObject extends ActiveObject //implements IProgrammable
	{
		private var world:World;
		private var loaded:Boolean = false;
		private var executionTree:ExecutionNode;
		private var code:String;
		private var loadConsole:Function;
		public var code:String;

		/* Constructor to pull out all properties available for call and edit */
		public function ProgrammableObject(txt:String = null)
		{
			code = txt;
			addEventListener(MouseEvent.ROLL_OVER, rolledOver);
		}

		public function setConsoleCallback(f:Function)
		{
			loadConsole = f;
		}

		public function rolledOver(e:Event)
		{
			//This is because not all ProgrammableObjects are necesarily Vulnerable...
			if(loadConsole != null)
				loadConsole(this);
		}

		public override function update(tick:Number)
		{
			updateProgrammable(tick);
			execute();
		}

		/* Dummy function */
		public function updateProgrammable(tick:Number)
		{}

		public function setCode(tree:ExecutionNode)
		{
			executionTree = tree;
		}

		public function execute()
		{
			if(executionTree != null)
				executionTree.run();
		}
	}
}
