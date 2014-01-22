package tools.modules.playerequip
{
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import tools.events.PipeEvent;
	import tools.managers.PipeManager;
	import tools.modules.playerequip.controller.PlayerEquip_StartupCommand;
	import tools.modules.playerequip.view.PlayerEquip_PlayerEquipMediator;
	import tools.observer.Notification;

	public class PlayerEquip_ApplicationFacade extends Facade
	{

		public static const NAME:String = "tools.modules.playerequip.PlayerEquip_ApplicationFacade";
		public static const STARTUP:String = "STARTUP";
		public static const SHOW_MAINUI:String = "SHOW_MAINUI";
		public static const CLOSE_MAINUI:String = "CLOSE_MAINUI";
		public static const RESE_EQUIP:String = "RESE_EQUIP";

		public function PlayerEquip_ApplicationFacade(param1:String)
		{
			super(param1);
			registerEvents();
			PipeManager.registerMsgs([PipeEvent.STARTUP_CHARGE,PipeEvent.SHOW_PLAYER_EQUIP_MAINUI], this.handlePipeMessage, PlayerEquip_ApplicationFacade);
			return;
		}
		
		private function registerEvents():void
		{
			PipeManager.registerMsgs([], this.handlePipeMessage, PlayerEquip_ApplicationFacade);
			return;
		}
		private function removeEvents():void
		{
			PipeManager.removeMsgs([], PlayerEquip_ApplicationFacade);
		}

		override protected function initializeController() : void
		{
			super.initializeController();
			registerCommand(STARTUP, PlayerEquip_StartupCommand);
			return;
		}
		
		private function handlePipeMessage(param1:Notification) : void
		{
			var _loc_2:Object = null;
			var _loc_3:Boolean = false;
			_loc_2 = param1.body;
			switch(param1.name)
			{
				case PipeEvent.STARTUP_CHARGE:
				{
					startup();
					break;
				}
				case PipeEvent.SHOW_PLAYER_EQUIP_MAINUI:
				{
					this.sendNotification(SHOW_MAINUI,_loc_2);
					break;
				}
				default:
				{
					break;
				}
			}
		}

		private function startup() : void
		{
			sendNotification(STARTUP);
			instanceStartMap[NAME] = true;
			return;
		}

		public static function getInstance() : PlayerEquip_ApplicationFacade
		{
			if (instanceMap[NAME] == null)
			{
				instanceMap[NAME] = new PlayerEquip_ApplicationFacade(NAME);
			}
			return instanceMap[NAME] as PlayerEquip_ApplicationFacade;
		}
		
		public function dispose():void
		{
			removeEvents();
			var mediator:PlayerEquip_PlayerEquipMediator = this.retrieveMediator(PlayerEquip_PlayerEquipMediator.NAME) as PlayerEquip_PlayerEquipMediator;
			var ui:DisplayObject = mediator.getViewComponent() as DisplayObject;
			if (ui && ui.parent)
			{
				//POPWindowManager.removeSmallWindow(ui, NAME);
			}
		}
	}
}