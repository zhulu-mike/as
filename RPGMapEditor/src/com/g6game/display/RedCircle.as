package com.g6game.display
{
	import flash.display.Shape;
	
	public class RedCircle extends Shape
	{
		
		public function RedCircle()
		{
			this.graphics.beginFill(0xff0000);
			this.graphics.drawCircle(0,0,10);
			this.graphics.endFill();
		}
	}
}