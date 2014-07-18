package modules.mainui.views
{
	import configs.GameInstance;
	
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class MainMenu extends Sprite
	{
		
		public var beginTxt:TextField;
		public var niXiangTxt:TextField;
		public var duizhan:TextField;
		public var scoreTtx:TextField;
		public var desc:TextField;
		
		public function MainMenu()
		{
			
			scoreTtx = new TextField(300,60,Language.FENSHU,"Verdaba",40,0xffffff);
			scoreTtx.hAlign = HAlign.CENTER;
			scoreTtx.vAlign = VAlign.CENTER;
			this.addChild(scoreTtx);
			scoreTtx.x = GameInstance.instance.sceneWidth - scoreTtx.width >> 1;
			scoreTtx.visible = false;
			
			beginTxt = new TextField(200,50,Language.PUTONG,"Verdaba",30,0xffffff);
			beginTxt.hAlign = HAlign.CENTER;
			beginTxt.vAlign = VAlign.CENTER;
			this.addChild(beginTxt);
			beginTxt.y = (GameInstance.instance.sceneHeight - beginTxt.height >> 1) - 70;
			beginTxt.x = GameInstance.instance.sceneWidth - beginTxt.width >> 1;
			
			niXiangTxt = new TextField(200,50,Language.NIXIANG,"Verdaba",30,0xffffff);
			niXiangTxt.hAlign = HAlign.CENTER;
			niXiangTxt.vAlign = VAlign.CENTER;
			this.addChild(niXiangTxt);
			niXiangTxt.y = beginTxt.y + 60;
			niXiangTxt.x = GameInstance.instance.sceneWidth - niXiangTxt.width >> 1;
			
			scoreTtx.y = beginTxt.y - 30 - scoreTtx.height;
			
			duizhan = new TextField(200,50,Language.DUIZHAN,"Verdaba",30,0xffffff);
			duizhan.hAlign = HAlign.CENTER;
			duizhan.vAlign = VAlign.CENTER;
			this.addChild(duizhan);
			duizhan.y = niXiangTxt.y + 60;
			duizhan.x = GameInstance.instance.sceneWidth - duizhan.width >> 1;
			
			desc = new TextField(300,40,Language.ADVISE_DESC,"Verdana",15,0xffffff);
			desc.hAlign = HAlign.LEFT;
			this.addChild(desc);
			desc.y = 0;
			new MainMenuController(this);
		}
	}
}