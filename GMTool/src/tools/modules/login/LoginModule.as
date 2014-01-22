package tools.modules.login
{
	import flash.display.Sprite;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	/**
	 * 
	 * @author wangjianglin
	 * 
	 */	
	public class LoginModule extends Sprite
	{

		public function LoginModule()
		{
			if (!Facade.hasCore(Login_ApplicationFacade.NAME))
				new Login_ApplicationFacade(Login_ApplicationFacade.NAME);
		}
	}
}