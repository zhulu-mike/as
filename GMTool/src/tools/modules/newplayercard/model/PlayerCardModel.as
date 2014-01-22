package tools.modules.newplayercard.model
{

	public class PlayerCardModel
	{
		public function PlayerCardModel()
		{
		}
		
		private static var _instance:PlayerCardModel;
		
		public static function getInstance():PlayerCardModel
		{
			if (_instance == null)
				_instance = new PlayerCardModel();
			return _instance;
		}
		
		public var cardType:Array=[];
		
		public var allCardType:Array=[];
		
		public var keepArr:Array=[];
		
		public var maxPage:int=0;
	}
}