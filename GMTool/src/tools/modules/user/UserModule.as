package tools.modules.user
{
	import flash.display.Sprite;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class UserModule extends Sprite
	{

		public function UserModule()
		{
			trace(User_ApplicationFacade.NAME);
			if (!Facade.hasCore(User_ApplicationFacade.NAME))
				new User_ApplicationFacade(User_ApplicationFacade.NAME);
		}
	}
}