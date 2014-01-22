package vo
{
	import flash.utils.ByteArray;

	public class ActionVO
	{
		
		/**
		 * 动作VO
		 */
		public function ActionVO()
		{
		}
		
		public var tempArr:Array = [];
		
		public var bitmapByte:ByteArray = new ByteArray();
		
		public var bitAlphaByte:ByteArray = new ByteArray();
		
		public var width:Number = 0;//
		
		public var height:Number = 0;
		
		public var name:String = "";
	}
}