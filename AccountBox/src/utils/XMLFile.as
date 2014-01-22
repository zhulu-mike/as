package utils
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class XMLFile
	{
		public function XMLFile()
		{
		}
		
		private static var comHandler:Function;
		
		public static function load(url:String, comFunc:Function):void
		{
			comHandler = comFunc;
			var loader:URLLoader = new URLLoader();
			loader.load(new URLRequest(url));
			loader.addEventListener(Event.COMPLETE, onComplete);
		}

		private static function onComplete(event:Event):void
		{
			var loader:URLLoader = event.target as URLLoader;
			loader.removeEventListener(Event.COMPLETE, onComplete);
			var data:XML = XML(loader.data);
			if (comHandler != null)
			{
				comHandler(data);
			}
		}
	}
}