package global
{
	import setting.Hostory;

	public class GlobalConfig
	{
		public function GlobalConfig()
		{
			if (_instance != null)
			{
				throw "GlobalConfig 为单例";
			}
		}
		private static var _instance:GlobalConfig;
		
		public static function get instance() : GlobalConfig
		{
			if (_instance == null)
			{
				_instance = new GlobalConfig;
			}
			return _instance;
		}
		
		public var hostory:Hostory = null;
		public var versionDic:Object = {} ;
		
	}
}