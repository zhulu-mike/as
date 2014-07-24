package modules.scene.views
{
	
	import flash.utils.getTimer;
	
	import configs.GameInstance;
	import configs.GamePattern;
	import configs.GameState;
	
	import events.GameEvent;
	
	import managers.ResManager;
	import managers.SoundManager;
	
	import so.cuo.platform.baidu.BaiDu;
	import so.cuo.platform.baidu.RelationPosition;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class GameScene extends Sprite
	{
		
		
		
		private var middleLayer:Sprite;
		private var pauseBtn:Image;
		
		public function GameScene()
		{
			
			EventCenter.instance.addEventListener(GameEvent.CHECK_RACE_END, checkRaceEnd);
			EventCenter.instance.addEventListener(GameEvent.PLAY_GAME_OVER_SOUND, playGameOverSound);
			middleLayer = new Sprite();
			this.addChild(middleLayer);
			
			pauseBtn = new Image(ResManager.assetsManager.getTexture("pausebutton"));
			this.addChild(pauseBtn);
			pauseBtn.scaleX = pauseBtn.scaleY = GameInstance.instance.scaleRatio;
			pauseBtn.x = GameInstance.instance.sceneWidth - pauseBtn.width - GameInstance.instance.sceneWidth*0.2;
			pauseBtn.y = 10;
			pauseBtn.addEventListener(TouchEvent.TOUCH, onTouchPause);
		}
		
		private function onTouchPause(e:TouchEvent):void
		{
			var touchs:Vector.<Touch> = e.touches;
			var touch:Touch = touchs[0];
			if (touch.phase == TouchPhase.ENDED && GameInstance.instance.gameState != GameState.OVER)
			{
				if (GameInstance.instance.gameState == GameState.PAUSE)
				{
					restart();
				}else{
					pauseGame();
				}
			}
			e.stopImmediatePropagation();
		}
		
		private function pauseGame():void
		{
			GameInstance.instance.gameState = GameState.PAUSE;
			pauseBtn.texture = ResManager.assetsManager.getTexture("playbutton");
			EventCenter.instance.dispatchGameEvent(GameEvent.GAME_STATE_CHANGE,{state:GameState.PAUSE});
			var s:SceneBase;
			for each (s in sceneList)
			{
				s.pauseGame();
			}
		}
		
		private function restart():void
		{
			GameInstance.instance.gameState = GameState.CONTINUE
			pauseBtn.texture = ResManager.assetsManager.getTexture("pausebutton");
			EventCenter.instance.dispatchGameEvent(GameEvent.GAME_STATE_CHANGE,{state:GameState.CONTINUE});
			var s:SceneBase;
			for each (s in sceneList)
			{
				s.restart();
			}
		}
		
		public var sceneList:Vector.<SceneBase> = new Vector.<SceneBase>();
		
		public function start(pattern:int):void
		{
			destory();
			switch (pattern)
			{
				case GamePattern.PUTONG:
				case GamePattern.NIXIANG:
					makePuTong();
//					BaiDu.getInstance().showBanner(BaiDu.BANNER,RelationPosition.BOTTOM_CENTER);
					break;
				case GamePattern.FIGHT:
					makeDuiZhan();
					break;
			}
		}
		
		/**
		 * 先销毁之前的
		 * 
		 */		
		private function destory():void
		{
			var s:SceneBase;
			for each (s in sceneList)
			{
				s.destroy();
				middleLayer.removeChild(s);
			}
			sceneList.length = 0;
		}
		/**
		 * 普通模式
		 * 
		 */		
		private function makePuTong():void
		{
			var scene:ScenePart = new ScenePart(GameInstance.instance.sceneHeight);
			middleLayer.addChild(scene);
			sceneList.push(scene);
		}
		
		
		/**
		 * 对战
		 * 
		 */		
		private function makeDuiZhan():void
		{
			EventCenter.instance.dispatchGameEvent(GameEvent.CONTROL_BIG_BACKGROUND, false);
			var h:int = GameInstance.instance.sceneHeight >> 1;
			var scene:DuiZhanScenePart = new DuiZhanScenePart(h);
			middleLayer.addChild(scene);
			sceneList.push(scene);
			scene = new DuiZhanScenePart(h);
			middleLayer.addChild(scene);
			scene.y = h;
			sceneList.push(scene);
		}
		
		
		public function update():void
		{
			var s:SceneBase;
			for each (s in sceneList)
			{
				s.update();
			}
		}
		
		private function checkRaceEnd(event:GameEvent):void
		{
			if (sceneList[0].end && sceneList[1].end)
			{
				if (sceneList[0].sceneScore > sceneList[1].sceneScore)
				{
					sceneList[0].gameOver.text = Language.YINGLE;
					sceneList[1].gameOver.text = Language.WOSHULE;
				}else if (sceneList[0].sceneScore == sceneList[1].sceneScore)
				{
					sceneList[0].gameOver.text = Language.PINGJU;
					sceneList[1].gameOver.text = Language.PINGJU;
				}else{
					sceneList[0].gameOver.text = Language.WOSHULE;
					sceneList[1].gameOver.text = Language.YINGLE;
				}
				GameInstance.instance.gameState = GameState.OVER;
				this.addEventListener(TouchEvent.TOUCH, onTouch);
			}
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touchs:Vector.<Touch> = event.touches;
			var touch:Touch = touchs[0];
			if (touch.phase == TouchPhase.ENDED)
			{
				this.removeEventListener(TouchEvent.TOUCH, onTouch);
				EventCenter.instance.dispatchGameEvent(GameEvent.CONTROL_BIG_BACKGROUND, true);
				EventCenter.instance.dispatchGameEvent(GameEvent.GAME_STATE_CHANGE, {state:GameState.OVER});
			}
		}
		
		private function playGameOverSound(e:GameEvent):void
		{
			SoundManager.playSound(ResManager.GAME_OVER);
		}
	}
}