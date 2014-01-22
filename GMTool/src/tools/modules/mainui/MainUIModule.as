package tools.modules.mainui
{
	import flash.display.Sprite;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	/**
	 * 
	 * @author wangjianglin
	 * 
	 */	
	public class MainUIModule extends Sprite
	{

		public function MainUIModule()
		{
			if (!Facade.hasCore(MainUI_ApplicationFacade.NAME))
				new MainUI_ApplicationFacade(MainUI_ApplicationFacade.NAME);
		}
	}
}