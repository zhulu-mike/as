package tools.modules.newplayercard
{
	import flash.display.Sprite;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class PlayerCardModule extends Sprite
	{

		public function PlayerCardModule()
		{
			trace(PlayerCard_ApplicationFacade.NAME);
			if (!Facade.hasCore(PlayerCard_ApplicationFacade.NAME))
				new PlayerCard_ApplicationFacade(PlayerCard_ApplicationFacade.NAME);
		}
	}
}