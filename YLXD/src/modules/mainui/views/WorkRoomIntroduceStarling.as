package modules.mainui.views
{
	import configs.GameInstance;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class WorkRoomIntroduceStarling extends Sprite
	{
		private var container:Sprite;
		private var bg:Quad;
		
		public function WorkRoomIntroduceStarling(w:int, h:int)
		{
			this.touchGroup = true;
			bg = new Quad(w,h,0x1b1b1b);
			this.addChild(bg);
			
			container = new Sprite();
			this.addChild(container);
			
			var bp:Image = new Image(Texture.fromEmbeddedAsset(GameInstance.instance.LOG_CLASS));
			container.addChild(bp);
			bp.x = 500 - bp.width >> 1;
			
			var desc:TextField = new TextField(500,40,Language.WORKROOM_DESC,"Verdana",30,0x00ffff);
			desc.y = bp.height + 10;
			container.addChild(desc);
			
			var author:TextField = new TextField(500,40,Language.ZHIZUOREN,"Verdana",20,0x89c997);
			author.y = desc.y + desc.height + 20;
			container.addChild(author);
			
			container.x = w - container.width >> 1;
			container.y = h - container.height >> 1;
		}
	}
}