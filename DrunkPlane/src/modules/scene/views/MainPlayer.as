package modules.scene.views
{
	import com.mike.utils.MathUtil;
	
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import configs.FlyDirection;
	import configs.GameConfig;
	import configs.GameInstance;
	import configs.PipeDirection;
	import configs.PlayerStatus;
	
	import managers.GameUtil;
	import managers.ResManager;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class MainPlayer extends Sprite
	{
		private var shape:MovieClip;
		private var frameSpeed:int = 12;
		private var words:TextField;
		private var lastSpeakTime:int = 0;
		private const SPEAKTIME:int = 3000;
		private const SPEAK_DELAY_TIME:int = 3000;
		private var _playerStatus:int = PlayerStatus.COMMON;
		public var begin:Boolean = false;
		private var _direct:int = 0;
		private var _dead:Boolean = false;
		
		public function MainPlayer()
		{
			shape = new MovieClip(ResManager.assetsManager.getTextures("swing_fly_boby"));
			shape.scaleX = shape.scaleY = GameInstance.instance.scaleRatio;
			shape.loop = true;
			shape.currentFrame = 0;
			shape.play();
			Starling.juggler.add(shape);
			cr.width = shape.width;
			cr.height = shape.height;
			this.addChild(shape);
			
		}
		
		
		public function flyOut(h:int):void
		{
			hideSpeak();
			var tween:Tween = new Tween(this,0.8,Transitions.EASE_OUT);
			Starling.juggler.add(tween);
			tween.animate("y", h);
			this.rotation = MathUtil.angleToRadian(90);
			this.x += this.width;
			tween.onComplete = destroy;
			this.shape.stop();
		}
		
		public function destroy():void
		{
			if (this.parent)
			{
				this.removeFromParent();
			}
		}
		
		public function update():void
		{
			if (!begin)
				return;
			if (_playerStatus != PlayerStatus.WUDI && (words == null || words.parent == null))
			{
				if (Math.random()*1000 > 950 && getTimer() - lastSpeakTime > SPEAK_DELAY_TIME)
				{
					speak();
				}
			}else if (words && words.parent && getTimer() - lastSpeakTime > SPEAKTIME){
				hideSpeak();
			}
			updateFly();
			lastTime = getTimer();
		}
		
		private function speak(s:String=null):void
		{
			var str:String = s || GameUtil.randomPlayerWord();
			if (words == null)
			{
				var ratio:Number = GameInstance.instance.scaleRatio;
				words = new TextField(240*ratio,128*ratio,str,"Verdana",28*ratio,0xffffff);
				words.hAlign = HAlign.CENTER;
				words.vAlign = VAlign.TOP;
				words.filter = GameUtil.getTextFieldFIlter();
				this.addChild(words);
				words.x = this.reallyWidth - words.width >> 1;
				words.y = -words.height - 10;
			}else{
				this.addChild(words);
				words.text = str;
			}
			lastSpeakTime = getTimer();
		}
		
		private function hideSpeak():void
		{
			lastSpeakTime = getTimer();
			this.removeChild(words);
		}
		
		public function get reallyWidth():int
		{
			return shape.width;
		}
		public function get reallyHeight():int
		{
			return shape.height;
		}

		public function get playerStatus():int
		{
			return _playerStatus;
		}

		public function set playerStatus(value:int):void
		{
			_playerStatus = value;
		}

		
		public function pause():void
		{
			shape.pause();
		}
		
		public function restart():void
		{
			shape.play();
			lastTime = getTimer();
		}
		
		/**
		 * 播放死亡动画
		 * 
		 */		
		public function playDead():void
		{
			dead = true;	
		}
		
		public var originy:int = 0;
		private var upSpeed:Number = 0;
		private var _hSpeed:Number = 0;
		private var lastTime:int;
		/**
		 * 每帧向上加速度
		 */		
		private var upAccelerate:Number = -1 ;
		private var hAccelerate:Number = -0.5;
		private var cr:Rectangle = new Rectangle();
		
		public function fly(angle:Number, power:Number):void
		{
			hSpeed = Math.cos(angle* Math.PI / 180) * power;
			upSpeed = Math.sin(angle* Math.PI / 180) * power;
		}
		
		
		private function updateFly():void
		{
			if (!dead)
				this.x += hSpeed;
		}

		public function get hSpeed():Number
		{
			return _hSpeed;
		}

		public function set hSpeed(value:Number):void
		{
			_hSpeed = value;
		}

		public function get direct():int
		{
			return _direct;
		}

		public function set direct(value:int):void
		{
			_direct = value;
			if (value == FlyDirection.RIGHT){
				hSpeed = GameConfig.hspeed;
			}else{
				hSpeed = -GameConfig.hspeed;
			}
			shape.scaleX *= -1;
			if (shape.scaleX < 0)
			{
				shape.x += shape.width;
			}else{
				shape.x -= shape.width;
			}
		}

		public function get contentRect():Rectangle
		{
			cr.x = this.x;
			cr.y = this.y;
			return cr;
		}

		public function get dead():Boolean
		{
			return _dead;
		}

		public function set dead(value:Boolean):void
		{
			_dead = value;
		}


	}
}