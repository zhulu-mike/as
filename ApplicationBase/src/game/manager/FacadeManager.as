package game.manager
{
	import flash.utils.Dictionary;
	
	import org.osflash.thunderbolt.Logger;
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	public class FacadeManager
	{
		private static var _facadeDic:Dictionary = new Dictionary();
		
		public function FacadeManager()
		{
		}
		public static function startupFacade($facadeName:String, param2:Object = null) : void
		{
			var facade:IFacade = FacadeManager.getFacade($facadeName);
			
			if (facade == null)
			{
				ModuleManager.load($facadeName, param2);
			}else{
				PipeManager.sendMsg($facadeName, param2);
			}
			return;
		}
		
		public static function killFacade(param1:String) : void
		{
			var facade:IFacade = FacadeManager.getFacade(param1);
			if (facade != null)
			{
				(facade as Object).dispose();
			}
			return;
		}
		
		public static function getFacade($className:String, $Class:Class = null) : IFacade
		{
			return TempFacade.getFacade($className, $Class);
		}
		
		public static function hasFacade($className:String) : Boolean
		{
			return TempFacade.hasFacade($className) ;
		}
		
	}
}

import com.thinkido.framework.manager.RslLoaderManager;

import org.puremvc.as3.multicore.interfaces.*;
import org.puremvc.as3.multicore.patterns.facade.*;

class TempFacade extends Facade {
	
	public function TempFacade(_arg1:String){
		super(_arg1);
	}
	public static function getFacade($className:String, $Class:Class=null):IFacade{
		if (instanceMap[$className] == null){
			instanceMap[$className] = (($Class)!=null) ? new $Class($className) : RslLoaderManager.getInstance($className, $className);
		};
		return (instanceMap[$className]);
	}
	public static function hasFacade($className:String):Boolean{
		return (!((instanceMap[$className] == null)));
	}
	
}