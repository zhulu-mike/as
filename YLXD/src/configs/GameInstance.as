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
		
		public static const REVERSE_DELAY:int = 5000;
		
		public var isIos:Boolean = false;
		
		public var sceneWidth:int;
		
		public var sceneHeight:int;
		
		/**
		 * 两次出拳之间的距离，可用来控制游戏难度
		 */		
		public static var DOOR_DIS:int = 1600;
		
		public var score:int = 0;
		
		public var pattern:int = 0;
		
		public var YLXD_CLASS:Class;
		public var LOG_CLASS:Class;
		
		public var scoreRecord:GameRecord = new GameRecord();
		
		public var so:LocalSO;
		
		public var lastShowFullAd:int;
		
		public static const SHOW_AD_DELAY:int = 60000;
		
		/**
		 * 剩下几局显示大屏广告
		 */		
		public var leftShowFullAd:int = 5;
		/**
		 *每5局显示一次 
		 */		
		public static const FULLE_AD:int = 5;
		
		public static var INIT_SPEED:int = 48;
		
		public var soundEnable:Boolean = true;
		
		public var YLXD_XML:XML = null;
		
		public var haveStarlingCreate:Boolean = false;
		
		public var resLoadCom:Boolean = false;
		
		public var introduceTime:int = 0;
		
		public var currentSpeed:int = 5;
		
		public static const WUDITIME:int = 5000;
		public static var WUDISPEED:int = 64;
		/**
		 * 加速度
		 */		
		public static var  ACCERATE_SPEED:Number = 0.53333332;
		
		public var gameState:int = 0;
		
		/**
		 * 适应多分辨率，缩放资源大小
		 */		
		public var scaleRatio:Number = 1.0;
		
	}
}