package com.thinkido.framework.air
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class FileUtils
	{
		public function FileUtils()
		{
		}
		
		public static function saveStr($fileName:String,content:String):Boolean{
			if(content){
				var file:File = new File($fileName);
				var fs:FileStream = new FileStream();
				fs.open(file, FileMode.WRITE );
				fs.writeUTFBytes(content);
				fs.close();
				return true;
			}
			return false ;
		}
		
		public static function save($fileName:String ,$by:ByteArray):File{
			if($by == null || $by.length == 0){
				return null;
			}
			$by.position = 0 ;
			var file:File = new File($fileName);
			var fs:FileStream = new FileStream();
//			fs.endian = Endian.LITTLE_ENDIAN ;
			fs.open(file, FileMode.WRITE );
			fs.writeBytes( $by,0,$by.length );
			fs.close();
			return file ;
		}
		public static function getContentByFile(file:File):ByteArray{
			var fs:FileStream = new FileStream();
			var by:ByteArray ;
			fs.open(file, FileMode.READ);
			by = new ByteArray();
//			by.endian = Endian.LITTLE_ENDIAN ;
			fs.readBytes(by,0,fs.bytesAvailable) ;
			fs.close();
			return by ;
		}
		public static function getStringByFile(file:File):String{
			var fs:FileStream = new FileStream();
			var by:ByteArray ;
			fs.open(file, FileMode.READ);
			by = new ByteArray();
//			by.endian = Endian.LITTLE_ENDIAN ;
			fs.readBytes(by,0,fs.bytesAvailable) ;
			fs.close();
			by.position = 0;
			return by.readUTFBytes(by.length); ;
		}
		public static function getContentByFileName(fileName:String):ByteArray{
			var _file:File = new File(fileName);
			if(!_file.exists){
				return null ;
			}
			return getContentByFile(_file);
		}
		
		public static function isExist($name:String):Boolean{
			var _file:File = new File($name);
			return _file.exists ;
		}
	}
}