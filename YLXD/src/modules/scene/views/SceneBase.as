package modules.scene.views
{
	import flash.utils.getTimer;
	
	import configs.GameInstance;
	import configs.GamePattern;
	import configs.GameState;
	import configs.PlayerState;
	import configs.PlayerStatus;
	
	import managers.LogManager;
	import managers.ResManager;
	import managers.SoundManager;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class SceneBase extends Sprite
	{
		protected var sceneHeight:int = 0;
		protected var doorList:Vector.<Door>;
		/**
		 * 主角
		 */		
		public var mainPlayer:MainPlayer;
		protected var scoreTxt:TextField;
		public var gameOver:TextField;
		public var end:Boolean = false;
		private var _sceneSpeed:int = 5;
		protected var lastWuDiTime:int = 0;
		private var _sceneScore:int = 0;
		protected var doorLayer:Sprite;
		protected var addSpeed:int = 0;//增加的速度
		protected var firstLayer:Sprite;
		private var interactiveLayer:Quad;
		
		public function SceneBase($sceneHeight:int)
		{
			sceneHeight = $sceneHeight;
//			touchGroup = true;
			doorList = new Vector.<Door>();
			
			interactiveLayer = new Quad(GameInstance.instance.sceneWidth,$sceneHeight,0xffffff);
			interactiveLayer.alpha = 0;
			this.addChildAt(interactiveLayer,0);
			
			firstLayer = new Sprite();
			firstLayer.touchable = false;
			this.addChild(firstLayer);
			
			mainPlayer = new MainPlayer();
			firstLayer.addChild(mainPlayer);
			mainPlayer.x = 100;
			mainPlayer.y = $sceneHeight * 0.6875 - mainPlayer.height;
			
			doorLayer = new Sprite();
			firstLayer.addChild(doorLayer);
			
			scoreTxt = new TextField(300,40,Language.DEFEN.replace("$SCORE",0),"Verdana",24,0xffffff,true);
			scoreTxt.hAlign = HAlign.CENTER;
			scoreTxt.vAlign = VAlign.CENTER;
			firstLayer.addChild(scoreTxt);
			scoreTxt.x = GameInstance.instance.sceneWidth - scoreTxt.width >> 1;
			gameOver = new TextField(300,40,Language.JIESHU,"Verdana",20,0xffffff);
			
			firstLayer.addChild(gameOver);
			gameOver.visible = false;
			gameOver.x = GameInstance.instance.sceneWidth - gameOver.width >> 1;
			gameOver.y = this.sceneHeight - gameOver.height >> 1;
			interactiveLayer.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		
		
		protected function onTouch(event:TouchEvent):void
		{
			var touchs:Vector.<Touch> = event.touches;
			var touch:Touch = touchs[0];
			if (touch.phase == TouchPhase.ENDED  && touch.target == interactiveLayer && !this.end && GameInstance.instance.gameState != GameState.PAUSE)
			{
				LogManager.logTrace("改变状态"+touch.id+touch.target);
				mainPlayer.updateState();
			}
		}
		
		public function update():void
		{
//			var t:int = getTimer();
			if (GameInstance.instance.gameState == GameState.PAUSE)
				return;
			if (end){
				mainPlayer.playerStatus = PlayerStatus.COMMON;
				return;
			}
			doUpdate();
			if (mainPlayer.playerStatus == PlayerStatus.WUDI && getTimer() - lastWuDiTime >= GameInstance.WUDITIME)
			{
				cancelWuDi();
			}
			mainPlayer.update();
//			t = getTimer();
			updateDoorList();
//			t = getTimer();
			isHit();
//			trace("碰撞检测耗时"+(getTimer() - t));
//			t = getTimer();
			needMakeDoor();
			needAddSpeed();
//			trace("场景耗时"+(getTimer() - t));
		}
		
		protected function doUpdate():void
		{
			
		}
		
		private function needAddSpeed():void
		{
			var speed:int = int(sceneScore / 100);
			speed = speed > 5 ? 5 : speed;
			if (mainPlayer.playerStatus == PlayerStatus.COMMON){
				sceneSpeed  = GameInstance.INIT_SPEED + speed;
				mainPlayer.setSpeed(sceneSpeed);
			}else{
				var c:int = Math.round((getTimer() - lastWuDiTime)/16.6666);
				c = c > 150 ? (150 - c + 150) : c;
				addSpeed = GameInstance.ACCERATE_SPEED * c;
				sceneSpeed  = GameInstance.INIT_SPEED + speed+ addSpeed;
			}
		}
		
		protected function cancelWuDi():void
		{
			mainPlayer.playerStatus = PlayerStatus.COMMON;
			addSpeed = 0;
		}
		
		protected function updateDoorList():void
		{
			var door:Door;
			var i:int = 0;
			for each (door in doorList)
			{
				door.speed = sceneSpeed;
				door.updatePos();
				if (door.passed || door.x < 0)
				{
					door.flyOut();
					doorList.splice(i,1);
				}
				i++;
			}
		}
		
		protected function isHit():void
		{
			var door:Door;
			var winState:int;
			for each (door in doorList)
			{
				if (!door.passed && door.x <= mainPlayer.x + mainPlayer.reallyWidth)
				{
					door.passed = true;
					playHitEffect();
					if (!door.isReverse){
						winState = door.state - 1;
						winState = winState < PlayerState.STONE ? PlayerState.BU : winState;
					}else{
						winState = door.state + 1;
						winState = winState > PlayerState.BU ? PlayerState.STONE : winState;
					}
					if (mainPlayer.playerStatus == PlayerStatus.WUDI || winState == mainPlayer.state){
						SoundManager.playSound(ResManager.PASS_SOUND);
						sceneScore += 1;
						doWhenpass(door);
						scoreTxt.text = Language.DEFEN.replace("$SCORE",sceneScore);
						GameInstance.instance.score += 1;
					}else
					{
						end = true;
						mainPlayer.flyOut(sceneHeight);
						endGame();
						return;
					}
				}
			}
		}
		
		protected function doWhenpass(door:Door):void
		{
			
		}
		
		private function needMakeDoor():void
		{
			if (doorList.length < 1)
			{
				makeDoor();
			}else{
				if (GameInstance.instance.sceneWidth - doorList[doorList.length-1].x > GameInstance.DOOR_DIS)
					makeDoor();
			}
		}
		
		protected function makeDoor():void
		{
			var state:int ;
			if (doorList.length > 0)
				state = PlayerState.randomStateByPrevState(doorList[doorList.length-1].state);
			else
				state = PlayerState.randomState();
			var needReverse:Boolean = false;
			if (sceneScore > 50 && GameInstance.instance.pattern != GamePattern.NIXIANG)
			{
				//50关后，有反转率
				var reverse:int = int(sceneScore / 50)*5 ;
				reverse = reverse > 30 ? 30 : reverse;
				var random:int = Math.random() * 100;
				if (random <= reverse){
					needReverse = true;
				}
			}else if (GameInstance.instance.pattern == GamePattern.NIXIANG)
			{
				needReverse = true;
			}
			var door:Door = new Door(state,needReverse);
			doorLayer.addChild(door);
			door.speed = sceneSpeed;
			doorList.push(door);
			door.x = GameInstance.instance.sceneWidth-door.width;
			door.y = mainPlayer.y + mainPlayer.reallyHeight - (door.height * 0.5);
		}
		
		protected function endGame():void
		{
			
		}

		public function get sceneScore():int
		{
			return _sceneScore;
		}

		public function set sceneScore(value:int):void
		{
			_sceneScore = value;
		}
		
		public function destroy():void
		{
			mainPlayer.destroy();
			var door:Door;
			for each (door in doorList)
			{
				door.destroy();
			}
			doorList.length = 0;
		}

		public function get sceneSpeed():int
		{
			return _sceneSpeed;
		}

		public function set sceneSpeed(value:int):void
		{
			_sceneSpeed = value;
		}
		
		private var pauseTime:int = 0;
		public function pauseGame():void
		{
			mainPlayer.pause();
			pauseTime = getTimer();
		}
		
		public function restart():void
		{
			mainPlayer.restart();
			lastWuDiTime += (getTimer() - pauseTime);
		}
		
		protected function playHitEffect():void
		{
			var eff:MovieClip = new MovieClip(ResManager.assetsManager.getTextures("hit"),10);
			eff.loop = false;
			firstLayer.addChild(eff);
			Starling.juggler.add(eff);
			eff.play();
			eff.x = this.mainPlayer.x + this.mainPlayer.reallyWidth * 0.5;
			eff.y = this.mainPlayer.y - 20;
			eff.addEventListener(Event.COMPLETE, onPlayerComplete);
		}
		
		private function onPlayerComplete(e:Event):void
		{
			var eff:MovieClip = e.currentTarget as MovieClip;
			firstLayer.removeChild(eff);
			Starling.juggler.remove(eff);
			eff.dispose();
		}
		
		
	}
}