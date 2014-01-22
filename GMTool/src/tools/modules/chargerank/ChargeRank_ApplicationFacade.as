package tools.modules.chargerank
{
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import tools.events.PipeEvent;
	import tools.managers.PipeManager;
	import tools.modules.chargerank.controller.ChargeRank_StartupCommand;
	import tools.modules.chargerank.view.ChargeRank_ChargeRankMediator;
	import tools.observer.Notification;

	public class ChargeRank_ApplicationFacade extends Facade
	{

		public static const NAME:String = "tools.modules.chargerank.ChargeRank_ApplicationFacade";
		public static const STARTUP:String = "STARTUP";
		public static const SHOW_MAINUI:String = "SHOW_MAINUI";
		public static const CLOSE_MAINUI:String = "CLOSE_MAINUI";
		public static const CHARGE_RANK_RESP:String = "CHARGE_RANK_RESP";

		public function ChargeRank_ApplicationFacade(param1:String)
		{
			super(param1);
			registerEvents();
			PipeManager.registerMsgs([PipeEvent.STARTUP_CHARGE,PipeEvent.SHOW_CHARGE_RANK_MAINUI], this.handlePipeMessage, ChargeRank_ApplicationFacade);
			return;
		}
		
		private function registerEvents():void
		{
			PipeManager.registerMsgs([], this.handlePipeMessage, ChargeRank_ApplicationFacade);
			return;
		}
		private function removeEvents():void
		{
			PipeManager.removeMsgs([], ChargeRank_ApplicationFacade);
		}

		override protected function initializeController() : void
		{
			super.initializeController();
			registerCommand(STARTUP, ChargeRank_StartupCommand);
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
				case PipeEvent.SHOW_CHARGE_RANK_MAINUI:
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

		public static function getInstance() : ChargeRank_ApplicationFacade
		{
			if (instanceMap[NAME] == null)
			{
				instanceMap[NAME] = new ChargeRank_ApplicationFacade(NAME);
			}
			return instanceMap[NAME] as ChargeRank_ApplicationFacade;
		}
		
		public function dispose():void
		{
			removeEvents();
			var mediator:ChargeRank_ChargeRankMediator = this.retrieveMediator(ChargeRank_ChargeRankMediator.NAME) as ChargeRank_ChargeRankMediator;
			var ui:DisplayObject = mediator.getViewComponent() as DisplayObject;
			if (ui && ui.parent)
			{
				//POPWindowManager.removeSmallWindow(ui, NAME);
			}
		}
	}
}