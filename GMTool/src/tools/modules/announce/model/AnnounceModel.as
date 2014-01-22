package tools.modules.announce.model
{
	public class AnnounceModel
	{
		public function AnnounceModel()
		{
		}
		
		private static var _instance:AnnounceModel;
		
		public static function getInstance():AnnounceModel
		{
			if (_instance == null)
				_instance = new AnnounceModel();
			return _instance;
		}
		
		/**公告内容*/
		public var annContent:String='';
		
		/**播放次数*/
		public var number:int=1;
		
		/**是否插入聊天框*/
		public var ifInsertContent:int=0;
		
		/**删除的公告ID*/
		public var deleteId:int=0;
	}
}