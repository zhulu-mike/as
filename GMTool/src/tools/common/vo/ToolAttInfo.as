package tools.common.vo
{
	public class ToolAttInfo
	{
		public function ToolAttInfo()
		{
		}
		
		/**使用次数*/
		public var useCount:int;
		
		/**过期时间，0表示不过期*/
		public var invalidateTime:int;
		
		public var grid:int;
	}
}