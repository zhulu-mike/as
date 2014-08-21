package modules.scene.views
{
	import flash.geom.Point;
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
		private var keyHitPoints:Array = [];
		
		public function Hammer()
		{
			line = new Image(ResManager.assetsManager.getTexture("swing_line.png"));
			this.addChild(line);
			hammer = new Image(ResManager.assetsManager.getTexture("swing_hammer.png"));
			this.addChild(hammer);
			hammer.x = line.width - hammer.width >> 1;
			hammer.y = line.height;
			keyHitPoints.push(new Point(10,15));
			keyHitPoints.push(new Point(17,25));
			keyHitPoints.push(new Point(10,45));
			keyHitPoints.push(new Point(17,50));
			keyHitPoints.push(new Point(17,75));
			keyHitPoints.push(new Point(10,70));
			keyHitPoints.push(new Point(17,85));
			keyHitPoints.push(new Point(-37,100));
			keyHitPoints.push(new Point(-37,157));
			keyHitPoints.push(new Point(54,100));
			keyHitPoints.push(new Point(54,157));
			play();
		}
		
		public function play():void
		{
			rotateToLeft();
		}
		
		private function rotateToLeft():void
		{
			var t:Tween = new Tween(this,1);
			t.animate("rotation",30*Math.PI/180);
			t.onComplete = rotateToRight;
			t.repeatCount = 1;
			Starling.juggler.add(t);
		}
		
		private function rotateToRight():void
		{
			var t:Tween = new Tween(this,1);
			t.animate("rotation",-30*Math.PI/180);
			t.onComplete = rotateToLeft;
			t.repeatCount = 1;
			Starling.juggler.add(t);
		}
		
		public function get contentRect():Rectangle
		{
			var r:Rectangle = this.parent.getBounds(hammer);
			return r;
		}
		
		public function get keyPoints():Array
		{
			var p:Point;
			var ret:Array = [];
			var r:Number = this.rotation;
			var np:Point;
			for each (p in keyHitPoints)
			{
				np = new Point();
//				if (r >= 0){
					np.x = -p.y * Math.sin(r)+p.x;
					np.y = p.y * Math.cos(r);
//				}else{
//					np.x = -p.y * Math.sin(r)+p.x;
//					np.y = p.y * Math.cos(r);
//				}
				np.x += this.x;
				np.y += this.y;
				ret.push(np);
			}
			return ret;
		}
	}
}