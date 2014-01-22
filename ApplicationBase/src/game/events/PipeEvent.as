package game.events
{
	/**
	 * 管道事件
	 * @author Administrator
	 * 
	 */	
	public class PipeEvent
	{
		public function PipeEvent()
		{
		}
		
		/**
		 * 启动引擎模块
		 */		
		public static const STARTUP_ENGINE:String = "game.modules.engine.Engine_ApplicationFacade";
		/**
		 * 启动引导模块
		 */		
		public static const STARTUP_ASSISTANT:String = "game.modules.engine.Engine_ApplicationFacade";
		/**
		 * 显示引导模块
		 */		
		public static const SHOW_ASSISTANT_MAINUI:String = "SHOW_ASSISTANT_MAINUI";
	
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		/**
		 * 引导状态通知
		 */		
		public static const GAME_GUIDE_NOTIFY:String = "GAME_GUIDE_NOTIFY";
		
		/**
		 * 关闭引导箭头
		 */		
		public static const CLOSE_ASSISTANT_MAINUI:String = "CLOSE_ASSISTANT_MAINUI";
	
	
	}
}