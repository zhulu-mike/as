package tools.modules.useronline
{
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import tools.events.PipeEvent;
	import tools.managers.PipeManager;
	import tools.modules.useronline.controller.UserOnline_StartupCommand;
	import tools.modules.useronline.view.UserOnline_UserOnlineMediator;
	import tools.observer.Notification;

	public class UserOnline_ApplicationFacade extends Facade
	{

		public static const NAME:String = "tools.modules.useronline.UserOnline_ApplicationFacade";
		public static const STARTUP:String = "STARTUP";
		public static const SHOW_MAINUI:String = "SHOW_MAINUI";
		public static const CLOSE_MAINUI:String = "CLOSE_MAINUI";
		public static const SHOW_ONLINE_NUM:String = "SHOW_ONLINE_NUM";
		public static const SHOW_ONLINE_ALL_NUM:String = "SHOW_ONLINE_ALL_NUM";

		public function UserOnline_ApplicationFacade(param1:String)
		{
			super(param1);
			registerEvents();
			PipeManager.registerMsgs([PipeEvent.STARTUP_CHARGE,PipeEvent.SHOW_PLAYER_ONLINE_MAINUI], this.handlePipeMessage, UserOnline_ApplicationFacade);
			return;
		}
		
		private function registerEvents():void
		{
			PipeManager.registerMsgs([], this.handlePipeMessage, UserOnline_ApplicationFacade);
			return;
		}
		private function removeEvents():void
		{
			PipeManager.removeMsgs([], UserOnline_ApplicationFacade);
		}

		override protected function initializeController() : void
		{
			super.initializeController();
			registerCommand(STARTUP, UserOnline_StartupCommand);
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
				case PipeEvent.SHOW_PLAYER_ONLINE_MAINUI:
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

		public static function getInstance() : UserOnline_ApplicationFacade
		{
			if (instanceMap[NAME] == null)
			{
				instanceMap[NAME] = new UserOnline_ApplicationFacade(NAME);
			}
			return instanceMap[NAME] as UserOnline_ApplicationFacade;
		}
		
		public function dispose():void
		{
			removeEvents();
			var mediator:UserOnline_UserOnlineMediator = this.retrieveMediator(UserOnline_UserOnlineMediator.NAME) as UserOnline_UserOnlineMediator;
			var ui:DisplayObject = mediator.getViewComponent() as DisplayObject;
			if (ui && ui.parent)
			{
				//POPWindowManager.removeSmallWindow(ui, NAME);
			}
		}
	}
}