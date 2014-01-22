package tools.modules.player
{
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import tools.events.PipeEvent;
	import tools.managers.PipeManager;
	import tools.modules.player.controller.Player_StartupCommand;
	import tools.modules.player.view.Player_PlayerMediator;
	import tools.observer.Notification;

	public class Player_ApplicationFacade extends Facade
	{

		public static const NAME:String = "tools.modules.player.Player_ApplicationFacade";
		public static const STARTUP:String = "STARTUP";
		public static const SHOW_MAINUI:String = "SHOW_MAINUI";
		public static const CLOSE_MAINUI:String = "CLOSE_MAINUI";
		public static const RESEARCH:String = "RESEARCH";
		public static const PACKAGE_RESEARCH:String = "PACKAGE_RESEARCH";
		public static const SKILL_RESEARCH:String = "SKILL_RESEARCH";
		public static const FORBID_PASSPOET:String = "FORBID_PASSPOET";
		public static const UNFORBID_PASSPOET:String = "UNFORBID_PASSPOET";
		public static const CREAT_ANNOUNCE:String = "CREAT_ANNOUNCE";
		public static const CLICK_PEOPLE:String = "CLICK_PEOPLE";
		public static const NO_PRESSION_CLICK_PEOPLE:String = "NO_PRESSION_CLICK_PEOPLE";
		public static const FORBID_SPEAK:String = "FORBID_SPEAK";

		public function Player_ApplicationFacade(param1:String)
		{
			super(param1);
			registerEvents();
			PipeManager.registerMsgs([PipeEvent.STARTUP_CHARGE,PipeEvent.SHOW_PLAYER_MAINUI], this.handlePipeMessage, Player_ApplicationFacade);
			return;
		}
		
		private function registerEvents():void
		{
			PipeManager.registerMsgs([], this.handlePipeMessage, Player_ApplicationFacade);
			return;
		}
		private function removeEvents():void
		{
			PipeManager.removeMsgs([], Player_ApplicationFacade);
		}

		override protected function initializeController() : void
		{
			super.initializeController();
			registerCommand(STARTUP, Player_StartupCommand);
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
				case PipeEvent.SHOW_PLAYER_MAINUI:
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

		public static function getInstance() : Player_ApplicationFacade
		{
			if (instanceMap[NAME] == null)
			{
				instanceMap[NAME] = new Player_ApplicationFacade(NAME);
			}
			return instanceMap[NAME] as Player_ApplicationFacade;
		}
		
		public function dispose():void
		{
			removeEvents();
			var mediator:Player_PlayerMediator = this.retrieveMediator(Player_PlayerMediator.NAME) as Player_PlayerMediator;
			var ui:DisplayObject = mediator.getViewComponent() as DisplayObject;
			if (ui && ui.parent)
			{
				//POPWindowManager.removeSmallWindow(ui, NAME);
			}
		}
	}
}