package modules.mainui.views
{
	import com.mike.utils.AirUtil;
	
	import configs.GameInstance;
	
	import managers.GameUtil;
	import managers.ResManager;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class MainMenu extends Sprite
	{
		
		public var beginTxt:TextField;
		public var niXiangTxt:TextField;
		public var duizhan:TextField;
		public var desc:TextField;
		public var log:Image;
		private var menuContainer:Sprite;
		
		public function MainMenu()
		{
			
			menuContainer = new Sprite();
			this.addChild(menuContainer);
			
			var ratio:Number = GameInstance.instance.scaleRatio;
			var f:Number = 120 * ratio;
			beginTxt = new TextField(640*ratio,AirUtil.getHeightByFontSize(f),Language.getString("PUTONG"),"Verdaba",f,0xffffff);
			beginTxt.hAlign = HAlign.CENTER;
			beginTxt.vAlign = VAlign.TOP;
			beginTxt.filter = GameUtil.getTextFieldFIlter();
			menuContainer.addChild(beginTxt);
			
			niXiangTxt = new TextField(640*ratio,AirUtil.getHeightByFontSize(f),Language.getString("NIXIANG"),"Verdaba",f,0xffffff);
			niXiangTxt.hAlign = HAlign.CENTER;
			niXiangTxt.vAlign = VAlign.TOP;
			menuContainer.addChild(niXiangTxt);
			niXiangTxt.filter = GameUtil.getTextFieldFIlter();
			niXiangTxt.y = beginTxt.y + beginTxt.height + 30;
			
			duizhan = new TextField(640*ratio,AirUtil.getHeightByFontSize(f),Language.getString("DUIZHAN"),"Verdaba",f,0xffffff);
			duizhan.hAlign = HAlign.CENTER;
			duizhan.vAlign = VAlign.TOP;
			menuContainer.addChild(duizhan);
			duizhan.filter = GameUtil.getTextFieldFIlter();
			duizhan.y = niXiangTxt.y + niXiangTxt.height + 30;
			
			log = new Image(ResManager.assetsManager.getTexture("logo"));
			this.addChild(log);
			log.scaleX= log.scaleY = ratio;
			log.x = 5;
			
			desc = new TextField(600*ratio,AirUtil.getHeightByFontSize(50*ratio),Language.getString("ADVISE_DESC"),"Verdana",50*ratio,0xffffff);
			desc.hAlign = HAlign.LEFT;
			desc.vAlign = VAlign.TOP;
			desc.filter = GameUtil.getTextFieldFIlter();
			this.addChild(desc);
			var descH:Number = desc.height;
			var logH:Number = log.height;
			if (descH > logH )
			{
				desc.y = 10;
				log.y = desc.y + (descH-logH>>1);
			}else{
				log.y = 10;
				desc.y = log.y + (logH-descH>>1);
			}
			desc.x = log.width + 5;
			new MainMenuController(this);
			
			menuContainer.x = GameInstance.instance.sceneWidth - menuContainer.width >> 1;
			menuContainer.y = GameInstance.instance.sceneHeight - menuContainer.height >> 1;
		}
	}
}