package tools.modules.vipcareer.model
{
	public class VipCareerModel
	{
		public function VipCareerModel()
		{
		}
		
		private static var _instance:VipCareerModel;
		
		public static function getInstance():VipCareerModel
		{
			if (_instance == null)
				_instance = new VipCareerModel();
			return _instance;
		}
	}
}