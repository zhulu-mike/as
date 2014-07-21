package modules.scene.views
{
	import com.mike.utils.MathUtil;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import configs.GameInstance;
	import configs.PlayerState;
	import configs.PlayerStatus;
	
	import managers.DoorUtil;
	import managers.GameUtil;
	import managers.ResManager;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class MainPlayer extends Sprite
	{
		private var shape:MovieClip;
		private var states:Array = PlayerState.stateList;
		private var currIndex:int = 0;
		public var state:int = 1;
		private var frameSpeed:int = 12;
		private var words:TextField;
		private var lastSpeakTime:int = 0;
		private const SPEAKTIME:int = 3000;
		private const SPEAK_DELAY_TIME:int = 3000;
		private var _playerStatus:int = PlayerStatus.COMMON;
		private var wuDiEff:MovieClip;
		
		public function MainPlayer()
		{
			shape = DoorUtil.getPlayerMC(PlayerState.STONE);
			shape.loop = true;
			shape.currentFrame = 0;
			shape.play();
			Starling.juggler.add(shape);
			this.addChild(shape);
			
			timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		public function updateState():void
		{
			currIndex++;
			currIndex = currIndex >= states.length ? 0 : currIndex;
			shape.removeFromParent(false);
			shape.stop();
			Starling.juggler.remove(shape);
			DoorUtil.recyclePlayerMC(state, shape);
			state = states[currIndex];
			shape = DoorUtil.getPlayerMC(state);
			shape.currentFrame = 0;
			shape.fps = frameSpeed;
			this.addChild(shape);
			shape.play();
			Starling.juggler.add(shape);
			return;
			
		}
		
		public function setSpeed(speed:int):void
		{
			frameSpeed = (speed/GameInstance.INIT_SPEED)*12;
			shape.fps = frameSpeed;
		}
		
		public function flyOut(h:int):void
		{
			hideSpeak();
			timer.stop();
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
				DoorUtil.recyclePlayerMC(state, shape);
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, onTimer);
				timer = null;
				if (wuDiEff)
				{
					wuDiEff.removeFromParent();
					Starling.juggler.remove(wuDiEff);
					wuDiEff.dispose();
				}
			}
		}
		
		public function update():void
		{
			if (_playerStatus != PlayerStatus.WUDI && (words == null || words.parent == null))
			{
				if (Math.random()*1000 > 950 && getTimer() - lastSpeakTime > SPEAK_DELAY_TIME)
				{
					speak();
				}
			}else if (words && words.parent && getTimer() - lastSpeakTime > SPEAKTIME){
				hideSpeak();
			}
		}
		
		private function speak(s:String=null):void
		{
			var str:String = s || GameUtil.randomPlayerWord();
			if (words == null)
			{
				words = new TextField(150,80,str,"Verdana",18,0xffffff);
				words.hAlign = HAlign.CENTER;
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

		private var timer:Timer = new Timer(1000,int.MAX_VALUE);
		private var wuDiCount:int = 0;
		public function set playerStatus(value:int):void
		{
			if (value == PlayerStatus.WUDI)
			{
				wuDiCount = GameInstance.WUDITIME;
				timer.reset();
				timer.start();
				wuDiCount = 5;
				speak(Language.WUDIWORDS.replace("$COUNT",wuDiCount));
				if (wuDiEff == null)
				{
					wuDiEff = new MovieClip(ResManager.assetsManager.getTextures("wudieff"));
					Starling.juggler.add(wuDiEff);
					this.addChild(wuDiEff);
					wuDiEff.loop = true;
					wuDiEff.x = this.reallyWidth - wuDiEff.width >> 1;
					wuDiEff.y = this.reallyHeight - wuDiEff.height >> 1;
				}
				wuDiEff.visible = true;
				wuDiEff.play();
			}else if (_playerStatus == PlayerStatus.WUDI)
			{
				wuDiEff.visible = false;
				wuDiEff.stop();
			}
			_playerStatus = value;
		}

		private function onTimer(e:TimerEvent):void
		{
			if (wuDiCount <= 0)
			{
				hideSpeak();
				timer.stop();
				return;
			}
			wuDiCount--;
			speak(Language.WUDIWORDS.replace("$COUNT",wuDiCount));
		}
		
		public function pause():void
		{
			shape.pause();
		}
		
		public function restart():void
		{
			shape.play();
		}
	}
}