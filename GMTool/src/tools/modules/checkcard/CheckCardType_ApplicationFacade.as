package tools.modules.checkcard
{
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import tools.events.PipeEvent;
	import tools.managers.PipeManager;
	import tools.modules.checkcard.controller.CheckCardType_StartupCommand;
	import tools.modules.checkcard.view.CheckCardType_CheckCardTypeMediator;
	import tools.observer.Notification;

	public class CheckCardType_ApplicationFacade extends Facade
	{

		public static const NAME:String = "tools.modules.checkcard.CheckCardType_ApplicationFacade";
		public static const STARTUP:String = "STARTUP";
		public static const SHOW_MAINUI:String = "SHOW_MAINUI";
		public static const CLOSE_MAINUI:String = "CLOSE_MAINUI";
		public static const MAKE_NEWCARD_TYPE:String = "MAKE_NEWCARD_TYPE";
		public static const CHECK_NEWCARD_TYPE:String = "CHECK_NEWCARD_TYPE";

		public function CheckCardType_ApplicationFacade(param1:String)
		{
			super(param1);
			registerEvents();
			PipeManager.registerMsgs([PipeEvent.STARTUP_CHARGE,PipeEvent.SHOW_CHECK_CARD_MIANUI], this.handlePipeMessage, CheckCardType_ApplicationFacade);
			return;
		}
		
		private function registerEvents():void
		{
			PipeManager.registerMsgs([], this.handlePipeMessage, CheckCardType_ApplicationFacade);
			return;
		}
		private function removeEvents():void
		{
			PipeManager.removeMsgs([], CheckCardType_ApplicationFacade);
		}

		override protected function initializeController() : void
		{
			super.initializeController();
			registerCommand(STARTUP, CheckCardType_StartupCommand);
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
				case PipeEvent.SHOW_CHECK_CARD_MIANUI:
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

		public static function getInstance() : CheckCardType_ApplicationFacade
		{
			if (instanceMap[NAME] == null)
			{
				instanceMap[NAME] = new CheckCardType_ApplicationFacade(NAME);
			}
			return instanceMap[NAME] as CheckCardType_ApplicationFacade;
		}
		
		public function dispose():void
		{
			removeEvents();
			var mediator:CheckCardType_CheckCardTypeMediator = this.retrieveMediator(CheckCardType_CheckCardTypeMediator.NAME) as CheckCardType_CheckCardTypeMediator;
			var ui:DisplayObject = mediator.getViewComponent() as DisplayObject;
			if (ui && ui.parent)
			{
				//POPWindowManager.removeSmallWindow(ui, NAME);
			}
		}
	}
}