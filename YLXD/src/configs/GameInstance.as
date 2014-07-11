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
		
		public static const DOOR_DIS:int = 300;
		
		public var score:int = 0;
		
		public var pattern:int = 0;
	}
}