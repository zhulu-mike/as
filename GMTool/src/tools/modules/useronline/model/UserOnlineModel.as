package tools.modules.useronline.model
{
	public class UserOnlineModel
	{
		public function UserOnlineModel()
		{
		}
		
		private static var _instance:UserOnlineModel;
		
		public static function getInstance():UserOnlineModel
		{
			if (_instance == null)
				_instance = new UserOnlineModel();
			return _instance;
		}
		
		public var onlineData:Array=[];
	}
}