package modules.scene.views
{
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	
	import configs.GameInstance;
	import configs.GamePattern;
	import configs.GameState;
	import configs.PlayerState;
	
	import events.GameEvent;
	
	import managers.GameUtil;
	import managers.LogManager;
	import managers.ResManager;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class ScenePart extends Sprite
	{
		/**
		 * 道路
		 */		
		private var road:Road;
		private var bg:Quad;
		private var doorList:Vector.<Door>;
		private var scoreTxt:TextField;
		public var score:int = 0;
		public var end:Boolean = false;
		public var gameOver:TextField;
		private var beyondMax:Boolean = false;
		
		public function ScenePart(h:int)
		{
			this.touchGroup = true;
			
			doorList = new Vector.<Door>();
			
			bg = new Quad(GameInstance.instance.sceneWidth,h,0xffffff);
			this.addChild(bg);
			
			mainPlayer = new MainPlayer();
			this.addChild(mainPlayer);
			mainPlayer.x = 20;
			
			
			road = new Road(GameInstance.instance.sceneWidth);
			this.addChild(road);
			road.y = (h - road.height>>1) + 50;
			mainPlayer.y = road.y - mainPlayer.height;
			
			scoreTxt = new TextField(300,40,Language.DEFEN.replace("$SCORE",0),"Verdana",30,0x00ff00);
			scoreTxt.hAlign = HAlign.CENTER;
			scoreTxt.vAlign = VAlign.CENTER;
			this.addChild(scoreTxt);
			if (GameInstance.instance.pattern == GamePattern.FIGHT)
				scoreTxt.y = 30;
			else
				scoreTxt.y = 60;
			scoreTxt.x = GameInstance.instance.sceneWidth - scoreTxt.width >> 1;
			
			gameOver = new TextField(300,40,Language.JIESHU,"Verdana",20,0x000000);
			this.addChild(gameOver);
			gameOver.visible = false;
			gameOver.x = GameInstance.instance.sceneWidth - gameOver.width >> 1;
			gameOver.y = this.height - gameOver.height >> 1;
			this.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touchs:Vector.<Touch> = event.touches;
			var touch:Touch = touchs[0];
			if (touch.phase == TouchPhase.ENDED && touch.target == this)
			{
				LogManager.logTrace("改变状态"+touch.id+touch.target);
				mainPlayer.updateState();
			}
		}
		
		public function update():void
		{
			if (end)
				return;
			updateDoorList();
			isHit();
			needMakeDoor();
		}
		
		private function updateDoorList():void
		{
			var door:Door;
			var i:int = 0;
			for each (door in doorList)
			{
				door.updatePos();
				if (door.x < 0)
				{
					door.removeFromParent(true);
					doorList.splice(i,1);
				}
				i++;
			}
		}
		
		private function isHit():void
		{
			var door:Door;
			var winState:int;
			for each (door in doorList)
			{
				if (!door.passed && door.x <= mainPlayer.x)
				{
					if (GamePattern.NIXIANG != GameInstance.instance.pattern){
						winState = door.state - 1;
						winState = winState < PlayerState.RECT ? PlayerState.TRIANGLE : winState;
					}else{
						winState = door.state + 1;
						winState = winState > PlayerState.TRIANGLE ? PlayerState.RECT : winState;
					}
					if (winState == mainPlayer.state){
						var sound:Sound = new Sound(new URLRequest(ResManager.PASS_SOUND));
						sound.play();
						score += 1;
						if (GameInstance.instance.pattern != GamePattern.FIGHT && GameUtil.getMaxScore(GameInstance.instance.pattern) < score)
						{
							//突破最高纪录
							GameUtil.setMaxScore(GameInstance.instance.pattern, score);
							EventCenter.instance.dispatchGameEvent(GameEvent.UPDATE_MAX_SCORE);
							if (!beyondMax){
								beyondMax = true;
								sound = new Sound(new URLRequest(ResManager.BEYOND_MAX));
								sound.play();
							}
						}
						scoreTxt.text = Language.DEFEN.replace("$SCORE",score);
						GameInstance.instance.score += 1;
					}else
					{
						end = true;
						if (GameInstance.instance.pattern != GamePattern.FIGHT){
							EventCenter.instance.dispatchGameEvent(GameEvent.PLAY_GAME_OVER_SOUND);
							setTimeout(function():void
							{
								EventCenter.instance.dispatchGameEvent(GameEvent.GAME_STATE_CHANGE, {state:GameState.OVER});
							},1000);
							
						}else{
							gameOver.visible = true;
							EventCenter.instance.dispatchGameEvent(GameEvent.CHECK_RACE_END);
						}
						return;
					}
					
					door.passed = true;
				}
			}
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
		
		private function makeDoor():void
		{
			var state:int ;
			if (doorList.length > 0)
				state = PlayerState.randomStateByPrevState(doorList[doorList.length-1].state);
			else
				state = PlayerState.randomState();
			var door:Door = new Door(state);
			this.addChild(door);
			doorList.push(door);
			door.x = GameInstance.instance.sceneWidth-door.width;
			door.y = mainPlayer.y + mainPlayer.height - door.height;
		}
		
		/**
		 * 主角
		 */		
		public var mainPlayer:MainPlayer;
		
		public function destroy():void
		{
			
		}
		
	}
}