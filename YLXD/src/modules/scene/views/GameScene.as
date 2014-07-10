package modules.scene.views
{
	import configs.GamePattern;
	
	import starling.display.Sprite;
	
	public class GameScene extends Sprite
	{
		public function GameScene()
		{
		}
		
		public function start(pattern:int):void
		{
			destory();
			switch (pattern)
			{
				case GamePattern.PUTONG:
					makePuTong();
					break;
			}
		}
		
		/**
		 * 先销毁之前的
		 * 
		 */		
		private function destory():void
		{
			
		}
		/**
		 * 普通模式
		 * 
		 */		
		private function makePuTong():void
		{
			var scene:ScenePart = new ScenePart();
			this.addChild(scene);
		}
	}
}