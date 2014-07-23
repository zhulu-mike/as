package modules.mainui.views
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import configs.GameInstance;
	
	public class WorkRoomIntroduce extends flash.display.Sprite
	{
		
		
		private var container:Sprite;
		public function WorkRoomIntroduce()
		{
			container = new Sprite();
			this.addChild(container);
			
			var bp:Bitmap = new Bitmap(new GameInstance.instance.LOG_CLASS().bitmapData);
			bp.scaleX = bp.scaleY = GameInstance.instance.scaleRatio;
			container.addChild(bp);
		}
		
		public function resize(w:int, h:int):void
		{
			this.graphics.beginFill(0x1b1b1b);
			this.graphics.drawRect(0,0,w,h);
			this.graphics.endFill();
			container.x = w - container.width >> 1;
			container.y = h - container.height >> 1;
		}
	}
}