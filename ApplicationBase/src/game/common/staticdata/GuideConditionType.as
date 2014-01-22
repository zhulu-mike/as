package game.common.staticdata
{
	/**
	 * 引导开启条件类型
	 * @author Administrator
	 * 
	 */	
	public class GuideConditionType
	{
		public function GuideConditionType()
		{
		}
		
		/**
		 * 角色等级
		 */		
		public static const LEVEL:int = 1;
		
		/**
		 * 功能开启
		 */		
		public static const FUNCTION_OPEN:int = 2;
		
		/**
		 * 任务开启
		 */		
		public static const TASK_OPEN:int = 3;
		
		/**
		 * 任务结束
		 */		
		public static const TASK_END:int = 4;
		
	}
}