package tools.modules.player.model
{
	public class PlayerModel
	{
		public function PlayerModel()
		{
		}
		private static var _instance:PlayerModel;
		
		public var data:int = 0;
		
		public static function getInstance():PlayerModel
		{
			if (_instance == null)
				_instance = new PlayerModel();
			return _instance;
		}
		
		//最大的页数
		public var maxPage:int = 0;
		
		//选择的查询类型
		public var type:int = 3;
		
		//按钮的次数
		public var btnNum:int = 0;
		
		public var uid:int = 1;
		
		public var gameuid:int = 0;
		
		public var main_id:int = 0;
		
		public var career:int = 0;
		
		public var name:String = '';
		
		//1是主角，0是战魂
		public var is_main:int = 1;
		public var partnerid:int = 0;
	}
}