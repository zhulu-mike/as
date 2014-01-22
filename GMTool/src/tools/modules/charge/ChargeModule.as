package tools.modules.charge
{
	import flash.display.Sprite;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	/**充值*/	
	public class ChargeModule extends Sprite
	{

		
		public function ChargeModule()
		{
			trace(Charge_ApplicationFacade.NAME);
			if (!Facade.hasCore(Charge_ApplicationFacade.NAME))
				new Charge_ApplicationFacade(Charge_ApplicationFacade.NAME);
		}
	}
}