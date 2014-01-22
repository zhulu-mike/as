package game.common.vos
{
	/**
	 * 引导开启条件
	 * @author Administrator
	 * 
	 */	
	public class GuideCondition
	{
		
		public function GuideCondition(type:int, data:*)
		{
			this.type = type;
			this.data = data;
		}
		
		public var type:int;
		public var data:*;
		/**
		 * 是否已经达到
		 */		
		public var ready:Boolean = false;
	}
}