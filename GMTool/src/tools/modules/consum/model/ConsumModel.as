package tools.modules.consum.model
{
	public class ConsumModel
	{
		public function ConsumModel()
		{
		}
		
		private static var _instance:ConsumModel;
		
		public static function getInstance():ConsumModel
		{
			if (_instance == null)
				_instance = new ConsumModel();
			return _instance;
		}
		
		public var maxPage:int=0;
		
		public var moneyType:int=1;
	}
}