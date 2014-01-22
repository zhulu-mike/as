package tools.modules.playerequip
{
	import flash.display.Sprite;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class PlayerEquipModule extends Sprite
	{

		public function PlayerEquipModule()
		{
			trace(PlayerEquip_ApplicationFacade.NAME);
			if (!Facade.hasCore(PlayerEquip_ApplicationFacade.NAME))
				new PlayerEquip_ApplicationFacade(PlayerEquip_ApplicationFacade.NAME);
		}
	}
}