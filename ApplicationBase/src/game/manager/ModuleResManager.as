package game.manager
{
	import flash.utils.Dictionary;
	
	import game.common.vos.ModuleResVO;

	public class ModuleResManager
	{
		public function ModuleResManager()
		{
		}
		
		/**
		 * 记录已经加载过的文件
		 */		
		public static var loadedRecord:Object = {};
		private static var _modules:Dictionary = new Dictionary();
		
		/***/
		public static function parseXML(data:XML):void
		{
			var childs:XMLList = data.module;
			var tempVO:ModuleResVO, file:XMLList, c:XML;
			for each (var child:XML in childs)
			{
				tempVO = new ModuleResVO();
				file = child.child("res");
				for each (c in file)
				{
					tempVO.resArr.push({key:c.@key, url:c.@url});
				}
				file = child.child("file");
				for each (c in file)
				{
					tempVO.fileArr.push({key:c.@key, url:c.@url});
				}
				_modules[String(child.@name)] = tempVO;
			}
		}
		
		/***/
		public static function getModuleVO(name:String):ModuleResVO
		{
			return _modules.hasOwnProperty(name) ? _modules[name] : null;
		}
		
		/***/
		public static function parseModuleData(data:*, key:String):void
		{
			switch (key)
			{
				
				
				
			}
		}



	}
}