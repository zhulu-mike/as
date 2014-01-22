package tools.modules.charge
{
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import tools.events.PipeEvent;
	import tools.managers.PipeManager;
	import tools.modules.charge.controller.Charge_StartupCommand;
	import tools.modules.charge.view.Charge_ChargeMediator;
	import tools.observer.Notification;

	public class Charge_ApplicationFacade extends Facade
	{

		public static const NAME:String = "tools.modules.charge.Charge_ApplicationFacade";
		public static const STARTUP:String = "STARTUP";
		public static const SHOW_MAINUI:String = "SHOW_MAINUI";
		public static const CLOSE_MAINUI:String = "CLOSE_MAINUI";
		public static const RESP_CHARGE_NUMBER:String = "RESP_CHARGE_NUMBER";

		public function Charge_ApplicationFacade(param1:String)
		{
			super(param1);
			registerEvents();
			PipeManager.registerMsgs([], this.handlePipeMessage, Charge_ApplicationFacade);//
			return;
		}
		
		private function registerEvents():void
		{
			PipeManager.registerMsgs([PipeEvent.STARTUP_CHARGE, PipeEvent.SHOW_CHARGE_MAINUI], this.handlePipeMessage, Charge_ApplicationFacade);//
			return;
		}
		private function removeEvents():void
		{
			PipeManager.removeMsgs([PipeEvent.STARTUP_CHARGE, PipeEvent.SHOW_CHARGE_MAINUI], Charge_ApplicationFacade);//
		}

		override protected function initializeController() : void
		{
			super.initializeController();
			registerCommand(STARTUP, Charge_StartupCommand);
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
					startup();
					break;
				case PipeEvent.SHOW_CHARGE_MAINUI:
					sendNotification(SHOW_MAINUI, _loc_2);
					break;
			}
		}

		private function startup() : void
		{
			sendNotification(STARTUP);
			instanceStartMap[NAME] = true;
			return;
		}

		public static function getInstance() : Charge_ApplicationFacade
		{
			if (instanceMap[NAME] == null)
			{
				instanceMap[NAME] = new Charge_ApplicationFacade(NAME);
			}
			return instanceMap[NAME] as Charge_ApplicationFacade;
		}
		
		public function dispose():void
		{
			removeEvents();
			var mediator:Charge_ChargeMediator = this.retrieveMediator(Charge_ChargeMediator.NAME) as Charge_ChargeMediator;
			var ui:DisplayObject = mediator.getViewComponent() as DisplayObject;
			if (ui && ui.parent)
			{
//				POPWindowManager.removeSmallWindow(ui, NAME);
			}
		}
	}
}