package tools.modules.addserver
{
	import flash.display.Sprite;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class AddServerModule extends Sprite
	{

		public function AddServerModule()
		{
			trace(AddServer_ApplicationFacade.NAME);
			if (!Facade.hasCore(AddServer_ApplicationFacade.NAME))
				new AddServer_ApplicationFacade(AddServer_ApplicationFacade.NAME);
		}
	}
}