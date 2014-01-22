package tools.modules.newplayercard
{
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import tools.events.PipeEvent;
	import tools.managers.PipeManager;
	import tools.modules.newplayercard.controller.PlayerCard_StartupCommand;
	import tools.modules.newplayercard.view.PlayerCard_PlayerCardMediator;
	import tools.observer.Notification;

	public class PlayerCard_ApplicationFacade extends Facade
	{

		public static const NAME:String = "tools.modules.newplayercard.PlayerCard_ApplicationFacade";
		public static const STARTUP:String = "STARTUP";
		public static const SHOW_MAINUI:String = "SHOW_MAINUI";
		public static const CLOSE_MAINUI:String = "CLOSE_MAINUI";
		public static const CHECK_NEWCARD_TYPE:String = "CHECK_NEWCARD_TYPE";
		public static const MAKE_CARD_NUM:String = "MAKE_CARD_NUM";
		public static const RESP_CHECK_INFO:String = "RESP_CHECK_INFO";

		public function PlayerCard_ApplicationFacade(param1:String)
		{
			super(param1);
			registerEvents();
			PipeManager.registerMsgs([PipeEvent.STARTUP_CHARGE,PipeEvent.SHOW_PLAYER_CARD_MAINUI], this.handlePipeMessage, PlayerCard_ApplicationFacade);
			return;
		}
		
		private function registerEvents():void
		{
			PipeManager.registerMsgs([], this.handlePipeMessage, PlayerCard_ApplicationFacade);
			return;
		}
		private function removeEvents():void
		{
			PipeManager.removeMsgs([], PlayerCard_ApplicationFacade);
		}

		override protected function initializeController() : void
		{
			super.initializeController();
			registerCommand(STARTUP, PlayerCard_StartupCommand);
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
				case PipeEvent.SHOW_PLAYER_CARD_MAINUI:
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

		public static function getInstance() : PlayerCard_ApplicationFacade
		{
			if (instanceMap[NAME] == null)
			{
				instanceMap[NAME] = new PlayerCard_ApplicationFacade(NAME);
			}
			return instanceMap[NAME] as PlayerCard_ApplicationFacade;
		}
		
		public function dispose():void
		{
			removeEvents();
			var mediator:PlayerCard_PlayerCardMediator = this.retrieveMediator(PlayerCard_PlayerCardMediator.NAME) as PlayerCard_PlayerCardMediator;
			var ui:DisplayObject = mediator.getViewComponent() as DisplayObject;
			if (ui && ui.parent)
			{
				//POPWindowManager.removeSmallWindow(ui, NAME);
			}
		}
	}
}