package utils
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import global.GlobalConfig;

	public class FormatUtil
	{
		public function FormatUtil()
		{
			if (_instance != null)
			{
				throw "FormatUtil 为单例";
			}
		}
		
		private  var count:int;
		private  var index:int = 0;
		private  var list:XMLList;
		private  var com:Boolean = false;
		private  var newXml:XML;
		private static var _file:File ;
		private  var fileSream:FileStream = new FileStream();
		private static var FILEFILTERS:Array = [new FileFilter("xml","*.xml")];
		
		private static var _instance:FormatUtil ;
		
		
		public static function getInstace():FormatUtil{
			if( _instance == null ){
				_instance = new FormatUtil();
			}
			return _instance ;
		}
		private var delReg:RegExp = /(\\)+/g;
		
		public function format($file:File):void{
			_file = $file ;
			fileSream.open($file, FileMode.READ);
			var byte:XML;
			var str:String = fileSream.readUTFBytes(fileSream.bytesAvailable);
			fileSream.close();
			str = str.replace(delReg, '/');
			byte = new XML(str);
			transformXML(byte);
		}
		
		/**解析文件*/
		public function transformXML(xml:XML):void
		{
			count = 0;
			index = 0;
			com = false;
			GlobalConfig.instance.versionDic = {} ;
			newXml = new XML("<data></data>");
			var temp:XMLList = xml.child("target");
			if (temp.length() > 0)
			{
				list = temp[0].child("entry");
				if (list.length() > 0)
				{
					count = list.length();
					parse();
					return;
				}
			}
			completeAndSaveFile();
		}
		
		private  function parse():void
		{
			var time:int = getTimer();
			var res:XML, tar:XML, wc:XML, path:String = "", pointIndex:int, ext:String;
			var str:String;
			for (;index<count;index++)
			{
				if (getTimer() - time >= 30)
				{
//					parse();
					setTimeout(parse,1);
					return;
				}else{
					res = list[index];
					wc = res.child("wc-status")[0];
//					if (wc.@props == "normal")  //还有其他内容需要，如 modified
//					if (String(wc.@item) != "unversioned" && String(wc.@item) != "none")
					if (String(wc.@item)!= "unversioned")
					{
						path = res.@path;
						pointIndex = path.lastIndexOf(".");
						str = res.@path;
						GlobalConfig.instance.versionDic[str] = String(wc.child("commit")[0].@revision);
						trace(str);
						if (pointIndex >= 0)
						{
							ext = path.substring(pointIndex+1);
							if (ext == "jpg" || ext == "png" || ext == "gif" || ext == "db" || ext == "fla")
							{
								continue;
							}
						}
						tar = new XML("<p/>");
						tar.@path = str ;
						tar.@version = wc.child("commit")[0].@revision;
						newXml.appendChild(tar);
					}
				}
			}
			completeAndSaveFile();
		}
		/**
		 *  这里保存的文件不重要了。
		 * 
		 */		
		private function completeAndSaveFile():void
		{
			com = true;
			var name:String = "new_"+_file.name;
			_file = _file.parent;
			_file = _file.resolvePath(name);
			fileSream.open(_file, FileMode.WRITE);
			fileSream.writeUTFBytes(newXml.toString());
			fileSream.close();
		}
	}
}