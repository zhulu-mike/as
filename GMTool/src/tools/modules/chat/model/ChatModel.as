package tools.modules.chat.model
{
	public class ChatModel
	{
		public function ChatModel()
		{
		}
		
		private static var _instance:ChatModel;
		
		public static function getInstance():ChatModel
		{
			if (_instance == null)
				_instance = new ChatModel();
			return _instance;
		}
		
		public var data:int = 0;
		
		/**
		 * 本功能的权限
		 */		
		public var permission:int = 0;
	}
}