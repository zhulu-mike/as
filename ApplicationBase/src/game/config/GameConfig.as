package game.config
{
	public class GameConfig
	{
		public function GameConfig()
		{
		}
		
		/**
		 * 帧频
		 */		
		public static var frameRate:int = 60;
		
		/**
		 * 基本资源路径
		 */		
		public static var baseFileUrl:String = "";
		
		/**
		 * 是否是调试模式
		 */		
		public static var isDebug:Boolean = true;
		
		/**
		 * 解码接口
		 */		
		public static var decode:Function;
		
		/**
		 * 场景宽
		 */		
		public static var sceneWidth:Number = 1024;
		
		/**
		 * 场景高
		 */				
		public static var sceneHeight:Number = 768;
	}
}