package com.manager
{
	import com.common.GameConfig;
	
	public class ResPathManager
	{
		
		public function ResPathManager()
		{
			return;
		}
		
		public static function get eName_XML() : String
		{
			return 'xml';
		}
		
		public static function get eName_SWF() : String
		{
//			return GameConfig.decode == null ? ("swf") : ("swc");
			return 'swf';
		}
		

		public static function getProgramPath_XML(param1:String, param2:String = "$program") : String
		{
			var _loc_3:String = null;
			var _loc_4:* = new RegExp("\\" + param2, "g");
			_loc_3 = param1.replace(_loc_4, GameConfig.program);
			_loc_3 = GameConfig.baseURL + _loc_3;
			_loc_3 = _loc_3.replace(".xml", "." + eName_XML);
//			if( GameConfig.isDebug ){
//				_loc_3 += ver ;
//			}
			return _loc_3;
		}
		
		public static function getProgramPath_BYT(param1:String, param2:String = "$program") : String
		{
			var _loc_3:String = null;
			var _loc_4:* = new RegExp("\\" + param2, "g");
			_loc_3 = param1.replace(_loc_4, GameConfig.program);
			_loc_3 = GameConfig.baseURL + _loc_3;
			//			_loc_3 = _loc_3.replace(".xml", "." + eName_XML);
//			if( GameConfig.isDebug ){
//				_loc_3 += ver ;
//			}
			return _loc_3;
		}
	}
}