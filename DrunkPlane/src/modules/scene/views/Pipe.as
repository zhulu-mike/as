package modules.scene.views
{
	import flash.geom.Rectangle;
	
	import configs.GameInstance;
	import configs.PipeDirection;
	
	import managers.DoorUtil;
	import managers.ResManager;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	public class Pipe extends Sprite
	{
		
		private var _arrow:int = 0;
		
		private var shape:Image; 
		
		public var type:int = 0;
		
		public var isPassed:Boolean = false;
		
		private var dizuo:Image;
		
		/**
		 * 是否是相反的
		 */		
		public var isReverse:Boolean = false;
		
		public var playEnd:Boolean = false;
		
		private var ratio:Number = GameInstance.instance.scaleRatio;
		
		private var cr:Rectangle = new Rectangle();
		
		public function Pipe(dir:int, h:int)
		{
			arrow = dir;
			shape = new Image(ResManager.assetsManager.getTexture("swing_arm.png"));
			cr.width = h;
			cr.height = shape.height;
			if (dir == PipeDirection.RIGHT)
			{
				shape.scaleX *= -1;
				shape.x += shape.width;
			}else{
				shape.x = h - shape.width;
			}
			this.addChild(shape);
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
		
		
		/**
		 * 播放碎裂的动画和声音
		 * 
		 */		
		public function playDeadEffect():void
		{
//			var eff:MovieClip = new MovieClip(ResManager.assetsManager.getTextures(""));
//			this.addChild(eff);
//			eff.addEventListener(Event.COMPLETE, playComplete);
//			SoundUtil.playSound("");
			playComplete(null);
		}
		
		private function playComplete(e:Event=null):void
		{
			playEnd = true;
		}
		
		public function destroy():void
		{
			if (this.parent)
			{
				this.removeFromParent();
				DoorUtil.recycleDoorShape(shape,type,isReverse);
			}
		}

		/**
		 * 冰块的方向
		 */ 
		public function get arrow():int
		{
			return _arrow;
		}

		/**
		 * 冰块的方向
		 * @param value
		 * 
		 */		
		public function set arrow(value:int):void
		{
			_arrow = value;
		}
		
		/**
		 * 移动
		 * @param xx
		 * @param yy
		 * 
		 */		
		public function moveTo(yy:Number):void
		{
			var eff:Tween = new Tween(this,0.3);
			Starling.juggler.add(eff);
			eff.animate("y",yy);
			eff.repeatCount = 1;
		}
		
		public function get contentRect():Rectangle
		{
			cr.x = this.x;
			cr.y = this.y;
			return cr;
		}

	}
}