package tools.modules.playerlevel
{
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import tools.events.PipeEvent;
	import tools.managers.PipeManager;
	import tools.modules.playerlevel.controller.PlayerLevel_StartupCommand;
	import tools.modules.playerlevel.view.PlayerLevel_PlayerLevelMediator;
	import tools.observer.Notification;

	public class PlayerLevel_ApplicationFacade extends Facade
	{

		public static const NAME:String = "tools.modules.playerlevel.PlayerLevel_ApplicationFacade";
		public static const STARTUP:String = "STARTUP";
		public static const SHOW_MAINUI:String = "SHOW_MAINUI";
		public static const CLOSE_MAINUI:String = "CLOSE_MAINUI";
		public static const LAST_LOGIN_RESP:String = "LAST_LOGIN_RESP";

		public function PlayerLevel_ApplicationFacade(param1:String)
		{
			super(param1);
			registerEvents();
			PipeManager.registerMsgs([PipeEvent.STARTUP_CHARGE,PipeEvent.SHOW_PLAYER_LEVEL_MAINUI], this.handlePipeMessage, PlayerLevel_ApplicationFacade);
			return;
		}
		
		private function registerEvents():void
		{
			PipeManager.registerMsgs([], this.handlePipeMessage, PlayerLevel_ApplicationFacade);
			return;
		}
		private function removeEvents():void
		{
			PipeManager.removeMsgs([], PlayerLevel_ApplicationFacade);
		}

		override protected function initializeController() : void
		{
			super.initializeController();
			registerCommand(STARTUP, PlayerLevel_StartupCommand);
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
				case PipeEvent.SHOW_PLAYER_LEVEL_MAINUI:
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

		public static function getInstance() : PlayerLevel_ApplicationFacade
		{
			if (instanceMap[NAME] == null)
			{
				instanceMap[NAME] = new PlayerLevel_ApplicationFacade(NAME);
			}
			return instanceMap[NAME] as PlayerLevel_ApplicationFacade;
		}
		
		public function dispose():void
		{
			removeEvents();
			var mediator:PlayerLevel_PlayerLevelMediator = this.retrieveMediator(PlayerLevel_PlayerLevelMediator.NAME) as PlayerLevel_PlayerLevelMediator;
			var ui:DisplayObject = mediator.getViewComponent() as DisplayObject;
			if (ui && ui.parent)
			{
				//POPWindowManager.removeSmallWindow(ui, NAME);
			}
		}
	}
}