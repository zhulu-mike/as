package tools.modules.vipcareer
{
	import flash.display.Sprite;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class VipCareerModule extends Sprite
	{

		public function VipCareerModule()
		{
			trace(VipCareer_ApplicationFacade.NAME);
			if (!Facade.hasCore(VipCareer_ApplicationFacade.NAME))
				new VipCareer_ApplicationFacade(VipCareer_ApplicationFacade.NAME);
		}
	}
}