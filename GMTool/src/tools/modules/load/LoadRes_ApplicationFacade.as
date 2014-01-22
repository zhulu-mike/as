package tools.modules.load
{
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import tools.events.PipeEvent;
	import tools.managers.PipeManager;
	import tools.modules.load.controller.LoadRes_StartupCommand;
	import tools.modules.load.view.LoadRes_LoadResMediator;
	import tools.observer.Notification;

	public class LoadRes_ApplicationFacade extends Facade
	{

		public static const NAME:String = "tools.modules.load.LoadRes_ApplicationFacade";
		public static const STARTUP:String = "STARTUP";
		public static const SHOW_MAINUI:String = "SHOW_MAINUI";
		public static const LOAD_BEGIN:String = "LOAD_BEGIN";
		

		public function LoadRes_ApplicationFacade(param1:String)
		{
			super(param1);
			registerEvents();
			PipeManager.registerMsgs([], this.handlePipeMessage, LoadRes_ApplicationFacade);
			return;
		}
		
		private function registerEvents():void
		{
			PipeManager.registerMsgs([PipeEvent.STARTUP_LOADRES], this.handlePipeMessage, LoadRes_ApplicationFacade);
			return;
		}
		private function removeEvents():void
		{
			PipeManager.removeMsgs([], LoadRes_ApplicationFacade);
		}

		override protected function initializeController() : void
		{
			super.initializeController();
			registerCommand(STARTUP, LoadRes_StartupCommand);
			return;
		}
		
		private function handlePipeMessage(param1:Notification) : void
		{
			var _loc_2:Object = null;
			var _loc_3:Boolean = false;
			_loc_2 = param1.body;
			switch(param1.name)
			{
				case PipeEvent.STARTUP_LOADRES:
					startup();
					break;
			}
		}

		private function startup() : void
		{
			sendNotification(STARTUP);
			instanceStartMap[NAME] = true;
			return;
		}

		public static function getInstance() : LoadRes_ApplicationFacade
		{
			if (instanceMap[NAME] == null)
			{
				instanceMap[NAME] = new LoadRes_ApplicationFacade(NAME);
			}
			return instanceMap[NAME] as LoadRes_ApplicationFacade;
		}
		
		public function dispose():void
		{
			removeEvents();
			var mediator:LoadRes_LoadResMediator = this.retrieveMediator(LoadRes_LoadResMediator.NAME) as LoadRes_LoadResMediator;
			var ui:DisplayObject = mediator.getViewComponent() as DisplayObject;
			if (ui && ui.parent)
			{
				//POPWindowManager.removeSmallWindow(ui, NAME);
			}
		}
	}
}