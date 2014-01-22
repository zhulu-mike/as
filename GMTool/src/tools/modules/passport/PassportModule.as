package tools.modules.passport
{
	import flash.display.Sprite;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class PassportModule extends Sprite
	{

		public function PassportModule()
		{
			trace(Passport_ApplicationFacade.NAME);
			if (!Facade.hasCore(Passport_ApplicationFacade.NAME))
				new Passport_ApplicationFacade(Passport_ApplicationFacade.NAME);
		}
	}
}