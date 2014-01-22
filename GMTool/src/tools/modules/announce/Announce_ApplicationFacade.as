package tools.modules.announce
{
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import tools.events.PipeEvent;
	import tools.managers.PipeManager;
	import tools.modules.announce.controller.Announce_StartupCommand;
	import tools.modules.announce.view.Announce_AnnounceMediator;
	import tools.observer.Notification;

	public class Announce_ApplicationFacade extends Facade
	{

		public static const NAME:String = "tools.modules.announce.Announce_ApplicationFacade";
		public static const STARTUP:String = "STARTUP";
		public static const SHOW_MAINUI:String = "SHOW_MAINUI";
		public static const CLOSE_MAINUI:String = "CLOSE_MAINUI";
		public static const CREAT_ANNOUNCE:String = "CREAT_ANNOUNCE";
		public static const ANNOUNCE_RESP:String = "ANNOUNCE_RESP";
		public static const DELETE_ANNOUNCE:String = "DELETE_ANNOUNCE";

		public function Announce_ApplicationFacade(param1:String)
		{
			super(param1);
			registerEvents();
			PipeManager.registerMsgs([PipeEvent.STARTUP_CHARGE,PipeEvent.SHOW_ANNOUNCE_MANAGER_MAINUI], this.handlePipeMessage, Announce_ApplicationFacade);
			return;
		}
		
		private function registerEvents():void
		{
			PipeManager.registerMsgs([], this.handlePipeMessage, Announce_ApplicationFacade);
			return;
		}
		private function removeEvents():void
		{
			PipeManager.removeMsgs([], Announce_ApplicationFacade);
		}

		override protected function initializeController() : void
		{
			super.initializeController();
			registerCommand(STARTUP, Announce_StartupCommand);
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
				case PipeEvent.SHOW_ANNOUNCE_MANAGER_MAINUI:
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

		public static function getInstance() : Announce_ApplicationFacade
		{
			if (instanceMap[NAME] == null)
			{
				instanceMap[NAME] = new Announce_ApplicationFacade(NAME);
			}
			return instanceMap[NAME] as Announce_ApplicationFacade;
		}
		
		public function dispose():void
		{
			removeEvents();
			var mediator:Announce_AnnounceMediator = this.retrieveMediator(Announce_AnnounceMediator.NAME) as Announce_AnnounceMediator;
			var ui:DisplayObject = mediator.getViewComponent() as DisplayObject;
			if (ui && ui.parent)
			{
				//POPWindowManager.removeSmallWindow(ui, NAME);
			}
		}
	}
}