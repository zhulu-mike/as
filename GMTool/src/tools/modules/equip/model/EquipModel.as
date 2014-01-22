package tools.modules.equip.model
{
	public class EquipModel
	{
		public function EquipModel()
		{
		}
		
		private static var _instance:EquipModel;
		
		public static function getInstance():EquipModel
		{
			if (_instance == null)
				_instance = new EquipModel();
			return _instance;
		}
		
		public var permiss:int= 0;
	}
}