package game.common.res.activity
{
	public class ActiRateRes
	{
		public var id:int;
		public var icon:int;
		public var name:String;
		public var desc:String;
		/**完成总数*/
		public var total:int;
		/**活跃度奖励*/
		public var rate:int;
		/**操作类型*/
		public var operateType:int;
		/**匹配已接任务id*/
		public var mapAcceptedTask:int;
		/**匹配已完成任务id*/
		public var mapFinishedTask:int;
		
		public var targetNPC:int;
		public var path:String;
		
		public function ActiRateRes()
		{
		}
	}
}