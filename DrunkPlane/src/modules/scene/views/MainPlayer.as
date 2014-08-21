package modules.scene.views
{
	import com.mike.utils.MathUtil;
	
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.dns.AAAARecord;
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
		private var luoXuanJiang:Sprite;
		private var luoXuanJiang2:Sprite;
		private var body:Sprite;
		private var mainWing:Image;
		private var leftWing:Image;
		private var rightWing:Image;
		
		public function MainPlayer()
		{
			body = new Sprite();
			this.addChild(body);
			shape = new MovieClip(ResManager.assetsManager.getTextures("swing_fly_boby"),2);
			shape.loop = true;
			Starling.juggler.add(shape);
			shape.blendMode = BlendMode.NORMAL;
			cr.width = shape.width;
			body.addChild(shape);
			
			luoXuanJiang2 = new Sprite();
			this.addChild(luoXuanJiang2);
			luoXuanJiang = new Sprite();
			luoXuanJiang2.addChild(luoXuanJiang);
			mainWing = new Image(ResManager.assetsManager.getTexture("swing_fly_wing.png"));
			mainWing.x = 25;
			luoXuanJiang.addChild(mainWing);
			leftWing = new Image(ResManager.assetsManager.getTexture("swing_fly_wing_01.png"));
			leftWing.x = 0;
			leftWing.y = 9;
			luoXuanJiang.addChild(leftWing);
			rightWing = new Image(ResManager.assetsManager.getTexture("swing_fly_wing_02.png"));
			rightWing.x = 39;
			rightWing.y = 9;
			luoXuanJiang.addChild(rightWing);
			var l1:Image = new Image(ResManager.assetsManager.getTexture("swing_fly_eye.png"));
			l1.x = 21;
			l1.y = 40;
			body.addChild(l1);
			luoXuanJiang.x = -luoXuanJiang.width >> 1;
			luoXuanJiang2.x = (cr.width - luoXuanJiang2.width >> 1)+(luoXuanJiang.width >> 1);
			body.y = luoXuanJiang2.height;
			cr.height = shape.y +  shape.height;
			
			lxjRotate();
		}
		
		private var lxjTween:Tween;
		
		private function lxjRotate():void
		{
			if (lxjTween)
			{
				Starling.juggler.remove(lxjTween);
			}
			lxjTween = new Tween(luoXuanJiang2,0.1);
			lxjTween.animate("scaleX",0.4);
			Starling.juggler.add(lxjTween);
			lxjTween.repeatCount = 1;
			lxjTween.onComplete = lxjRotate2;
		}
		
		private function lxjRotate2():void
		{
			if (lxjTween)
			{
				Starling.juggler.remove(lxjTween);
			}
			lxjTween = new Tween(luoXuanJiang2,0.1);
			lxjTween.animate("scaleX",1);
			Starling.juggler.add(lxjTween);
			lxjTween.repeatCount = 1;
			lxjTween.onComplete = lxjRotate;
		}
		
		
		public function flyOut():void
		{
			hideSpeak();
			var tween:Tween = new Tween(body,0.8,Transitions.EASE_OUT);
			Starling.juggler.add(tween);
			var p:Point = this.globalToLocal(new Point(0,GameInstance.instance.sceneHeight));
			tween.animate("y", p.y);
			tween.onComplete = destroy;
			if (lxjTween)
			{
				Starling.juggler.removeTweens(luoXuanJiang2);
			}
			var rx:int = MathUtil.random(-200,GameInstance.instance.sceneWidth+200);
			var ry:int = GameInstance.instance.sceneHeight;
			p = new Point(rx,ry);
			p = luoXuanJiang.globalToLocal(p);
			var t:Tween = new Tween(leftWing,0.6,Transitions.EASE_OUT);
			Starling.juggler.add(t);
			t.animate("x",p.x);
			t.animate("y",p.y);
			rx = MathUtil.random(-200,GameInstance.instance.sceneWidth+200);
			p = new Point(rx,ry);
			p = luoXuanJiang.globalToLocal(p);
			t = new Tween(mainWing,0.6,Transitions.EASE_OUT);
			Starling.juggler.add(t);
			t.animate("x",p.x);
			t.animate("y",p.y);
			rx = MathUtil.random(-200,GameInstance.instance.sceneWidth+200);
			p = new Point(rx,ry);
			p = luoXuanJiang.globalToLocal(p);
			t = new Tween(rightWing,0.6,Transitions.EASE_OUT);
			Starling.juggler.add(t);
			t.animate("x",p.x);
			t.animate("y",p.y);
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
			body.scaleX *= -1;
			if (body.scaleX < 0)
			{
				body.x += shape.width;
			}else{
				body.x -= shape.width;
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