package game.manager
{
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import game.config.GameConfig;
	

	/**
	 * 版本管理
	 * @author wangjianglin
	 * 使用办法
	 * 用path作关键字，比如assets/swf/1.swf
	 * 调用getVersionWithPath接口获取版本号
	 * 然后调用getUrlWithVersion接口连接版本号和path得到一个新的url
	 * 此url加上GameConfig.fileBaseFolder就是最终的地址
	 * 下面描写导出资源的XML表的流程：
	 * 首先打开windows控制台cmd。
	 * 进入资源所在的目录，比如我的项目资源所在路径为E:\zxj4\code\client\NewGame\resService。
	 * 保存以下3行内容为bat文件运行即可生成version.xml
	cd E:\newGame\code\client\NewGame\resService
	e:
	svn status game -v --xml >> version.xml
	 * 下面我要对改目录下的game文件夹里面的资源进行版本导出
	 * 输入以下命令:  以下一行命令和上面bat 内容重复，
	 * svn status game -v --xml >> version.xml
	 * 其中game是路径名。version.xml是要生成的xml文件名，可以随便取
	 * 那么你可以再你的resService目录下看到version.xml文件了。打开这个文件，里面是许多的entry记录。
	 * 由于这个XML里面很多数据是多余的，不便使用。所以我们还要进行一些处理。
	 * 然后打开air工具VersionXMLTool，点击浏览按钮，选择version.xml，最后会生成一个new_version.xml文件。
	 * 这个文件就是我们最终要的文件。
	 */	
	public class VersionManager
	{
		
		public function VersionManager()
		{
		}
		
		private static var dic:Dictionary = new Dictionary();
		
		/**
		 * 生成最终的URL地址
		 * @param url 基本URL地址
		 * @param version 版本号
		 * @return url+"?"+version
		 * 
		 */		
		public static function getUrlWithVersion(url:String, version:String):String
		{
			if( url.indexOf("?") != -1 ){
				return url ;
			}
			if (version == "")
				return url;
			if (GameConfig.isDebug)
				return url+"?"+version + getTimer().toString();
			else
				return url+"?"+version;
		}
		
		
		public static function parseXML(xml:XML):void
		{
			var temp:XML, vo:Object, str:String;
			var list:XMLList = xml.child("p");
			for each (temp in list)
			{
				vo = {};
				vo.path = String(temp.@path) ;
				vo.version = String(temp.@version);
				dic[vo.path] = vo.version;
			}
		}
		
		
		/***/
		public static function getVersionWithPath(path:String):String
		{
			return dic.hasOwnProperty(path) ? dic[path] : "";
		}
		
		/***/
		public static function getUrlWithPath(path:String):String
		{
			return getUrlWithVersion(path, getVersionWithPath(path));
		}
	}
}