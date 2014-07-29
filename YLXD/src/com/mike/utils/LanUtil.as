package com.mike.utils
{
	import flash.system.Capabilities;

	public class LanUtil
	{
		public function LanUtil()
		{
		}
		
		public static function getCurrentLangeFile():String
		{
			var lan:String = "";
			if (Capabilities.languages.length > 0)
			{
				lan = Capabilities.languages[0];
			}else{
				lan = LanType.ENGLISH;
			}
			var file:String = "english";
			switch (lan)
			{
				case LanType.ZHONGGUO:
					file = "chinese";
					break;
				case LanType.JAPANESE:
					file = "japanese";
					break;
				case LanType.HANYU:
					file = "hanyu";
					break;
				default:
					break;
			}
			return file + ".xml";
		}
		
		
			
	}
}