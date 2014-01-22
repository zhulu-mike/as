package tools.modules.supgas
{
	import flash.display.Sprite;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class SuperGasModule extends Sprite
	{

		public function SuperGasModule()
		{
			trace(SuperGas_ApplicationFacade.NAME);
			if (!Facade.hasCore(SuperGas_ApplicationFacade.NAME))
				new SuperGas_ApplicationFacade(SuperGas_ApplicationFacade.NAME);
		}
	}
}