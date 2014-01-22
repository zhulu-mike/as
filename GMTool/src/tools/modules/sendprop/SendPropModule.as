package tools.modules.sendprop
{
	import flash.display.Sprite;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class SendPropModule extends Sprite
	{

		public function SendPropModule()
		{
			trace(SendProp_ApplicationFacade.NAME);
			if (!Facade.hasCore(SendProp_ApplicationFacade.NAME))
				new SendProp_ApplicationFacade(SendProp_ApplicationFacade.NAME);
		}
	}
}