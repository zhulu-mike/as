package tools.modules.vipcareer
{
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import tools.events.PipeEvent;
	import tools.managers.PipeManager;
	import tools.modules.vipcareer.controller.VipCareer_StartupCommand;
	import tools.modules.vipcareer.view.VipCareer_VipCareerMediator;
	import tools.observer.Notification;

	public class VipCareer_ApplicationFacade extends Facade
	{

		public static const NAME:String = "tools.modules.vipcareer.VipCareer_ApplicationFacade";
		public static const STARTUP:String = "STARTUP";
		public static const SHOW_MAINUI:String = "SHOW_MAINUI";
		public static const CLOSE_MAINUI:String = "CLOSE_MAINUI";
		public static const VIP_CAREER_RESP:String = "VIP_CAREER_RESP";

		public function VipCareer_ApplicationFacade(param1:String)
		{
			super(param1);
			registerEvents();
			PipeManager.registerMsgs([PipeEvent.STARTUP_CHARGE,PipeEvent.SHOW_VIP_CAREER], this.handlePipeMessage, VipCareer_ApplicationFacade);
			return;
		}
		
		private function registerEvents():void
		{
			PipeManager.registerMsgs([], this.handlePipeMessage, VipCareer_ApplicationFacade);
			return;
		}
		private function removeEvents():void
		{
			PipeManager.removeMsgs([], VipCareer_ApplicationFacade);
		}

		override protected function initializeController() : void
		{
			super.initializeController();
			registerCommand(STARTUP, VipCareer_StartupCommand);
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
				case PipeEvent.SHOW_VIP_CAREER:
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

		public static function getInstance() : VipCareer_ApplicationFacade
		{
			if (instanceMap[NAME] == null)
			{
				instanceMap[NAME] = new VipCareer_ApplicationFacade(NAME);
			}
			return instanceMap[NAME] as VipCareer_ApplicationFacade;
		}
		
		public function dispose():void
		{
			removeEvents();
			var mediator:VipCareer_VipCareerMediator = this.retrieveMediator(VipCareer_VipCareerMediator.NAME) as VipCareer_VipCareerMediator;
			var ui:DisplayObject = mediator.getViewComponent() as DisplayObject;
			if (ui && ui.parent)
			{
				//POPWindowManager.removeSmallWindow(ui, NAME);
			}
		}
	}
}