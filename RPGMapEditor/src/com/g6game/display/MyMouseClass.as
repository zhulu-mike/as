package com.g6game.display
{
	import flash.display.Shape;
	
	
	/**
	 * 
	 * 红色鼠标 
	 */
	public class MyMouseClass extends Shape
	{
		public function MyMouseClass()
		{
			this.graphics.beginFill(0xff0000);
			this.graphics.drawCircle(0,0,10);
			this.graphics.endFill();
		}
	}
}