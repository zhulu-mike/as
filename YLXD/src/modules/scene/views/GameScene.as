package modules.scene.views
{
	
	import configs.GameInstance;
	import configs.GamePattern;
	import configs.GameState;
	
	import events.GameEvent;
	
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class GameScene extends Sprite
	{
		
		public function GameScene()
		{
			
			EventCenter.instance.addEventListener(GameEvent.CHECK_RACE_END, checkRaceEnd);
		}
		
		
		
		public var sceneList:Vector.<ScenePart> = new Vector.<ScenePart>();
		
		public function start(pattern:int):void
		{
			destory();
			switch (pattern)
			{
				case GamePattern.PUTONG:
					makePuTong();
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
			var s:ScenePart;
			for each (s in sceneList)
			{
				s.destroy();
				this.removeChild(s);
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
			this.addChildAt(scene,0);
			sceneList.push(scene);
		}
		
		/**
		 * 对战
		 * 
		 */		
		private function makeDuiZhan():void
		{
			var h:int = GameInstance.instance.sceneHeight >> 1;
			var scene:ScenePart = new ScenePart(h);
			this.addChildAt(scene,0);
			sceneList.push(scene);
			scene = new ScenePart(h);
			this.addChildAt(scene,0);
			scene.y = h;
			sceneList.push(scene);
		}
		
		public function update():void
		{
			var s:ScenePart;
			for each (s in sceneList)
			{
				s.update();
			}
		}
		
		private function checkRaceEnd(event:GameEvent):void
		{
			if (sceneList[0].end && sceneList[1].end)
			{
				if (sceneList[0].score > sceneList[1].score)
				{
					sceneList[0].gameOver.text = Language.YINGLE;
					sceneList[1].gameOver.text = Language.WOSHULE;
				}else if (sceneList[0].score == sceneList[1].score)
				{
					sceneList[0].gameOver.text = Language.PINGJU;
					sceneList[1].gameOver.text = Language.PINGJU;
				}else{
					sceneList[0].gameOver.text = Language.WOSHULE;
					sceneList[1].gameOver.text = Language.YINGLE;
				}
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
				EventCenter.instance.dispatchGameEvent(GameEvent.GAME_STATE_CHANGE, {state:GameState.OVER});
			}
		}
	}
}