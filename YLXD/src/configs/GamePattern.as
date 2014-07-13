package configs
{
	
	/**
	 * 游戏模式
	 * @author Administrator
	 * 
	 */	
	public class GamePattern
	{
		public function GamePattern()
		{
		}
		
		/**
		 * 普通模式
		 */		
		public static const PUTONG:int = 1;
		
		/**
		 * 对战
		 */		
		public static const FIGHT:int = 2;
		
		/**
		 * 逆向，输的为赢
		 */		
		public static const NIXIANG:int = 3;
	}
}