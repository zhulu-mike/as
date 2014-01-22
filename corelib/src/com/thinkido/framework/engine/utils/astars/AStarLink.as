package com.thinkido.framework.engine.utils.astars
{
	public class AStarLink
	{
		public var node:AStarNode;
		public var cost:Number;
		
		public function AStarLink(node:AStarNode, cost:Number){
			this.node = node;
			this.cost = cost;
		}
		
		public function dispose():void
		{
			node = null;
		}
	}
}