package
{
	
	import configs.GameInstance;
	import configs.GamePattern;
	import configs.GameState;
	
	import events.GameEvent;
	
	import managers.GameUtil;
	
	import modules.mainui.views.MainMenu;
	import modules.scene.views.GameOver;
	import modules.scene.views.GameScene;
	
	import so.cuo.platform.baidu.BaiDu;
	import so.cuo.platform.baidu.BaiDuAdEvent;
	import so.cuo.platform.baidu.RelationPosition;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Game extends Sprite
	{
		public function Game()
		{
			
			EventCenter.instance.addEventListener(GameEvent.GAME_STATE_CHANGE, stateHandler);
			this.addEventListener(Event.ADDED_TO_STAGE,onResize);
		}
		
		private function onRender(event:Event):void
		{
			gameScene.update();
		}
		
		private function onResize(event:Event):void
		{
			GameInstance.instance.sceneWidth = stage.stageWidth;
			GameInstance.instance.sceneHeight = stage.stageHeight;
			EventCenter.instance.dispatchEvent(new GameEvent(GameEvent.STARLING_CREATE));
			EventCenter.instance.addEventListener(GameEvent.START_GAME, beginAfterRes);
		}
		
		
		public function beginAfterRes(e:GameEvent=null):void
		{
			EventCenter.instance.dispatchGameEvent(GameEvent.GAME_STATE_CHANGE,{state:GameState.BEGIN});
			this.addEventListener(Event.ENTER_FRAME, onRender);
		}
		
		private var _mainMenu:MainMenu;

		public function get mainMenu():MainMenu
		{
			if (_mainMenu == null){
				_mainMenu = new MainMenu();
			}
			return _mainMenu;
		}
		
		private var _gameScene:GameScene;

		public function get gameScene():GameScene
		{
			if (_gameScene == null)
				_gameScene = new GameScene();
			return _gameScene;
		}
		
		private var _gameOverPanel:GameOver;
		public function get gameOverPanel():GameOver
		{
			if (_gameOverPanel == null){
				_gameOverPanel = new GameOver();
			}
			return _gameOverPanel;
		}
		
		private function stateHandler(event:GameEvent):void
		{
			gameStateChange(event.data);
		}
		
		/**
		 * 游戏状态切换处理
		 * @param state
		 * @see also GameState.as
		 */		
		public function gameStateChange(data:Object):void
		{
			var state:int = data.state;
			switch (state)
			{
				case GameState.BEGIN:
					begin();
					break;
				case GameState.RUNNING:
					gameRun(data.pattern);
					break;
				case GameState.PAUSE:
					break;
				case GameState.OVER:
					endGame();
					break;
				case GameState.CONTINUE:
					break;
				default:
					break;
			}
		}
		
		private function begin():void
		{
			BaiDu.getInstance().showBanner(BaiDu.BANNER,RelationPosition.BOTTOM_CENTER);
			this.addChild(mainMenu);
		}
		
		/**
		 * 开始游戏
		 * @param pattern 游戏模式
		 * 
		 */		
		private function gameRun(pattern:int):void
		{
			BaiDu.getInstance().hideBanner();
			GameInstance.instance.score = 0;
			GameInstance.instance.pattern = pattern;
			this.addChild(gameScene);
			gameScene.start(pattern);
			this.addEventListener(Event.ENTER_FRAME, onRender);
		}
		
		private function endGame():void
		{
			this.removeEventListener(Event.ENTER_FRAME, onRender);
			beginLater();
			GameInstance.instance.leftShowFullAd--;
			if (GameInstance.instance.leftShowFullAd <= 0)
			{
				if (BaiDu.getInstance().isInterstitialReady())
				{
					BaiDu.getInstance().showInterstitial();
					BaiDu.getInstance().addEventListener(BaiDuAdEvent.onInterstitialDismiss, onCloseFullAd);
					GameInstance.instance.leftShowFullAd = GameInstance.FULLE_AD;
				}
			}
		}
		/**
		 * 关闭全屏广告后，再次缓冲 
		 * @param event
		 * 
		 */		
		protected function onCloseFullAd(event:BaiDuAdEvent):void
		{
			BaiDu.getInstance().removeEventListener(BaiDuAdEvent.onInterstitialDismiss, onCloseFullAd);
			BaiDu.getInstance().cacheInterstitial();
		}
		
		private function beginLater():void
		{
			gameScene.removeFromParent();
			this.addChild(gameOverPanel);
			BaiDu.getInstance().showBanner(BaiDu.BANNER,RelationPosition.BOTTOM_CENTER);
			gameOverPanel.patternTxt.text = GameUtil.getPatternName(GameInstance.instance.pattern);
			if (GameInstance.instance.pattern != GamePattern.FIGHT)
			{
				gameOverPanel.maxScoreTxt.visible = true;
				gameOverPanel.scoreTxt.visible = true;
				gameOverPanel.scoreTxt.text = Language.FENSHU.replace("$SCORE",GameInstance.instance.score);
				gameOverPanel.maxScoreTxt.text = Language.MAX_SCORE.replace("$SCORE",GameUtil.getMaxScore(GameInstance.instance.pattern));
			}else{
				gameOverPanel.maxScoreTxt.visible = false;
				gameOverPanel.scoreTxt.visible = false;
			}
		}
	}
}