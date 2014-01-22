package tools.managers
{
	import flash.external.ExternalInterface;

	public class BrowseManager
	{
		public function BrowseManager()
		{
		}
		
		public static function refresh():void
		{
			if (ExternalInterface.available)
			{
				ExternalInterface.addCallback("refresh",callBack);
				ExternalInterface.call("refresh");
			}
		}
		
		private static function callBack():void
		{
			
		}
	}
}