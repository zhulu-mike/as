package managers
{
	import infos.data.LocalSO;

	public class SharedObjectManager
	{
		public function SharedObjectManager()
		{
		}
		
		private static var soConfig:String = "soconfig";
		
		public static var baseHttpUrl:String = "";
		
		/**
		 * 根据资源URL和版本号获取SO中的资源，SO的name为url文件目录，保存格式为{value:xxxx, version:2222},version为资源对应版本号
		 * 如果SO没有value，则返回null;如果SO版本号不一致，则返回null并且删除旧数据。
		 * @param url 目录结构，不包含域名。res/swf/xxx.swf
		 * @param deaultKey
		 * @param version
		 * @return 
		 * @see #setDataWithUrl()
		 */		
		public static function getDataWithUrl(url:String, version:int=0, deaultKey:String="value"):Object
		{
			var so:LocalSO = new LocalSO(url);
			if (!so.hasKey(deaultKey))
				return null;
			if (int(so.getAt("version")) != version)
			{
				so.setAt(deaultKey, null);
				return null;
			}
			return so.getAt(deaultKey);
		}
		
		/**
		 * 保存数据到SO中
		 * @param 目录结构，不包含域名。res/swf/xxx.swf
		 * @param value
		 * @param deaultKey
		 * @param version
		 * @see #getDataWithUrl()
		 */		
		public static function setDataWithUrl(url:String, value:Object, version:int=0, deaultKey:String="value"):void
		{
			var so:LocalSO = new LocalSO(url);
			so.setAt(deaultKey, value);
			so.setAt("version", version);
			addSOInfo(url);
		}
		
		/**
		 * 
		 * @param url
		 * 
		 */		
		public static function clearSO(url:String):void
		{
			var so:LocalSO = new LocalSO(url);
			so.clear();
		}
		
		/**
		 * 拆分HTTPURL，需要先设置baseHttpUrl
		 * @param httpUrl
		 * @return array [sourl,version]
		 */		
		public static function splitHttpUrl(httpUrl:String):Array
		{
			var arr:Array = httpUrl.split("?");
			var ret:Array = [];
			var url:String = arr[0];
			if (url.length <= baseHttpUrl.length)
			{
				return ret;
			}
			var yanzheng:String = url.substr(0, baseHttpUrl.length);
			if (yanzheng != baseHttpUrl)
				return ret;
			var soUrl:String = url.substr(baseHttpUrl.length);
			ret.push(soUrl);
			if (arr.length > 1)
			{
				ret.push(int(arr[1]));
			}else{
				ret.push(0);
			}
			return ret;
		}
		
		/**
		 * 根据HTTP完整路径直接获取资源数据 
		 * @param url
		 * @return 
		 * 
		 */		
		public static function getDataByHttpUrl(url:String):Object
		{
			var soParam:Array = splitHttpUrl(url);
			var bytes:Object;
			if (soParam.length > 0)
			{
				bytes = getDataWithUrl(soParam[0], soParam[1]);
			}
			return bytes;
		}
		
		/**
		 * 根据HTTP完整路径直接保存资源数据  
		 * @param url
		 * @param value
		 * 
		 */		
		public static function setDataByHttpUrl(url:String, value:Object):void
		{
			var soParam:Array = splitHttpUrl(url);
			if (soParam.length > 0)
			{
				setDataWithUrl(soParam[0], value, soParam[1]);
			}
		}
		
		public static function showSettings():void
		{
			var so:LocalSO = new LocalSO("xxx");
			so.flush(1024*1024*20);
		}
		
		/**
		 * 清除所有的缓存
		 * 
		 */		
		public static function clearAllSO():void
		{
			var so:LocalSO = new LocalSO(soConfig);
			var data:Object = so.data;
			var key:String;
			for (key in data)
			{
				clearSO(key);
			}
			so.clear();
		}
		
		private static function addSOInfo(url:String):void
		{
			var so:LocalSO = new LocalSO(soConfig);
			var data:Object = so.data;
			if (data.hasOwnProperty(url))
				return;
			so.setAt(url,1);
		}
	}
}