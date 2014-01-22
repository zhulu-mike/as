package tools.modules.fightspirit.model
{
	public class FighterSpiritModel
	{
		public function FighterSpiritModel()
		{
		}
		private static var _instance:FighterSpiritModel;
		
		public var data:int = 0;
		
		public static function getInstance():FighterSpiritModel
		{
			if (_instance == null)
				_instance = new FighterSpiritModel();
			return _instance;
		}
		public var type:int = 1;
		
		public var maxPage:int = 0;
		
		public var gameuid:int = 0;
	
		public var is_main:int = 0;
		
		public var partnerid:int = 0;
	}
}