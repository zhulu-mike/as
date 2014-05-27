package com.thinkido.framework.engine.utils
{
	import flash.utils.ByteArray;
	
	import nochump.util.zip.Inflater;

	public class DecodeUtil
	{
		public function DecodeUtil()
		{
			
		}
		
		/**
		 *	.thi解压为.xml文本	 
		 * @param byte
		 * @return 
		 * 
		 */		
		public static function txtUncompress(byte:ByteArray):String
		{
			if(!byte.bytesAvailable)
			{
				return null;
			}
			var inflate:Inflater = new Inflater();
			inflate.setInput(byte);
			
			var targetByte:ByteArray = new ByteArray();
			inflate.inflate(targetByte);
			
			targetByte.position = 0;
			var str:String = targetByte.readUTFBytes(targetByte.bytesAvailable);
			
			return str;
		}
		
		/**
		 * 对byte做异或运算 
		 * @param byte
		 * @param startIndex
		 * @param endIndex
		 * 
		 */		
		public static function ByteArrayArichmeticXOR(byte:ByteArray, startIndex:int = 0, endIndex:int = int.MAX_VALUE):void
		{
			var key:ByteArray = getKey();
			var len:int = endIndex > byte.length ? byte.length : endIndex;
			var keyLen:int = key.length;
			for(var i:int = startIndex; i < len; i++)
			{
				byte[i] ^= key[(i - startIndex) % keyLen];
			}
		}
		
		private static var key:ByteArray;
		
		private static function getKey():ByteArray
		{
			if(key == null)
			{
				var keyStr:String = '9595354db3ea8f30ae8e8e4ffd606d3d';
				var byte:ByteArray = new ByteArray;
				byte.writeUTFBytes(keyStr);
				key = byte;
			}
			return key;
		}
	}
}