package managers
{
	import flash.external.ExternalInterface;

	public class JSManager
	{
		public function JSManager()
		{
		}
		
		private static const js:XML = 
			<script><![CDATA[
		function open(url) {
			window. open(url, "_blank");
		}
]]></script>;
		
		private static var _instance:JSManager;
		public static function getInstance():JSManager
		{
			if (_instance == null)
				_instance = new JSManager();
			if( ExternalInterface.available){
				ExternalInterface.call(js);
				trace("init");
			}
			return _instance;
		}
		
		public function navigateToUrl(url:String):void
		{
			if( ExternalInterface.available)
				ExternalInterface.call("open", url);
		}
		
	}
}