package modules.mainui.views
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import configs.GameInstance;
	
	public class WorkRoomIntroduce extends flash.display.Sprite
	{
		
		
		private var container:Sprite;
		public function WorkRoomIntroduce()
		{
			container = new Sprite();
			this.addChild(container);
			
			var bp:Bitmap = new Bitmap(new GameInstance.instance.LOG_CLASS().bitmapData);
			container.addChild(bp);
			
//			var desc:TextField = new TextField();
//			desc.width = 500;
//			desc.wordWrap = true;
//			desc.y = bp.height + 20;
//			desc.defaultTextFormat = new TextFormat(null,30,0,null,null,null,null,null,"center");
//			desc.text = Language.WORKROOM_DESC2;
//			desc.height = desc.textHeight + 10;
//			container.addChild(desc);
			
//			var author:TextField = new TextField();
//			author.width = 500;
//			author.wordWrap = true;
//			author.defaultTextFormat = new TextFormat(null,30,0,null,null,null,null,null,"center");
//			author.text = Language.ZHIZUOREN;
//			author.height = 40;
//			author.y = desc.y + desc.height + 20;
//			container.addChild(author);
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