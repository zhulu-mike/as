package tools.modules.useronline
{
	import flash.display.Sprite;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class UserOnlineModule extends Sprite
	{

		public function UserOnlineModule()
		{
			trace(UserOnline_ApplicationFacade.NAME);
			if (!Facade.hasCore(UserOnline_ApplicationFacade.NAME))
				new UserOnline_ApplicationFacade(UserOnline_ApplicationFacade.NAME);
		}
	}
}