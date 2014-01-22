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
	}
}