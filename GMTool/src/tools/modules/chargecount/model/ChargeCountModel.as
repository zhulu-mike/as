package tools.modules.chargecount.model
{
	public class ChargeCountModel
	{
		public function ChargeCountModel()
		{
		}
		
		private static var _instance:ChargeCountModel;
		
		public static function getInstance():ChargeCountModel
		{
			if (_instance == null)
				_instance = new ChargeCountModel();
			return _instance;
		}
	}
}