package game.common.res.sysFunNotice
{
	public class FuncOpenRes
	{
		public var id:int;
		/**功能名称*/
		public var name:String;
		/**功能描述*/
		public var desc:String;
		/**功能类型*/
		public var type:int;
		/**开启接取任务ID*/
		public var openAcceptTask:int;
		/**开启结束任务ID*/
		public var openFinishedTask:int;
		/**开启等级*/
		public var openLevel:int;
		/**关闭接取任务ID*/
		public var closeAcceptTask:int;
		/**关闭结束任务ID*/
		public var closeFinishedTask:int;
		/**关闭等级*/
		public var closeLevel:int;
		
		public function FuncOpenRes()
		{
		}
	}
}