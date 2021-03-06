package
{
	
	import com.mike.utils.AdvertiseUtil;
	
	import configs.GameConfig;
	import configs.GameInstance;
	import configs.GamePattern;
	import configs.GameState;
	
	import events.GameEvent;
	
	import managers.BackGroundFactory;
	import managers.GameUtil;
	import managers.ResManager;
	
	import modules.mainui.views.MainMenu;
	import modules.mainui.views.WorkRoomIntroduceStarling;
	import modules.scene.views.GameOver;
	import modules.scene.views.GameScene;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.QuadBatch;
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
		private var bg:QuadBatch;
		private var firstLayer:Sprite;
		private var secondeLayer:Sprite;
		private var showBG:Boolean = true;
		private var bgItem:Image;
		
		public function Game()
		{
			EventCenter.instance.addEventListener(GameEvent.GAME_STATE_CHANGE, stateHandler);
			this.addEventListener(Event.ADDED_TO_STAGE,onResize);
		}
		
		private function onRender(event:Event):void
		{
//			var t:int = getTimer();
			gameScene.update();
//			trace("背景耗时"+(getTimer() - t));
		}
		
		
		private function onResize(event:Event):void
		{
			trace("添加到舞台");
			GameInstance.instance.sceneWidth = stage.stageWidth;
			GameInstance.instance.sceneHeight = stage.stageHeight;
			EventCenter.instance.addEventListener(GameEvent.START_GAME, beginAfterRes);
			EventCenter.instance.dispatchEvent(new GameEvent(GameEvent.STARLING_CREATE));
		}
		
		
		public function beginAfterRes(e:GameEvent=null):void
		{
			var am:AssetManager = new AssetManager();
			ResManager.assetsManager = am;
			var ta:TextureAtlas = new TextureAtlas(Texture.fromBitmap(ResManager.resLoader.getContent(ResManager.YLXD,true)),ResManager.resLoader.getContent(ResManager.YLXDXML,true));
			am.addTextureAtlas(ResManager.YLXD_NAME,ta);
			ta = new TextureAtlas(Texture.fromBitmap(ResManager.resLoader.getContent(ResManager.YLXD2,true)),ResManager.resLoader.getContent(ResManager.YLXDXML2,true));
			am.addTextureAtlas(ResManager.YLXD_NAME2,ta);
			GameConfig.pipeHeight = ResManager.assetsManager.getTexture("swing_arm.png").height;
			initUI();
			EventCenter.instance.dispatchGameEvent(GameEvent.GAME_STATE_CHANGE,{state:GameState.BEGIN});
			EventCenter.instance.addEventListener(GameEvent.SHOW_INTRODUCE, onShowIntroduce);
			EventCenter.instance.addEventListener(GameEvent.CONTROL_BIG_BACKGROUND, onControlBackGround);
			EventCenter.instance.addEventListener(GameEvent.SHOW_MORE_GAME, showMoreGame);
			EventCenter.instance.addEventListener(GameEvent.SHOW_HELP_PANEL, showHelpPanel);
		}
		
		private function initUI():void
		{
			firstLayer = new Sprite();
			this.addChild(firstLayer);
			
			bg = new QuadBatch();
			firstLayer.addChild(bg);
			bgItem = BackGroundFactory.getInstance().getShape();
			bgItem.height = GameInstance.instance.sceneHeight;
			bg.blendMode = BlendMode.NONE;
			createBackground();
			
			secondeLayer = new Sprite();
			this.addChild(secondeLayer);
			
			music = new Image(ResManager.assetsManager.getTexture("btn_sound_on.png"));
			this.addChild(music);
			music.scaleX = music.scaleY = GameInstance.instance.scaleRatio;
			music.x = stage.stageWidth - music.width - 20;
			music.y = 10;
			music.addEventListener(TouchEvent.TOUCH, onTouchMusic);
		}
		
		private var bgImages:Array = [];
		private function createBackground():void
		{
			var i:int = 0, len:int = bgImages.length;
			var img:Object;
			var totalWidth:int = 0;
			for (;i<len;i++)
			{
				img = bgImages[i];
				if (img.x < 0)
					totalWidth += (img.width + img.x);
				else
					totalWidth += img.width;
			}
			var itemW:int = bgItem.width;
			while (GameInstance.instance.sceneWidth > totalWidth)
			{
				
				bgItem.x = totalWidth;
				bg.addImage(bgItem);
				bgImages.push({x:totalWidth, width:itemW});
				totalWidth += itemW;
				
			}
		}
		
		protected function onShowIntroduce(event:GameEvent):void
		{
			AdvertiseUtil.hideBaiDuBanner();
			secondeLayer.addChild(introduce);
		}
		
		protected function onCloseIntroduce(event:TouchEvent):void
		{
			var touch:Touch = event.touches[0];
			if (touch.phase == TouchPhase.ENDED)
			{
				secondeLayer.removeChild(_introduce);
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
					music.texture = ResManager.assetsManager.getTexture("btn_sound_on.png");
				else
					music.texture = ResManager.assetsManager.getTexture("btn_sound_off.png");
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
				var hh:Number = _gameOverPanel.height;
				_gameOverPanel.y = GameInstance.instance.sceneHeight - hh >> 1;
				_gameOverPanel.x = GameInstance.instance.sceneWidth - _gameOverPanel.width >> 1;
				if (GameInstance.instance.sceneHeight - (_gameOverPanel.y+hh) < 50)
					_gameOverPanel.y = GameInstance.instance.sceneHeight - 50-hh;
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
			GameInstance.instance.gameState = state;
			switch (state)
			{
				case GameState.BEGIN:
					begin();
					break;
				case GameState.RUNNING:
					gameRun();
					break;
				case GameState.PAUSE:
					pauseGame();
					break;
				case GameState.OVER:
					endGame();
					break;
				case GameState.CONTINUE:
					continueGame();
					break;
				default:
					break;
			}
		}
		
		private function continueGame():void
		{
			this.addEventListener(Event.ENTER_FRAME, onRender);
		}
		
		private function pauseGame():void
		{
			this.removeEventListener(Event.ENTER_FRAME, onRender);
		}
		
		private function begin():void
		{
			AdvertiseUtil.showBaiDuBanner();
			firstLayer.addChild(bg);
			gameScene.removeFromParent();
			secondeLayer.addChild(mainMenu);
		}
		
		/**
		 * 开始游戏
		 * 
		 */		
		private function gameRun():void
		{
			AdvertiseUtil.hideBaiDuBanner();
			GameInstance.instance.score = 0;
			bg.removeFromParent();
			secondeLayer.addChild(gameScene);
			gameScene.start();
			this.addEventListener(Event.ENTER_FRAME, onRender);
		}
		
		private function endGame():void
		{
			GameInstance.instance.gameState = GameState.OVER;
			this.removeEventListener(Event.ENTER_FRAME, onRender);
			beginLater();
			GameUtil.showFullSceenAd();
		}
		
		
		
		private function beginLater():void
		{
			secondeLayer.addChild(gameOverPanel);
			AdvertiseUtil.showBaiDuBanner();
			gameOverPanel.scoreTxt.text = Language.getString("FENSHU").replace("$SCORE",GameInstance.instance.score);
			gameOverPanel.maxScoreTxt.text = Language.getString("MAX_SCORE").replace("$SCORE",GameUtil.getMaxScore());
		}
		
		private function onControlBackGround(event:GameEvent):void
		{
			showBG = event.data as Boolean;
			if (!showBG)
			{
				bg.removeFromParent();
			}else{
				firstLayer.addChild(bg);
			}
		}
		
		/**
		 * 显示更多游戏
		 * @param e
		 * 
		 */		
		private function showMoreGame(e:GameEvent):void
		{
			GameUtil.showMoreGame();
		}
		
		/**
		 * 显示帮助界面
		 * 
		 */		
		private function showHelpPanel():void
		{
			
		}
	}
}