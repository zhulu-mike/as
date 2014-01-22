package utils
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import nochump.util.zip.Deflater;
	
	import setting.Hostory;
	/**
	 * 需要修改，这里可以改为使用单例 
	 * @author Administrator
	 * 
	 */
	public class CompressUtil
	{
		public function CompressUtil()
		{
			if (_instance != null)
			{
				throw "CompressUtil 为单例";
			}
		}
		private static var _instance:CompressUtil ;
		
		public static function getInstace():CompressUtil{
			if( _instance == null ){
				_instance = new CompressUtil();
			}
			return _instance ;
		}
		
		public var dirUrl:String ;
		public var hostory:Hostory = null;
		
		
		public function readXML(file:File):void
		{
			if(file.isDirectory == true)
			{
				var folder:Array = file.getDirectoryListing();
				var num:int = folder.length;
				for(var i:int =0 ; i < num; i++)
				{
					readXML(folder[i]);
				}
			}
			else
			{
				if(file.extension == 'xml')
				{
					deflate(file);
				}
			}
		}
		private function deflate(file:File):void
		{
			if(file.isDirectory == true || file.extension != 'xml')
			{
				return;
			}
			
			var inputByte:ByteArray = readfileByByte(file);
			
			var deflater:Deflater = new Deflater();
			deflater.setInput(inputByte);
			
			var outputByte:ByteArray = new ByteArray();
			deflater.deflate(outputByte);
			
			saveFiles(outputByte,file.url);
		}
		
		private function readfileByByte(file:File):ByteArray
		{
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			var str:String = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();
			
			var inputByte:ByteArray = new ByteArray();
			inputByte.writeUTFBytes(str);
			inputByte.position = 0;
			return inputByte;
		}
		
		private function saveFiles(bytes:ByteArray, url:String):void
		{
			var targetUrl:String = hostory.compressExportPath == '' ? url : hostory.compressExportPath ;
			targetUrl = targetUrl.replace('.xml', '.thi');
			
			if(hostory.compressExportPath == '')
			{
				targetUrl = url.replace('.xml', '.thi');
			}
			else
			{
				var tempUrl:String = url.replace(dirUrl, '');
				targetUrl = hostory.compressExportPath + tempUrl;
				targetUrl = targetUrl.replace('.xml', '.thi');
			}
			
			var file:File = new File(targetUrl);
			
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(bytes);
			stream.close();
			trace(targetUrl);
		}
	}
}