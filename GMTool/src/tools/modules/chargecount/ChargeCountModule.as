package tools.modules.chargecount
{
	import flash.display.Sprite;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class ChargeCountModule extends Sprite
	{

		public function ChargeCountModule()
		{
			trace(ChargeCount_ApplicationFacade.NAME);
			if (!Facade.hasCore(ChargeCount_ApplicationFacade.NAME))
				new ChargeCount_ApplicationFacade(ChargeCount_ApplicationFacade.NAME);
		}
	}
}