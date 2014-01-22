package tools.modules.charge.model
{
	public class ChargeModel
	{
		public function ChargeModel()
		{
		}
		/**
		 * 对应节点的data
		 */		
		public var data:int = 0;
		
		public var permission:int = 0;
		
		public var maxPage:int = 0;
		
		public var dataArr:Array=[];
		
		private static var _instance:ChargeModel;
		
		public static function getInstance():ChargeModel
		{
			if (_instance == null)
				_instance = new ChargeModel();
			return _instance;
		}
		
	}
}