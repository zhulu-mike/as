package game.manager
{
	import game.config.GameConfig;

	public class ResPathManager
	{
		public function ResPathManager()
		{
		}
		
		/**
		 * 地图配置
		 */		
		public static var MAP_CONFIG:String = "res/data/maps/$.";
		/**
		 * 地图缩略图，用做马赛克
		 */		
		public static var MAP_SMALL_IMAGE:String = "res/smallMap/$.jpg";
		
		/**
		 * 地图切换后的小图片路径
		 */		
		public static const MAP_ZONE_DIR:String = "res/data/map1/$/";
		
		/**
		 * 
		 */		
		public static const AVATAR_MAP_SLIPCOVER:String = "res/data/avatar/effect/eid$.";
		
		public static const AVATAR_SC_PATH:String = "res/data/avatar/clothes/mid$.";
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		/**
		 * 调试模式下加载XML，运行模式加载thi格式
		 * @return 
		 * 
		 */		
		public static function get eName_XML() : String
		{
			return GameConfig.isDebug == true ? ("xml") : ("thi");
		}
		/**
		 * 调试模式下加载XML，运行模式加载thi格式
		 * @return 
		 * 
		 */	
		public static function get eName_SWF() : String
		{
			return GameConfig.decode == null ? ("swf") : ("swc");
		}
	}
}