package tools.modules.playerequip.model
{
	public class PlayerEquipModel
	{
		public function PlayerEquipModel()
		{
		}
		private static var _instance:PlayerEquipModel;
		
		public var data:int = 0;
		
		public static function getInstance():PlayerEquipModel
		{
			if (_instance == null)
				_instance = new PlayerEquipModel();
			return _instance;
		}
	}
}