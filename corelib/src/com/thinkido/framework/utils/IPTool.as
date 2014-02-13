package com.thinkido.framework.utils 
{
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	/**
	 * ip 工具 
	 * @author thinkido
	 * 
	 */	
	public class IPTool
	{
		public function IPTool()
		{
		}
		
		private static var urlloader:URLLoader = new URLLoader();
		
		private static var fault:Function;
		
		private static var result:Function;
		
		/**
		 * 当前IP的信息
		 * {"ret":1,"start":"124.90.40.0","end":"124.90.75.255","country":"中国","province":"浙江","city":"杭州","district":"","isp":"杭州","type":"","desc":""}
		 */
		public static var currentIPInfo:Object;
		
		/***/
		public static function init():void
		{
			var com:Function = function (ret:Object):void{
				currentIPInfo = ret;
			};
			searchAddress(com);
		}
		
		/**获取当前IP的国家*/
		public static function get country():String
		{
			if (currentIPInfo == null)
				throw new Error("请先初始化");
			return currentIPInfo.country;
		}
		
		/**获取当前IP的省份*/
		public static function get province():String
		{
			if (currentIPInfo == null)
				throw new Error("请先初始化");
			return currentIPInfo.province;
		}
		
		/**获取当前IP的城市*/
		public static function get city():String
		{
			if (currentIPInfo == null)
				throw new Error("请先初始化");
			return currentIPInfo.city;
		}
		
		/**获取当前IP的district*/
		public static function get district():String
		{
			if (currentIPInfo == null)
				throw new Error("请先初始化");
			return currentIPInfo.district;
		}
		
		/**获取当前IP的isp*/
		public static function get isp():String
		{
			if (currentIPInfo == null)
				throw new Error("请先初始化");
			return currentIPInfo.isp;
		}
		
		/**获取当前IP的type*/
		public static function get type():String
		{
			if (currentIPInfo == null)
				throw new Error("请先初始化");
			return currentIPInfo.type;
		}
		
		/**获取当前IP的desc*/
		public static function get desc():String
		{
			if (currentIPInfo == null)
				throw new Error("请先初始化");
			return currentIPInfo.desc;
		}
		
		/**获取当前IP的start*/
		public static function get start():String
		{
			if (currentIPInfo == null)
				throw new Error("请先初始化");
			return currentIPInfo.start;
		}
		
		/**获取当前IP的end*/
		public static function get end():String
		{
			if (currentIPInfo == null)
				throw new Error("请先初始化");
			return currentIPInfo.end;
		}
		
		/**获取当前IP的ret*/
		public static function get ret():String
		{
			if (currentIPInfo == null)
				throw new Error("请先初始化");
			return currentIPInfo.ret;
		}
		
		/**
		 * 根据传入的IP地址，查询其归属地
		 * @param ip 可为""，表示取当前APP的所在域名IP
		 * @ret 回调函数
		 */		
		public static function searchAddress(ret:Function=null, ip:String=""):void
		{
			result = ret;
			urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			var url:URLRequest = new URLRequest();
			//			url.url = "http://www.youdao.com/smartresult-xml/search.s?type=ip";
			url.url = "http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=js";
			url.method = URLRequestMethod.POST;
			var _data:URLVariables = new URLVariables();
			if (ip != "")
				_data["q"] = ip;
			url.data = _data;
			configureListeners(urlloader);
			urlloader.load(url);
		}
		
		private static function configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(Event.OPEN, openHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		/**
		 * 接受数据并将数据转化为正常显示的gb2312 
		 * @param event
		 * 
		 */		
		private static function completeHandler(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			var translateBy:ByteArray = new ByteArray; 
			translateBy.writeBytes(loader.data); 
			translateBy.position = 0; 
			var temp:String = translateBy.readMultiByte(translateBy.length,"gb2312");
			temp = temp.substr(21, temp.length - 22);
			var obj:Object = com.adobe.serialization.json.JSON.decode(temp);
			if( result != null ){
				result.call(null,obj);
				result = null ;
			}else{
				trace("The answer is :" + obj );
			}
		}
		
		private static function openHandler(event:Event):void {
			trace("openHandler: " + event);
		}
		
		private static function progressHandler(event:ProgressEvent):void {
			trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
		}
		
		private static function securityErrorHandler(event:SecurityErrorEvent):void {
			if( fault != null ){
				fault.call(null,event);
				fault = null ;
			}else{
				trace("securityErrorHandler: " + event);
			}
		}
		
		private static function httpStatusHandler(event:HTTPStatusEvent):void {
			//			trace("httpStatusHandler: " + event);
		}
		
		private static function ioErrorHandler(event:IOErrorEvent):void {
			if( fault != null ){
				fault.call(null,event);
				fault = null ;
			}else{
				trace("ioErrorHandler: " + event);
			}
		}	
		
		
	}
}