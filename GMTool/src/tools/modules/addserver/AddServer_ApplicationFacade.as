package tools.modules.addserver
{
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import tools.events.PipeEvent;
	import tools.managers.PipeManager;
	import tools.modules.addserver.controller.AddServer_StartupCommand;
	import tools.modules.addserver.view.AddServer_AddServerMediator;
	import tools.observer.Notification;

	public class AddServer_ApplicationFacade extends Facade
	{

		public static const NAME:String = "tools.modules.addserver.AddServer_ApplicationFacade";
		public static const STARTUP:String = "STARTUP";
		public static const SHOW_MAINUI:String = "SHOW_MAINUI";
		public static const CLOSE_MAINUI:String = "CLOSE_MAINUI";
		public static const RESP_ADD_SERVER:String = "RESP_ADD_SERVER";
		public static const CHANGE_SERVER_LIST:String = "CHANGE_SERVER_LIST";
		public static const RESP_CHOOSE_SERVER:String = "RESP_CHOOSE_SERVER";
		public static const RESP_SERVER_LIST:String = "RESP_SERVER_LIST";

		public function AddServer_ApplicationFacade(param1:String)
		{
			super(param1);
			registerEvents();
			PipeManager.registerMsgs([PipeEvent.STARTUP_CHARGE,PipeEvent.SHOW_ADD_SERVER_LIST_MAINUI], this.handlePipeMessage, AddServer_ApplicationFacade);
			return;
		}
		
		private function registerEvents():void
		{
			PipeManager.registerMsgs([], this.handlePipeMessage, AddServer_ApplicationFacade);
			return;
		}
		private function removeEvents():void
		{
			PipeManager.removeMsgs([], AddServer_ApplicationFacade);
		}

		override protected function initializeController() : void
		{
			super.initializeController();
			registerCommand(STARTUP, AddServer_StartupCommand);
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
				case PipeEvent.SHOW_ADD_SERVER_LIST_MAINUI:
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

		public static function getInstance() : AddServer_ApplicationFacade
		{
			if (instanceMap[NAME] == null)
			{
				instanceMap[NAME] = new AddServer_ApplicationFacade(NAME);
			}
			return instanceMap[NAME] as AddServer_ApplicationFacade;
		}
		
		public function dispose():void
		{
			removeEvents();
			var mediator:AddServer_AddServerMediator = this.retrieveMediator(AddServer_AddServerMediator.NAME) as AddServer_AddServerMediator;
			var ui:DisplayObject = mediator.getViewComponent() as DisplayObject;
			if (ui && ui.parent)
			{
				//POPWindowManager.removeSmallWindow(ui, NAME);
			}
		}
	}
}