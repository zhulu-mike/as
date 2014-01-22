package tools.modules.prop
{
	import flash.display.Sprite;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class PropModule extends Sprite
	{

		public function PropModule()
		{
			trace(Prop_ApplicationFacade.NAME);
			if (!Facade.hasCore(Prop_ApplicationFacade.NAME))
				new Prop_ApplicationFacade(Prop_ApplicationFacade.NAME);
		}
	}
}