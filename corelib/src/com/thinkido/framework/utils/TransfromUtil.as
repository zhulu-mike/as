package com.thinkido.framework.utils
{
	import flash.utils.ByteArray;

	/**
	 * JSON串中的中文字符编码 编码转换 
	 * @author thinkido
	 * */	
	public class TransfromUtil
	{
		public function TransfromUtil()
		{
		}
		
		public static function transfromUnicodeString(str:String):String
		{
			return str.replace(/\\\u([\dabcdef]{4})/ig,function():*{return String.fromCharCode(Number("0x"+arguments[1]))});
		}

		public static function transfromJsonString(str:String):String
		{
			var b:ByteArray=new ByteArray();
			b.writeMultiByte(str,"iso-8859-1");
			b.position=0;
			return b.readMultiByte(b.bytesAvailable,"utf-8");
		}
		/**
		 * 处理服务器端的json 字符串，并转换为能显示的utf8字符 
		 * @param str
		 * @return 可识别utf8字符串
		 */
		public static function transfrom2utf8(str:String):String{
			str =  transfromUnicodeString(str);
			str = transfromJsonString(str);
			return str ;
		}
	}
}
