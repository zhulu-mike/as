package setting
{
	/**
	 * 历史记录 ,打开工具时使用上一次记录
	 */	
	[Bindable]
	public class Hostory
	{
		public var formatFilePath:String = "" ;
		public var versionFilePath:String = "" ;
		public var configFilePath:String = "" ;
		public var compressFilePath:String = "" ;
		public var compressExportPath:String = "" ;
		
		/**
		 * 包含这些后缀的文件 
		 * 白名单
		 */		
		public var typeFilters:Array = [];
		
		/**
		 * 包含这些路径字符的文件 
		 * 白名单
		 */		
		public var pathFilters:Array = [] ;
		
		public function Hostory()
		{
		}
	}
}