package tools.modules.checkcard.model
{
	public class CheckCardModel
	{
		public function CheckCardModel()
		{
			
		}
		private static var _instance:CheckCardModel;
		
		public static function getInstance():CheckCardModel
		{
			if (_instance == null)
				_instance = new CheckCardModel();
			return _instance;
		}
		
		public var arrProp:Array=[];
		public var arrEqup:Array=[];
		
		public var propNum:int=0;//道具数量
		public var equiNum:int=0;//装备数量
		
		public var selectProp:Array=[];//所选道具数据
		public var selectEqui:Array=[];//所选装备数组
	}
}