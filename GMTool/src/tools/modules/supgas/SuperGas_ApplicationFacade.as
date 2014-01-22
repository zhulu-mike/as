package tools.modules.supgas
{
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import tools.events.PipeEvent;
	import tools.managers.PipeManager;
	import tools.modules.supgas.controller.SuperGas_StartupCommand;
	import tools.modules.supgas.view.SuperGas_SuperGasMediator;
	import tools.observer.Notification;

	public class SuperGas_ApplicationFacade extends Facade
	{

		public static const NAME:String = "tools.modules.supgas.SuperGas_ApplicationFacade";
		public static const STARTUP:String = "STARTUP";
		public static const SHOW_MAINUI:String = "SHOW_MAINUI";
		public static const CLOSE_MAINUI:String = "CLOSE_MAINUI";
		public static const RESE_SUPER_GAS:String = "RESE_SUPER_GAS";

		public function SuperGas_ApplicationFacade(param1:String)
		{
			super(param1);
			registerEvents();
			PipeManager.registerMsgs([PipeEvent.STARTUP_CHARGE,PipeEvent.SHOW_SUPER_GAS_MAINUI], this.handlePipeMessage, SuperGas_ApplicationFacade);
			return;
		}
		
		private function registerEvents():void
		{
			PipeManager.registerMsgs([], this.handlePipeMessage, SuperGas_ApplicationFacade);
			return;
		}
		private function removeEvents():void
		{
			PipeManager.removeMsgs([], SuperGas_ApplicationFacade);
		}

		override protected function initializeController() : void
		{
			super.initializeController();
			registerCommand(STARTUP, SuperGas_StartupCommand);
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
				case PipeEvent.SHOW_SUPER_GAS_MAINUI:
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

		public static function getInstance() : SuperGas_ApplicationFacade
		{
			if (instanceMap[NAME] == null)
			{
				instanceMap[NAME] = new SuperGas_ApplicationFacade(NAME);
			}
			return instanceMap[NAME] as SuperGas_ApplicationFacade;
		}
		
		public function dispose():void
		{
			removeEvents();
			var mediator:SuperGas_SuperGasMediator = this.retrieveMediator(SuperGas_SuperGasMediator.NAME) as SuperGas_SuperGasMediator;
			var ui:DisplayObject = mediator.getViewComponent() as DisplayObject;
			if (ui && ui.parent)
			{
				//POPWindowManager.removeSmallWindow(ui, NAME);
			}
		}
	}
}