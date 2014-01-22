package tools.modules.addserver.model
{
	public class AddServerModel
	{
		public function AddServerModel()
		{
		}
		
		private static var _instance:AddServerModel;
		
		public static function getInstance():AddServerModel
		{
			if (_instance == null)
				_instance = new AddServerModel();
			return _instance;
		}
		
		public var platArr:Array=Global.mainVO.serPlatChosArr;
		
		public var serverArr:Array=[];
	}
}