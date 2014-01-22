package utils
{
	
	import com.thinkido.framework.air.FileUtils;
	
	import flash.filesystem.File;
	
	import global.GlobalConfig;

	public class ChangeFileUtil
	{
		public function ChangeFileUtil()
		{
			if (_instance != null)
			{
				throw "ChangeFileUtil 为单例";
			}
		}
		private static var _instance:ChangeFileUtil;
		
		public static function get instance() : ChangeFileUtil
		{
			if (_instance == null)
			{
				_instance = new ChangeFileUtil;
			}
			return _instance;
		}
		
		/**
		 *改变 config.xml 文件
		 */		
		public function changeConfig():void{
			var filePath:String = GlobalConfig.instance.hostory.configFilePath ;
			var _file:File = new File(filePath) ;
			if( !_file.exists ){
				return ;
			}
			var str:String = FileUtils.getStringByFile(_file) ;
			var _xml:XML = new XML(str) ;
			var path:String = "" ;
			var path1:String = "" ;
			var index:int  = 0 ;
			var _ver:String  ;
			var has:Boolean =false ;
			var ver:Object = GlobalConfig.instance.versionDic;
			
			
			for each(var item:XML in _xml.children() ) {
				if( !item.hasComplexContent() ){
					changeVer(item);
				}else{
					for each(var item1:* in item.children()) 
					{
						changeVer(item1);
					}
				}
			}
			var content:String = _xml.toString() ;
			FileUtils.saveStr(filePath,content);
		}
		
		private function changeVer(item:*):void{
			var path:String = "" ;
			var path1:String = "" ;
			var index:int  = 0 ;
			var _ver:String  ;
			var has:Boolean = false ;
			var ver:Object = GlobalConfig.instance.versionDic;
			path = String(item.@url) ;
			has = path.indexOf("$") > -1 ;
			path1 = path.replace("$","") ;
			index = path1.indexOf("?") != -1 ? path1.indexOf("?") : path1.length ;
			path1 = path1.substr(0,index);
			_ver = ver[path1] as String;
			if( _ver ){
				item.@url = (has?"$":"") + path1 + "?"+ _ver ;
			}
		}
		
		/**
		 *改变resversion.xml 文件 
		 */		
		public function changeResversion():void{
			var filePath:String = GlobalConfig.instance.hostory.versionFilePath ;
			var _file:File = new File(filePath) ;
			if( !_file.exists ){
				return ;
			}
			var str:String = FileUtils.getStringByFile(_file) ;
			var _xml:XML = new XML("<data></data>");
			var _p:XML ;
			var type:String = "" ;
			var ver:Object = GlobalConfig.instance.versionDic;
			
			var typeFilter:Array = GlobalConfig.instance.hostory.typeFilters ;
			var pathFilter:Array = GlobalConfig.instance.hostory.pathFilters ;
			
			for (var path:String in ver) 
			{
				type = path.substring(path.indexOf(".") +1);
				if( typeFilter.indexOf(type) != -1 ){
					for (var i:int = 0; i < pathFilter.length; i++) 
					{
						if( path.indexOf(pathFilter[i]) != -1 ){
							_p = new XML("<p/>");
							_p.@path = path ;
							_p.@version = ver[path] ;
							_xml.appendChild(_p);
						}
					}
				}
			}
			var content:String = _xml.toString() ;
			FileUtils.saveStr(filePath,content);
		}
	}
}