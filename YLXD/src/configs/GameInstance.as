package configs
{
	public class GameInstance
	{
		public function GameInstance()
		{
		}
		
		private static var _instance:GameInstance;
		
		public static function get instance():GameInstance
		{
			if (_instance == null)
				_instance = new GameInstance();
			return _instance;
		}
		
		public var sceneWidth:int;
		
		public var sceneHeight:int;
	}
}