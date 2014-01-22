package tools.modules.chargerank.model
{
	public class ChargeRankModel
	{
		public function ChargeRankModel()
		{
		}
		
		private static var _instance:ChargeRankModel;
		
		public static function getInstance():ChargeRankModel
		{
			if (_instance == null)
				_instance = new ChargeRankModel();
			return _instance;
		}
		
		public var maxPage:int=1;
	}
}