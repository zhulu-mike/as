package managers
{
	public class LogManager
	{
		public function LogManager()
		{
		}
		
		public static var instance:GameSimulateTool;
		
		public static function logTrace(str:String):void
		{
//			instance.logTxt.appendText("\n");
//			instance.logTxt.appendText(str);
			trace(str);
		}
	}
}