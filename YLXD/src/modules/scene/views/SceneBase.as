package modules.scene.views
{
	import flash.utils.getTimer;
	
	import configs.GameInstance;
	import configs.GamePattern;
	import configs.PlayerState;
	import configs.PlayerStatus;
	
	import managers.LogManager;
	import managers.ResManager;
	import managers.SoundManager;
	
	import starling.display.Image;
	import starling.display.Sprite;
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
		protected var pauseBtn:Image;
		protected var isPause:Boolean = false;
		
		public function SceneBase($sceneHeight:int)
		{
			sceneHeight = $sceneHeight;
			touchGroup = true;
			doorList = new Vector.<Door>();
			
			mainPlayer = new MainPlayer();
			this.addChild(mainPlayer);
			mainPlayer.x = 100;
			
			scoreTxt = new TextField(300,40,Language.DEFEN.replace("$SCORE",0),"Verdana",24,0xffffff,true);
			scoreTxt.hAlign = HAlign.CENTER;
			scoreTxt.vAlign = VAlign.CENTER;
			this.addChild(scoreTxt);
			scoreTxt.x = GameInstance.instance.sceneWidth - scoreTxt.width >> 1;
			gameOver = new TextField(300,40,Language.JIESHU,"Verdana",20,0xffffff);
			
			this.addChild(gameOver);
			gameOver.visible = false;
			gameOver.x = GameInstance.instance.sceneWidth - gameOver.width >> 1;
			gameOver.y = this.sceneHeight - gameOver.height >> 1;
			this.addEventListener(TouchEvent.TOUCH, onTouch);
			
		}
		
		protected function onTouch(event:TouchEvent):void
		{
			var touchs:Vector.<Touch> = event.touches;
			var touch:Touch = touchs[0];
			if (touch.phase == TouchPhase.ENDED && touch.target == this && !this.end && !this.isPause)
			{
				LogManager.logTrace("改变状态"+touch.id+touch.target);
				mainPlayer.updateState();
			}
		}
		
		public function update():void
		{
			if (isPause)
				return;
			if (end){
				mainPlayer.playerStatus = PlayerStatus.COMMON;
				return;
			}
			if (mainPlayer.playerStatus == PlayerStatus.WUDI && getTimer() - lastWuDiTime >= GameInstance.WUDITIME)
			{
				cancelWuDi();
			}
			mainPlayer.update();
			updateDoorList();
			isHit();
			needMakeDoor();
			needAddSpeed();
		}
		
		private function needAddSpeed():void
		{
			var speed:int = int(sceneScore / 100);
			speed = speed > 5 ? 5 : speed;
			if (mainPlayer.playerStatus == PlayerStatus.COMMON)
				sceneSpeed  = GameInstance.INIT_SPEED + speed;
			else
				sceneSpeed  = GameInstance.INIT_SPEED + speed+ GameInstance.WUDISPEED;
		}
		
		protected function cancelWuDi():void
		{
			mainPlayer.playerStatus = PlayerStatus.COMMON;
			sceneSpeed -= GameInstance.WUDISPEED;
			mainPlayer.setSpeed(sceneSpeed);
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
					if (!door.isReverse){
						winState = door.state - 1;
						winState = winState < PlayerState.RECT ? PlayerState.TRIANGLE : winState;
					}else{
						winState = door.state + 1;
						winState = winState > PlayerState.TRIANGLE ? PlayerState.RECT : winState;
					}
					if (mainPlayer.playerStatus == PlayerStatus.WUDI || winState == mainPlayer.state){
						SoundManager.playSound(ResManager.PASS_SOUND);
						_sceneScore += 1;
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
				var reverse:int = int(sceneScore / 50)*10 ;
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
			this.addChild(door);
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
		}

		public function get sceneSpeed():int
		{
			return _sceneSpeed;
		}

		public function set sceneSpeed(value:int):void
		{
			_sceneSpeed = value;
		}

	}
}