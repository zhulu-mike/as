package tools.modules.chargecount
{
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import tools.events.PipeEvent;
	import tools.managers.PipeManager;
	import tools.modules.chargecount.controller.ChargeCount_StartupCommand;
	import tools.modules.chargecount.view.ChargeCount_ChargeCountMediator;
	import tools.observer.Notification;

	public class ChargeCount_ApplicationFacade extends Facade
	{

		public static const NAME:String = "tools.modules.chargecount.ChargeCount_ApplicationFacade";
		public static const STARTUP:String = "STARTUP";
		public static const SHOW_MAINUI:String = "SHOW_MAINUI";
		public static const CLOSE_MAINUI:String = "CLOSE_MAINUI";
		public static const CHECK_CHARGE_RESP:String = "CHECK_CHARGE_RESP";

		public function ChargeCount_ApplicationFacade(param1:String)
		{
			super(param1);
			registerEvents();
			PipeManager.registerMsgs([PipeEvent.STARTUP_CHARGE,PipeEvent.SHOW_CHARGE_COUNT], this.handlePipeMessage, ChargeCount_ApplicationFacade);
			return;
		}
		
		private function registerEvents():void
		{
			PipeManager.registerMsgs([], this.handlePipeMessage, ChargeCount_ApplicationFacade);
			return;
		}
		private function removeEvents():void
		{
			PipeManager.removeMsgs([], ChargeCount_ApplicationFacade);
		}

		override protected function initializeController() : void
		{
			super.initializeController();
			registerCommand(STARTUP, ChargeCount_StartupCommand);
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
				case PipeEvent.SHOW_CHARGE_COUNT:
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

		public static function getInstance() : ChargeCount_ApplicationFacade
		{
			if (instanceMap[NAME] == null)
			{
				instanceMap[NAME] = new ChargeCount_ApplicationFacade(NAME);
			}
			return instanceMap[NAME] as ChargeCount_ApplicationFacade;
		}
		
		public function dispose():void
		{
			removeEvents();
			var mediator:ChargeCount_ChargeCountMediator = this.retrieveMediator(ChargeCount_ChargeCountMediator.NAME) as ChargeCount_ChargeCountMediator;
			var ui:DisplayObject = mediator.getViewComponent() as DisplayObject;
			if (ui && ui.parent)
			{
				//POPWindowManager.removeSmallWindow(ui, NAME);
			}
		}
	}
}