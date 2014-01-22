package tools.modules.sendprop
{
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import tools.events.PipeEvent;
	import tools.managers.PipeManager;
	import tools.modules.sendprop.controller.SendProp_StartupCommand;
	import tools.modules.sendprop.view.SendProp_SendPropMediator;
	import tools.observer.Notification;

	public class SendProp_ApplicationFacade extends Facade
	{

		public static const NAME:String = "tools.modules.sendprop.SendProp_ApplicationFacade";
		public static const STARTUP:String = "STARTUP";
		public static const SHOW_MAINUI:String = "SHOW_MAINUI";
		public static const SHOW_SERVER_MAINUI:String = "SHOW_SERVER_MAINUI";
		public static const PROP_RESEARCH:String = "PROP_RESEARCH";
		public static const CLOSE_MAINUI:String = "CLOSE_MAINUI";
		public static const SEND_RESEARCH:String = "SEND_RESEARCH";
		public static const DELETE_APP:String = "DELETE_APP";
		public static const APP_LIST_RES:String = "APP_LIST_RES";
		public static const LOOK_MINE_APP:String = "LOOK_MINE_APP";
		public static const SERVER_RESP:String = "SERVER_RESP";
		
		
		

		public function SendProp_ApplicationFacade(param1:String)
		{
			super(param1);
			registerEvents();
			PipeManager.registerMsgs([PipeEvent.STARTUP_CHARGE,PipeEvent.SHOW_SEND_PROP_MAINUI], this.handlePipeMessage, SendProp_ApplicationFacade);
			return;
		}
		
		private function registerEvents():void
		{
			PipeManager.registerMsgs([], this.handlePipeMessage, SendProp_ApplicationFacade);
			return;
		}
		private function removeEvents():void
		{
			PipeManager.removeMsgs([], SendProp_ApplicationFacade);
		}

		override protected function initializeController() : void
		{
			super.initializeController();
			registerCommand(STARTUP, SendProp_StartupCommand);
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
				case PipeEvent.SHOW_SEND_PROP_MAINUI:
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

		public static function getInstance() : SendProp_ApplicationFacade
		{
			if (instanceMap[NAME] == null)
			{
				instanceMap[NAME] = new SendProp_ApplicationFacade(NAME);
			}
			return instanceMap[NAME] as SendProp_ApplicationFacade;
		}
		
		public function dispose():void
		{
			removeEvents();
			var mediator:SendProp_SendPropMediator = this.retrieveMediator(SendProp_SendPropMediator.NAME) as SendProp_SendPropMediator;
			var ui:DisplayObject = mediator.getViewComponent() as DisplayObject;
			if (ui && ui.parent)
			{
				//POPWindowManager.removeSmallWindow(ui, NAME);
			}
		}
	}
}