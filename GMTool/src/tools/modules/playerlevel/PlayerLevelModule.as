package tools.modules.playerlevel
{
	import flash.display.Sprite;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class PlayerLevelModule extends Sprite
	{

		public function PlayerLevelModule()
		{
			trace(PlayerLevel_ApplicationFacade.NAME);
			if (!Facade.hasCore(PlayerLevel_ApplicationFacade.NAME))
				new PlayerLevel_ApplicationFacade(PlayerLevel_ApplicationFacade.NAME);
		}
	}
}