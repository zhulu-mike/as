package tools.modules.playerlevel.model
{
	public class PlayerLevelModel
	{
		public function PlayerLevelModel()
		{
		}
		
		private static var _instance:PlayerLevelModel;
		
		public static function getInstance():PlayerLevelModel
		{
			if (_instance == null)
				_instance = new PlayerLevelModel();
			return _instance;
		}
	}
}