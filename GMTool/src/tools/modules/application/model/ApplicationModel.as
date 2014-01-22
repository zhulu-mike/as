package tools.modules.application.model
{
	public class ApplicationModel
	{
		public function ApplicationModel()
		{
		}
		
		private static var _instance:ApplicationModel;
		
		public static function getInstance():ApplicationModel
		{
			if (_instance == null)
				_instance = new ApplicationModel();
			return _instance;
		}
		
		public var agreeId:int=0;
		
		public var platChosArr:Array=Global.mainVO.platChosArrA;
	}
}