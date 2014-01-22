package com.thinkido.framework.engine.utils.astars
{
	public class AStarNode
	{
		public var x:int;
		public var y:int;
		public var f:Number;
		public var g:Number;
		public var h:Number;
		public var walkable:Boolean = true;
		public var parent:AStarNode;
		//public var costMultiplier:Number = 1.0;
		public var version:int = 1;
		public var links:Array;
		
		//public var index:int;
		public function AStarNode(x:int, y:int){
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			parent = null;
			if (links == null || (links && links.length <= 0))
				return;
			var i:int = 0, len:int = links.length;
			for (;i<len;i++)
			{
				links[i].dispose();	
			}
		}
	}
}