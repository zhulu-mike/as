package tools.modules.passport.model
{
	public class PassportModel
	{
		public function PassportModel()
		{
		}
		
		private static var _instance:PassportModel;
		
		public static function getInstance():PassportModel
		{
			if (_instance == null)
				_instance = new PassportModel();
			return _instance;
		}
		
		public var buttonType:int = 3;
		
		public var type:int = 0;
		
		public var id:int = 0;
		public var user_level:int = 0;
		public var permission:String= '';
		
		///修改密码
		public var lastPsw:String ='';
		public var newPsw:String ='';
		public var iknow:String ='';
		public var recLastPsw:String = '';
		
		//删除
		public var delId:int=0;
		public var delLevel:int=0;
		
		public var platChossArr:Array=[];
		public var platObj:Array=[];
		
		
	}
}