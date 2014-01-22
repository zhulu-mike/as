package tools.modules.checkcard
{
	import flash.display.Sprite;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class CheckCardTypeModule extends Sprite
	{

		public function CheckCardTypeModule()
		{
			trace(CheckCardType_ApplicationFacade.NAME);
			if (!Facade.hasCore(CheckCardType_ApplicationFacade.NAME))
				new CheckCardType_ApplicationFacade(CheckCardType_ApplicationFacade.NAME);
		}
	}
}