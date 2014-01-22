package tools.modules.application
{
	import flash.display.Sprite;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class ApplicationModule extends Sprite
	{

		public function ApplicationModule()
		{
			trace(Application_ApplicationFacade.NAME);
			if (!Facade.hasCore(Application_ApplicationFacade.NAME))
				new Application_ApplicationFacade(Application_ApplicationFacade.NAME);
		}
	}
}