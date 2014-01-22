package tools.modules.supgas.model
{
	public class SuperGasModel
	{
		public function SuperGasModel()
		{
		}
		private static var _instance:SuperGasModel;
		
		public var data:int = 0;
		public static function getInstance():SuperGasModel
		{
			if (_instance == null)
				_instance = new SuperGasModel();
			return _instance;
		}
	}
}