package tools.modules.chargerank
{
	import flash.display.Sprite;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class ChargeRankModule extends Sprite
	{

		public function ChargeRankModule()
		{
			trace(ChargeRank_ApplicationFacade.NAME);
			if (!Facade.hasCore(ChargeRank_ApplicationFacade.NAME))
				new ChargeRank_ApplicationFacade(ChargeRank_ApplicationFacade.NAME);
		}
	}
}