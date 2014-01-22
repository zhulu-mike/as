package tools.modules.fightspirit
{
	import flash.display.Sprite;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class FightSpiritModule extends Sprite
	{

		public function FightSpiritModule()
		{
			trace(FightSpirit_ApplicationFacade.NAME);
			if (!Facade.hasCore(FightSpirit_ApplicationFacade.NAME))
				new FightSpirit_ApplicationFacade(FightSpirit_ApplicationFacade.NAME);
		}
	}
}