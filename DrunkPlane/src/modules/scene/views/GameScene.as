package modules.scene.views
{
	
	import com.mike.utils.AdvertiseUtil;
	
	import configs.GameInstance;
	import configs.GameState;
	
	import events.GameEvent;
	
	import managers.ResManager;
	import managers.SoundManager;
	
	import starling.display.DisplayObject;
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
			
			EventCenter.instance.addEventListener(GameEvent.PLAY_GAME_OVER_SOUND, playGameOverSound);
			middleLayer = new Sprite();
			this.addChild(middleLayer);
			
			pauseBtn = new Image(ResManager.assetsManager.getTexture("swing_hammer.png"));
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
			var s:ISceneBase;
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
			var s:ISceneBase;
			for each (s in sceneList)
			{
				s.restart();
			}
		}
		
		public var sceneList:Vector.<ISceneBase> = new Vector.<ISceneBase>();
		
		public function start():void
		{
			destory();
			makePuTong();
			AdvertiseUtil.showBaiDuBanner();
		}
		
		/**
		 * 先销毁之前的
		 * 
		 */		
		private function destory():void
		{
			var s:ISceneBase;
			for each (s in sceneList)
			{
				s.destroy();
				middleLayer.removeChild(s as DisplayObject);
			}
			sceneList.length = 0;
		}
		/**
		 * 普通模式
		 * 
		 */		
		private function makePuTong():void
		{
			var scene:NormalScene = new NormalScene(GameInstance.instance.sceneWidth);
			middleLayer.addChild(scene);
			sceneList.push(scene);
		}
		
		
		public function update():void
		{
			var s:ISceneBase;
			for each (s in sceneList)
			{
				s.update();
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