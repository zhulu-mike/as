package tools.managers
{
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	public class ModuleManager
	{
		public function ModuleManager()
		{
		}
		
		/**
		 * 启动某个模块界面
		 * @param moduleName
		 * @param evts
		 * @param data
		 * 
		 */		
		public static function showModule(moduleName:String, evts:String="", data:Object=null):void
		{
			if (!Facade.instanceStartMap.hasOwnProperty(moduleName) || !Facade.instanceStartMap[moduleName])
			{
				PipeManager.sendMsg(moduleName);
			}
			PipeManager.sendMsg(evts, data);
		}
	}
}