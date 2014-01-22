package tools.modules.fightspirit
{
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import tools.events.PipeEvent;
	import tools.managers.PipeManager;
	import tools.modules.fightspirit.controller.FightSpirit_StartupCommand;
	import tools.modules.fightspirit.view.FightSpirit_FightSpiritMediator;
	import tools.observer.Notification;

	public class FightSpirit_ApplicationFacade extends Facade
	{

		public static const NAME:String = "tools.modules.fightspirit.FightSpirit_ApplicationFacade";
		public static const STARTUP:String = "STARTUP";
		public static const SHOW_MAINUI:String = "SHOW_MAINUI";
		public static const CLOSE_MAINUI:String = "CLOSE_MAINUI";
		public static const RESQ_FIGHT:String = "RESQ_FIGHT";

		public function FightSpirit_ApplicationFacade(param1:String)
		{
			super(param1);
			registerEvents();
			PipeManager.registerMsgs([PipeEvent.STARTUP_CHARGE,PipeEvent.SHOW_FIGHTER_SPIRIT_MAINUI], this.handlePipeMessage, FightSpirit_ApplicationFacade);
			return;
		}
		
		private function registerEvents():void
		{
			PipeManager.registerMsgs([], this.handlePipeMessage, FightSpirit_ApplicationFacade);
			return;
		}
		private function removeEvents():void
		{
			PipeManager.removeMsgs([], FightSpirit_ApplicationFacade);
		}

		override protected function initializeController() : void
		{
			super.initializeController();
			registerCommand(STARTUP, FightSpirit_StartupCommand);
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
				case PipeEvent.SHOW_FIGHTER_SPIRIT_MAINUI:
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

		public static function getInstance() : FightSpirit_ApplicationFacade
		{
			if (instanceMap[NAME] == null)
			{
				instanceMap[NAME] = new FightSpirit_ApplicationFacade(NAME);
			}
			return instanceMap[NAME] as FightSpirit_ApplicationFacade;
		}
		
		public function dispose():void
		{
			removeEvents();
			var mediator:FightSpirit_FightSpiritMediator = this.retrieveMediator(FightSpirit_FightSpiritMediator.NAME) as FightSpirit_FightSpiritMediator;
			var ui:DisplayObject = mediator.getViewComponent() as DisplayObject;
			if (ui && ui.parent)
			{
				//POPWindowManager.removeSmallWindow(ui, NAME);
			}
		}
	}
}