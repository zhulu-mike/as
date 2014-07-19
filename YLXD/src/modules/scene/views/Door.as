package modules.scene.views
{
	import com.mike.utils.MathUtil;
	
	import managers.DoorUtil;
	import managers.ResManager;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class Door extends Sprite
	{
		
		private var shape:Image; 
		
		public var state:int = 0;
		
		public var passed:Boolean = false;
		
		private var dizuo:Image;
		
		/**
		 * 是否是相反的
		 */		
		public var isReverse:Boolean = false;
		
		private var container:Sprite;
		
		public function Door(state:int, need:Boolean=false)
		{
			container = new Sprite();
			this.addChild(container);
			
			this.state = state;
			isReverse = need;
			shape = DoorUtil.getDoorShape(state,isReverse);
			shape.scaleX = -1;
			shape.x += shape.width;
			container.addChild(shape);
			dizuo = new Image(ResManager.assetsManager.getTexture("dizuo.png"));
			container.addChild(dizuo);
			dizuo.y = shape.height;
			dizuo.x = shape.width - dizuo.width >> 1;
			container.x = -container.width >> 1;
			container.y = -container.height >> 1;
		}
		
		private var _speed:int = 5;

		public function get speed():int
		{
			return _speed;
		}

		public function set speed(value:int):void
		{
			if (_speed != value)
				_speed = value;
		}

		public function updatePos():void
		{
			this.x -= _speed;
		}
		
		public function flyOut():void
		{
			dizuo.removeFromParent();
			var tween:Tween = new Tween(this,1,Transitions.EASE_OUT);
			tween.onComplete = flyComplete;
//			tween.animate("scaleX",0);
//			tween.animate("scaleY",0);
			Starling.juggler.add(tween);
			tween.animate("x",this.x + 200);
			tween.animate("y",0);
			tween.animate("rotation",MathUtil.angleToRadian(1800));
			tween.repeatCount = 1;
		}
		
		private function flyComplete():void
		{
			destroy();
		}
		
		public function destroy():void
		{
			if (this.parent)
			{
				this.removeFromParent();
				DoorUtil.recycleDoorShape(shape,state,isReverse);
			}
		}
	}
}