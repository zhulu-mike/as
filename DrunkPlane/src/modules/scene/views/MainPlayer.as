package modules.scene.views
{
	import com.mike.utils.MathUtil;
	
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import configs.FlyDirection;
	import configs.GameConfig;
	import configs.GameInstance;
	import configs.GameState;
	import configs.PipeDirection;
	import configs.PlayerStatus;
	
	import events.GameEvent;
	
	import managers.GameUtil;
	import managers.ResManager;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class MainPlayer extends Sprite
	{
		private var shape:Image;
		private var frameSpeed:int = 12;
		private var words:TextField;
		private var lastSpeakTime:int = 0;
		private const SPEAKTIME:int = 3000;
		private const SPEAK_DELAY_TIME:int = 3000;
		private var _playerStatus:int = PlayerStatus.COMMON;
		public var begin:Boolean = false;
		private var _direct:int = 0;
		private var _dead:Boolean = false;
		private var luoXuanJiang:Sprite;
		
		public function MainPlayer()
		{
			shape = new Image(ResManager.assetsManager.getTexture("swing_fly_boby.png"));
			shape.blendMode = BlendMode.NORMAL;
			cr.width = shape.width;
			this.addChild(shape);
			
			luoXuanJiang = new Sprite();
			this.addChild(luoXuanJiang);
			var l1:Image = new Image(ResManager.assetsManager.getTexture("swing_fly_wing.png"));
			l1.x = 25;
			luoXuanJiang.addChild(l1);
			l1 = new Image(ResManager.assetsManager.getTexture("swing_fly_wing_01.png"));
			l1.x = 0;
			l1.y = 9;
			luoXuanJiang.addChild(l1);
			l1 = new Image(ResManager.assetsManager.getTexture("swing_fly_wing_02.png"));
			l1.x = 39;
			l1.y = 9;
			luoXuanJiang.addChild(l1);
			l1 = new Image(ResManager.assetsManager.getTexture("swing_fly_eye.png"));
			l1.x = 32;
			l1.y = 22;
			luoXuanJiang.addChild(l1);
			luoXuanJiang.x = cr.width - luoXuanJiang.width >> 1;
			shape.y = luoXuanJiang.height;
			cr.height = shape.y +  shape.height;
		}
		
		
		public function flyOut():void
		{
			hideSpeak();
			var tween:Tween = new Tween(this,0.8,Transitions.EASE_OUT);
			Starling.juggler.add(tween);
			tween.animate("y", GameInstance.instance.sceneHeight);
			tween.onComplete = destroy;
		}
		
		public function destroy():void
		{
			if (this.parent)
			{
				this.removeFromParent();
			}
			EventCenter.instance.dispatchGameEvent(GameEvent.GAME_STATE_CHANGE, {state:GameState.OVER});
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
			return shape.height+luoXuanJiang.height;
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
		}
		
		public function restart():void
		{
		}
		
		/**
		 * 播放死亡动画
		 * 
		 */		
		public function playDead():void
		{
			dead = true;	
			flyOut();
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