package
{
	import configs.GameInstance;
	import configs.GameState;
	
	import events.GameEvent;
	
	import modules.mainui.views.MainMenu;
	import modules.scene.views.GameScene;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	
	public class Game extends Sprite
	{
		public function Game()
		{
			
			this.addEventListener(ResizeEvent.RESIZE, onResize);
			EventCenter.instance.addEventListener(GameEvent.GAME_STATE_CHANGE, stateHandler);
			EventCenter.instance.dispatchGameEvent(GameEvent.GAME_STATE_CHANGE,{state:GameState.BEGIN});
			this.addEventListener(Event.ADDED_TO_STAGE,onResize);
		}
		
		private function onResize(event:Event):void
		{
			GameInstance.instance.sceneWidth = stage.stageWidth;
			GameInstance.instance.sceneHeight = stage.stageHeight;
		}
		
		private var _mainMenu:MainMenu;

		public function get mainMenu():MainMenu
		{
			if (_mainMenu == null)
				_mainMenu = new MainMenu();
			return _mainMenu;
		}
		
		private var _gameScene:GameScene;

		public function get gameScene():GameScene
		{
			if (_gameScene == null)
				_gameScene = new GameScene();
			return _gameScene;
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
					break;
				case GameState.CONTINUE:
					break;
				default:
					break;
			}
		}
		
		private function begin():void
		{
			this.addChild(mainMenu);
		}
		
		/**
		 * 开始游戏
		 * @param pattern 游戏模式
		 * 
		 */		
		private function gameRun(pattern:int):void
		{
			this.addChild(gameScene);
			gameScene.start(pattern);
		}
	}
}