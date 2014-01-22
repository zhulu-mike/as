package tools.modules.user
{
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import tools.events.PipeEvent;
	import tools.managers.PipeManager;
	import tools.modules.user.controller.User_StartupCommand;
	import tools.modules.user.view.User_UserMediator;
	import tools.observer.Notification;

	public class User_ApplicationFacade extends Facade
	{

		public static const NAME:String = "tools.modules.user.User_ApplicationFacade";
		public static const STARTUP:String = "STARTUP";
		public static const SHOW_MAINUI:String = "SHOW_MAINUI";
		public static const CLOSE_MAINUI:String = "CLOSE_MAINUI";
		public static const RESEARCH:String = "RESEARCH";

		public function User_ApplicationFacade(param1:String)
		{
			super(param1);
			registerEvents();
			PipeManager.registerMsgs([PipeEvent.STARTUP_CHARGE,PipeEvent.SHOW_USER_MAINUI], this.handlePipeMessage, User_ApplicationFacade);
			return;
		}
		
		private function registerEvents():void
		{
			PipeManager.registerMsgs([], this.handlePipeMessage, User_ApplicationFacade);
			return;
		}
		private function removeEvents():void
		{
			PipeManager.removeMsgs([], User_ApplicationFacade);
		}

		override protected function initializeController() : void
		{
			super.initializeController();
			registerCommand(STARTUP, User_StartupCommand);
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
				case PipeEvent.SHOW_USER_MAINUI:
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

		public static function getInstance() : User_ApplicationFacade
		{
			if (instanceMap[NAME] == null)
			{
				instanceMap[NAME] = new User_ApplicationFacade(NAME);
			}
			return instanceMap[NAME] as User_ApplicationFacade;
		}
		
		public function dispose():void
		{
			removeEvents();
			var mediator:User_UserMediator = this.retrieveMediator(User_UserMediator.NAME) as User_UserMediator;
			var ui:DisplayObject = mediator.getViewComponent() as DisplayObject;
			if (ui && ui.parent)
			{
				//POPWindowManager.removeSmallWindow(ui, NAME);
			}
		}
	}
}