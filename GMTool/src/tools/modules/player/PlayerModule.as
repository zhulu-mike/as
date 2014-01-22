package tools.modules.player
{
	import flash.display.Sprite;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class PlayerModule extends Sprite
	{

		public function PlayerModule()
		{
			trace(Player_ApplicationFacade.NAME);
			if (!Facade.hasCore(Player_ApplicationFacade.NAME))
				new Player_ApplicationFacade(Player_ApplicationFacade.NAME);
		}
	}
}