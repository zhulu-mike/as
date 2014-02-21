package
{
	import flash.filesystem.File;

	public class FileVO
	{
		public function FileVO()
		{
		}
		
		public var f:File;
		
		public var classes:Array;
		
		public var xml:XML;
		
		/**
		 * 资源名
		 */		
		public var name:String;
		
		/**
		 *动作系列
		 */		
		public var actions:Array = [];
		
		public var actionStr:String = "";
		
		
	}
}