package tools.modules.prop.model
{
	public class PropModel
	{
		public function PropModel()
		{
		}
		
		private static var _instance:PropModel;
		
		public static function getInstance():PropModel
		{
			if (_instance == null)
				_instance = new PropModel();
			return _instance;
		}
		
		public var data:Object=new Object();
		public var permiss:Object=new Object();
	}
}