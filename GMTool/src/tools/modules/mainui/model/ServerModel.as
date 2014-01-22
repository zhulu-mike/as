package tools.modules.mainui.model
{
	public class ServerModel
	{
		public function ServerModel()
		{
		}
		
		private static var _instance:ServerModel;
		
		public static function getInstance():ServerModel
		{
			if (_instance == null)
				_instance = new ServerModel();
			return _instance;
		}
		
		public var platArr:Array=Global.mainVO.platChosArr;
		
		public var serverArr:Array=[];
	}
}