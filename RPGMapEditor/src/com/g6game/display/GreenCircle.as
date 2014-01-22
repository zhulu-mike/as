package com.g6game.display
{
	import flash.display.Shape;
	
	public class GreenCircle extends Shape
	{
		public function GreenCircle()
		{
			this.graphics.beginFill(0x00ff00);
			this.graphics.drawCircle(0,0,10);
			this.graphics.endFill();
		}
	}
}