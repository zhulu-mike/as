package managers
{
	import flash.utils.ByteArray;

	public class DecodeUtil
	{
		public function DecodeUtil()
		{
			
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