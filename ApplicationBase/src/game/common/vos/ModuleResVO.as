package game.common.vos
{
	public class ModuleResVO
	{
		public function ModuleResVO()
		{
		}
		
		private var _fileArr:Array = [];
		private var _resArr:Array = []

		/**
		 * 模块需要加载的其他文件
		 * @return 
		 * 
		 */		
		public function get fileArr():Array
		{
			return _fileArr;
		}

		public function set fileArr(value:Array):void
		{
			_fileArr = value;
		}


		/**
		 * 模块需要加载的显示对象资源
		 * @return 
		 * 
		 */		
		public function get resArr():Array
		{
			return _resArr;
		}

		
		public function set resArr(value:Array):void
		{
			_resArr = value;
		}


	}
}