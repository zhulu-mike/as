package com.mike.utils
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class NetUtil
	{
		public function NetUtil()
		{
		}
		
		/**
		 * 发送活跃用户数据
		 */		
		public static const HUOYUE_URL:String = "http://www.g6game.com/fkzs/interfaces/huoyue.php";
		
		/**
		 * 发送用户每日登陆数据
		 * @param id
		 * @param callBack
		 * 
		 */		
		public static function sendLogin(id:String, name:String, callBack:Function=null):void
		{
			var data:URLVariables = new URLVariables();
			data['userid'] = id;
			data['plat'] = PlatUtil.currentPlat;
			data['name'] = name;
			sendData(HUOYUE_URL,data,callBack);
		}
		
		private static function sendData(url:String, data:Object,callBack:Function=null):void
		{
			var loader:URLLoader = new URLLoader();
			var req:URLRequest = new URLRequest(url);
			req.method = URLRequestMethod.GET;
			req.data = data;
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
			loader.addEventListener(Event.COMPLETE, function():void{if (callBack != null) callBack();});
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