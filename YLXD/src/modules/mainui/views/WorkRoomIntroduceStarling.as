package modules.mainui.views
{
	import com.mike.utils.AirUtil;
	
	import configs.GameInstance;
	
	import managers.GameUtil;
	
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
			
			var ratio:Number = GameInstance.instance.scaleRatio;
			
			var bp:Image = new Image(Texture.fromEmbeddedAsset(GameInstance.instance.LOG_CLASS));
			container.addChild(bp);
			bp.scaleX = bp.scaleY = ratio;
			var bw:Number = bp.width;
			var nw:int = 1500*ratio;
			bp.x = nw - bw >> 1;
			
			var s:int = 94*ratio;
			var desc:TextField = new TextField(nw,AirUtil.getHeightByFontSize(94*ratio),Language.getString("WORKROOM_DESC"),"Verdana",s,0x00ffff);
			desc.y = bp.height + 32*ratio;
			container.addChild(desc);
			desc.filter = GameUtil.getTextFieldFIlter();
			
			s = 64 * ratio;
			var author:TextField = new TextField(nw,AirUtil.getHeightByFontSize(64*ratio),Language.getString("ZHIZUOREN"),"Verdana",s,0x89c997);
			author.y = desc.y + desc.height + s;
			container.addChild(author);
			author.filter = GameUtil.getTextFieldFIlter();
			
			var weibo:TextField = new TextField(nw,AirUtil.getHeightByFontSize(64*ratio),Language.getString("WEIBO"),"Verdana",s,0x89c997);
			weibo.y = author.y + author.height + s;
			container.addChild(weibo);
			weibo.filter = GameUtil.getTextFieldFIlter();
			
			container.x = w - container.width >> 1;
			container.y = h - container.height >> 1;
			this.flatten();
		}
	}
}