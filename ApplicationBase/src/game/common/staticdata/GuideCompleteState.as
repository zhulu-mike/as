package game.common.staticdata
{
	
	/**
	 * 新手引导状态定义
	 */
	public class GuideCompleteState
	{
		public function GuideCompleteState()
		{
		}
		
		/**未开启*/
		public static const CLOSE:int = 1;
		
		/**进行中*/
		public static const PROGRESS:int = 2;
		
		/**结束*/
		public static const END:int = 3;
	}
}