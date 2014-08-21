package modules.scene.views
{
	import flash.geom.Rectangle;
	
	import managers.ResManager;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.BlendMode;
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
			play();
		}
		
		public function play():void
		{
			rotateToLeft();
		}
		
		private function rotateToLeft():void
		{
			var t:Tween = new Tween(this,1);
			t.animate("rotation",45*Math.PI/180);
			t.onComplete = rotateToRight;
			t.repeatCount = 1;
			Starling.juggler.add(t);
		}
		
		private function rotateToRight():void
		{
			var t:Tween = new Tween(this,1);
			t.animate("rotation",-45*Math.PI/180);
			t.onComplete = rotateToLeft;
			t.repeatCount = 1;
			Starling.juggler.add(t);
		}
		
		public function get contentRect():Rectangle
		{
			return this.getBounds(hammer);
		}
	}
}