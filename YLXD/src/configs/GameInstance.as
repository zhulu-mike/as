package configs
{
	import infos.GameRecord;
	import infos.data.LocalSO;

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
		
		/**
		 * 两次出拳之间的距离，可用来控制游戏难度
		 */		
		public static const DOOR_DIS:int = 400;
		
		public var score:int = 0;
		
		public var pattern:int = 0;
		
		public var YLXD_CLASS:Class;
		
		public var scoreRecord:GameRecord = new GameRecord();
		
		public var so:LocalSO;
		
		public var lastShowFullAd:int;
		
		public static const SHOW_AD_DELAY:int = 60000;
		
		/**
		 * 剩下几局显示大屏广告
		 */		
		public var leftShowFullAd:int = 10;
		/**
		 *每10局显示一次 
		 */		
		public static const FULLE_AD:int = 10;
		
	}
}