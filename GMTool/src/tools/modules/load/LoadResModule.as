package tools.modules.load
{
	import flash.display.Sprite;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class LoadResModule extends Sprite
	{

		public function LoadResModule()
		{
			trace(LoadRes_ApplicationFacade.NAME);
			if (!Facade.hasCore(LoadRes_ApplicationFacade.NAME))
				new LoadRes_ApplicationFacade(LoadRes_ApplicationFacade.NAME);
		}
	}
}