package tools.modules.equip
{
	import flash.display.Sprite;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class EquipManagerModule extends Sprite
	{

		public function EquipManagerModule()
		{
			trace(EquipManager_ApplicationFacade.NAME);
			if (!Facade.hasCore(EquipManager_ApplicationFacade.NAME))
				new EquipManager_ApplicationFacade(EquipManager_ApplicationFacade.NAME);
		}
	}
}