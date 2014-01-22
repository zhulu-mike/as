package tools.modules.consum
{
	import flash.display.Sprite;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class ConsumModule extends Sprite
	{

		public function ConsumModule()
		{
			trace(Consum_ApplicationFacade.NAME);
			if (!Facade.hasCore(Consum_ApplicationFacade.NAME))
				new Consum_ApplicationFacade(Consum_ApplicationFacade.NAME);
		}
	}
}