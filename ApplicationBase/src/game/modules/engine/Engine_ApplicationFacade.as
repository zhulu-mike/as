package game.modules.engine
{
	import com.thinkido.framework.common.observer.Notification;
	
	import flash.display.DisplayObject;
	
	import game.events.PipeEvent;
	import game.manager.PipeManager;
	import game.modules.engine.controller.Engine_StartupCommand;
	import game.modules.engine.view.Engine_EngineMediator;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	public class Engine_ApplicationFacade extends Facade
	{

		public static const NAME:String = "game.modules.engine.Engine_ApplicationFacade";
		public static const STARTUP:String = "STARTUP";
		public static const SHOW_MAINUI:String = "SHOW_MAINUI";
		public static const CLOSE_MAINUI:String = "CLOSE_MAINUI";
		public static const INIT_ENGINE:String = "INIT_ENGINE";
		/**
		 * 场景交互事件
		 */		
		public static const SCENE_INTERACTIVE_EVENT:String = "SCENE_INTERACTIVE_EVENT";

		public function Engine_ApplicationFacade(param1:String)
		{
			super(param1);
			registerEvents();
			//注册开启事件和一些不用移除的事件
			PipeManager.registerMsgs([PipeEvent.STARTUP_ENGINE
			], this.handlePipeMessage, Engine_ApplicationFacade);
			return;
		}
		
		/**注册需要移除的事件*/
		private function registerEvents():void
		{
			PipeManager.registerMsgs([], this.handlePipeMessage, Engine_ApplicationFacade);
			return;
		}
		
		/**移除需要移除的事件*/
		private function removeEvents():void
		{
			PipeManager.removeMsgs([], Engine_ApplicationFacade);
		}

		override protected function initializeController() : void
		{
			super.initializeController();
			registerCommand(STARTUP, Engine_StartupCommand);
			return;
		}
		
		private function handlePipeMessage(param1:Notification) : void
		{
			var _loc_2:Object = null;
			var _loc_3:Boolean = false;
			_loc_2 = param1.body;
			switch(param1.name)
			{
				case PipeEvent.STARTUP_ENGINE:
					startup();
					break;
			}
		}

		private function startup() : void
		{
			sendNotification(STARTUP);
//			instanceStartMap[NAME] = true;
			return;
		}

		public static function getInstance() : Engine_ApplicationFacade
		{
			if (instanceMap[NAME] == null)
			{
				instanceMap[NAME] = new Engine_ApplicationFacade(NAME);
			}
			return instanceMap[NAME] as Engine_ApplicationFacade;
		}
		
		public function dispose():void
		{
			removeEvents();
			sendNotification(CLOSE_MAINUI);
		}
	}
}