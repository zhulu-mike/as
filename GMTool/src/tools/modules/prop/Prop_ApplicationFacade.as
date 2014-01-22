package tools.modules.prop
{
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import tools.events.PipeEvent;
	import tools.managers.PipeManager;
	import tools.modules.prop.controller.Prop_StartupCommand;
	import tools.modules.prop.view.Prop_PropMediator;
	import tools.observer.Notification;

	public class Prop_ApplicationFacade extends Facade
	{

		public static const NAME:String = "tools.modules.prop.Prop_ApplicationFacade";
		public static const STARTUP:String = "STARTUP";
		public static const SHOW_MAINUI:String = "SHOW_MAINUI";
		public static const PROP_RESEARCH:String = "PROP_RESEARCH";
		public static const CLOSE_MAINUI:String = "CLOSE_MAINUI";

		public function Prop_ApplicationFacade(param1:String)
		{
			super(param1);
			registerEvents();
			PipeManager.registerMsgs([PipeEvent.STARTUP_CHARGE,PipeEvent.SHOW_PROP_MAINUI], this.handlePipeMessage, Prop_ApplicationFacade);
			return;
		}
		
		private function registerEvents():void
		{
			PipeManager.registerMsgs([], this.handlePipeMessage, Prop_ApplicationFacade);
			return;
		}
		private function removeEvents():void
		{
			PipeManager.removeMsgs([], Prop_ApplicationFacade);
		}

		override protected function initializeController() : void
		{
			super.initializeController();
			registerCommand(STARTUP, Prop_StartupCommand);
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
				case PipeEvent.SHOW_PROP_MAINUI:
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

		public static function getInstance() : Prop_ApplicationFacade
		{
			if (instanceMap[NAME] == null)
			{
				instanceMap[NAME] = new Prop_ApplicationFacade(NAME);
			}
			return instanceMap[NAME] as Prop_ApplicationFacade;
		}
		
		public function dispose():void
		{
			removeEvents();
			var mediator:Prop_PropMediator = this.retrieveMediator(Prop_PropMediator.NAME) as Prop_PropMediator;
			var ui:DisplayObject = mediator.getViewComponent() as DisplayObject;
			if (ui && ui.parent)
			{
				//POPWindowManager.removeSmallWindow(ui, NAME);
			}
		}
	}
}