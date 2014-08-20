package com.mike.utils
{
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	public class NetUtil
	{
		public function NetUtil()
		{
		}
		
		public static function sendLogin(id:String):void
		{
			
		}
		
		private static function sendData(url:String, data:Object):void
		{
			var loader:URLLoader = new URLLoader();
			var req:URLRequest = new URLRequest(url);
			req.method = URLRequestMethod.GET;
			req.data = data;
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
			loader.load(req);
		}
		
		protected static function onHttpStatus(event:HTTPStatusEvent):void
		{
			event.target.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
			trace(event.status);
		}
		
		private static function onIOError(e:IOErrorEvent):void
		{
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			trace(e.text);
		}
		
		
	}
}