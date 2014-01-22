package tools.common.vo
{
	public class UserToolInfo
	{
		public function UserToolInfo()
		{
		}
		
		/**道具ID*/
		public var id:int;
		
		
		/**道具的配置ID*/
		public var cid:int;
		
		public var count:int;
		
		public var grid:int;
		
		public var toolBase:ToolBase;
		
		public var toolAtt:ToolAttInfo = new ToolAttInfo();
	}
}