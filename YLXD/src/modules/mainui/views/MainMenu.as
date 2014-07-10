package modules.mainui.views
{
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class MainMenu extends Sprite
	{
		
		public var beginTxt:TextField;
		
		public function MainMenu()
		{
			beginTxt = new TextField(200,30,Language.PUTONG,"Verdaba",20);
			beginTxt.hAlign = HAlign.CENTER;
			beginTxt.vAlign = VAlign.CENTER;
			this.addChild(beginTxt);
			
			new MainMenuController(this);
		}
	}
}