package tools.modules.user.model
{
	public class UserModel
	{
		public function UserModel()
		{
		}
		/**
		 * 对应节点的data
		 */		
		public var data:int = 0;
		
		private static var _instance:UserModel;
		
		public static function getInstance():UserModel
		{
			if (_instance == null)
				_instance = new UserModel();
			return _instance;
		}
		
		public var maxPage:int = 0;
		
		
	}
}