package
{
	public class ActionVO
	{
		public function ActionVO()
		{
		}
		
		/**
		 * 动作名
		 */		
		public var name:String;
		
		public var xml:XML;
		
		/**
		 * 方向数量
		 */		
		public var directions:Array ;
		
		/**
		 * 单个方向的图片
		 */		
		public var bitmapDatas:Array = [];
	}
}