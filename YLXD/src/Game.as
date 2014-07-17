package
{
	
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import configs.GameInstance;
	import configs.GamePattern;
	import configs.GameState;
	
	import events.GameEvent;
	
	import managers.GameUtil;
	import managers.ResManager;
	
	import modules.mainui.views.MainMenu;
	import modules.mainui.views.WorkRoomIntroduceStarling;
	import modules.scene.views.GameOver;
	import modules.scene.views.GameScene;
	
	import so.cuo.platform.baidu.BaiDu;
	import so.cuo.platform.baidu.BaiDuAdEvent;
	import so.cuo.platform.baidu.RelationPosition;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;
	
	public class Game extends Sprite
	{
		private var music:Image;
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
			var am:AssetManager = new AssetManager();
			ResManager.assetsManager = am;
			var ta:TextureAtlas = new TextureAtlas(Texture.fromEmbeddedAsset(GameInstance.instance.YLXD_CLASS),GameInstance.instance.YLXD_XML);
			am.addTextureAtlas(ResManager.YLXD_NAME,ta);
			music = new Image(ResManager.assetsManager.getTextureAtlas(ResManager.YLXD_NAME).getTexture("btn_sound_on.png"));
			this.addChild(music);
			music.x = stage.stageWidth - music.width - 10;
			music.addEventListener(TouchEvent.TOUCH, onTouchMusic);
			EventCenter.instance.dispatchGameEvent(GameEvent.GAME_STATE_CHANGE,{state:GameState.BEGIN});
			EventCenter.instance.addEventListener(GameEvent.SHOW_INTRODUCE, onShowIntroduce);
			this.addEventListener(Event.ENTER_FRAME, onRender);
		}
		
		protected function onShowIntroduce(event:GameEvent):void
		{
			this.addChild(introduce);
		}
		
		protected function onCloseIntroduce(event:TouchEvent):void
		{
			var touch:Touch = event.touches[0];
			if (touch.phase == TouchPhase.ENDED)
			{
				this.removeChild(_introduce);
				EventCenter.instance.dispatchGameEvent(GameEvent.GAME_STATE_CHANGE,{state:GameState.BEGIN});
			}
		}
		
		private function onTouchMusic(e:TouchEvent):void
		{
			var touch:Touch = e.touches[0];
			if (touch.phase == TouchPhase.ENDED)
			{
				GameInstance.instance.soundEnable = !GameInstance.instance.soundEnable;
				if (GameInstance.instance.soundEnable)
					music.texture = ResManager.assetsManager.getTextureAtlas(ResManager.YLXD_NAME).getTexture("btn_sound_on.png");
				else
					music.texture = ResManager.assetsManager.getTextureAtlas(ResManager.YLXD_NAME).getTexture("btn_sound_off.png");
			}
		}
		
		private var _introduce:WorkRoomIntroduceStarling;
		public function get introduce():WorkRoomIntroduceStarling
		{
			if (_introduce == null){
				_introduce = new WorkRoomIntroduceStarling(GameInstance.instance.sceneWidth, GameInstance.instance.sceneHeight);
				_introduce.addEventListener(TouchEvent.TOUCH, onCloseIntroduce);
			}
			return _introduce;
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
			this.addChildAt(mainMenu,0);
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
			this.addChildAt(gameScene,0);
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
					//延迟1秒显示
					setTimeout(showFullAdvise,1000);
				}
			}
		}
		/**
		 * 显示全屏广告
		 * 
		 */		
		private function showFullAdvise():void
		{
			BaiDu.getInstance().showInterstitial();
			BaiDu.getInstance().addEventListener(BaiDuAdEvent.onInterstitialDismiss, onCloseFullAd);
			GameInstance.instance.leftShowFullAd = GameInstance.FULLE_AD;
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
			this.addChildAt(gameOverPanel,0);
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