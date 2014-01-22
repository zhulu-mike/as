package com.g6game.display
{
	import flash.display.Sprite;
	
	public class BaseGround extends Sprite
	{
		public function BaseGround()
		{
		
		}
		
		public function setMouseEnable(value:Boolean):void
		{
			this.mouseEnabled = this.mouseChildren = value;
		}
	}
}