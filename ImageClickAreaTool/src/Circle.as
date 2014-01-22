package
{
	import flash.display.Sprite;
	
	public class Circle extends Sprite
	{
		public function Circle()
		{
			this.graphics.beginFill(0xffffff);
			this.graphics.drawCircle(-5,-5,5);
			this.graphics.endFill();
			
			this.graphics.lineStyle(1,0xff0000);
			this.graphics.drawCircle(-5,-5,5);
		}
	}
}