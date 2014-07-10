package modules.scene.views
{
	import configs.GameInstance;
	
	import starling.display.Sprite;
	
	public class ScenePart extends Sprite
	{
		/**
		 * 道路
		 */		
		private var road:Road;
		
		public function ScenePart()
		{
			mainPlayer = new MainPlayer();
			this.addChild(mainPlayer);
			
			road = new Road(GameInstance.instance.sceneWidth);
			this.addChild(road);
			
		}
		
		/**
		 * 主角
		 */		
		public var mainPlayer:MainPlayer;
		
	}
}