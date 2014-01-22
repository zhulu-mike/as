package tools.modules.passport
{
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import tools.events.PipeEvent;
	import tools.managers.PipeManager;
	import tools.modules.passport.controller.Passport_StartupCommand;
	import tools.modules.passport.view.Passport_PassportMediator;
	import tools.observer.Notification;

	public class Passport_ApplicationFacade extends Facade
	{

		public static const NAME:String = "tools.modules.passport.Passport_ApplicationFacade";
		public static const STARTUP:String = "STARTUP";
		public static const SHOW_MAINUI:String = "SHOW_MAINUI";
		public static const CLOSE_MAINUI:String = "CLOSE_MAINUI";
		public static const RESP_PASSPORT:String = "RESP_PASSPORT";
		public static const RESP_CREAT_PLAT:String = "RESP_CREAT_PLAT";
		public static const RESP_MANAGER_PERIMSS:String = "RESP_MANAGER_PERIMSS";
		public static const RESP_MANAGER_PSW:String = "RESP_MANAGER_PSW";
		public static const RESP_DELETE:String = "RESP_DELETE";
		public static const RESP_MODIFY_PLAT:String = "RESP_MODIFY_PLAT";
		public static const RESP_LOGIN:String = "RESP_LOGIN";

		public function Passport_ApplicationFacade(param1:String)
		{
			super(param1);
			registerEvents();
			PipeManager.registerMsgs([PipeEvent.STARTUP_CHARGE,PipeEvent.SHOW_PASSPORT_MAINUI], this.handlePipeMessage, Passport_ApplicationFacade);
			return;
		}
		
		private function registerEvents():void
		{
			PipeManager.registerMsgs([], this.handlePipeMessage, Passport_ApplicationFacade);
			return;
		}
		private function removeEvents():void
		{
			PipeManager.removeMsgs([], Passport_ApplicationFacade);
		}

		override protected function initializeController() : void
		{
			super.initializeController();
			registerCommand(STARTUP, Passport_StartupCommand);
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
				case PipeEvent.SHOW_PASSPORT_MAINUI:
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

		public static function getInstance() : Passport_ApplicationFacade
		{
			if (instanceMap[NAME] == null)
			{
				instanceMap[NAME] = new Passport_ApplicationFacade(NAME);
			}
			return instanceMap[NAME] as Passport_ApplicationFacade;
		}
		
		public function dispose():void
		{
			removeEvents();
			var mediator:Passport_PassportMediator = this.retrieveMediator(Passport_PassportMediator.NAME) as Passport_PassportMediator;
			var ui:DisplayObject = mediator.getViewComponent() as DisplayObject;
			if (ui && ui.parent)
			{
				//POPWindowManager.removeSmallWindow(ui, NAME);
			}
		}
	}
}