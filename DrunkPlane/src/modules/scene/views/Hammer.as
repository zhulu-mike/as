package modules.scene.views
{
	import managers.ResManager;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**
	 * 锤子
	 * @author Administrator
	 * 
	 */	
	public class Hammer extends Sprite
	{
		private var line:Image;
		private var hammer:Image;
		public var isPassed:Boolean = false;
		
		public function Hammer()
		{
			line = new Image(ResManager.assetsManager.getTexture("swing_line.png"));
			this.addChild(line);
			hammer = new Image(ResManager.assetsManager.getTexture("swing_hammer.png"));
			this.addChild(hammer);
			hammer.x = line.width - hammer.width >> 1;
			hammer.y = line.height;
			
		}
	}
}