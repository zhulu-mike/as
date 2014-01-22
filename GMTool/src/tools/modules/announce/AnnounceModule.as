package tools.modules.announce
{
	import flash.display.Sprite;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class AnnounceModule extends Sprite
	{

		public function AnnounceModule()
		{
			trace(Announce_ApplicationFacade.NAME);
			if (!Facade.hasCore(Announce_ApplicationFacade.NAME))
				new Announce_ApplicationFacade(Announce_ApplicationFacade.NAME);
		}
	}
}