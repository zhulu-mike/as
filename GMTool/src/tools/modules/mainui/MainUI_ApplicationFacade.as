package tools.modules.mainui
{
    import org.puremvc.as3.multicore.patterns.facade.*;
    
    import tools.events.PipeEvent;
    import tools.managers.PipeManager;
    import tools.modules.mainui.controller.MainUI_StartupCommand;
    import tools.observer.Notification;

    public class MainUI_ApplicationFacade extends Facade
    {
        public static const NAME:String = "tools.modules.mainui.MainUI_ApplicationFacade";
        public static const STARTUP:String = "STARTUP";
        public static const SHOW_MAINUI:String = "SHOW_MAINUI";
        public static const LOGIN_DEFEAT:String = "LOGIN_DEFEAT";
        public static const ADD_CHILD_TO_MAINUI:String = "ADD_CHILD_TO_MAINUI";
        public static const RESP_SERVER_LIST:String = "RESP_SERVER_LIST";
        public static const KICK_OUT_REFRESH:String = "KICK_OUT_REFRESH";

		public static const SHOW_SERVER_MAINUI:String = "SHOW_SERVER_MAINUI";
	
		/**服务器更改返回*/
		public static const SERVER_RESP:String = "SERVER_RESP";
		
		/**服务器选择完毕*/
		public static const SERVER_CHANGE:String = "SERVER_CHANGE";
		
        public function MainUI_ApplicationFacade(param1:String)
        {
            super(param1);
            PipeManager.registerMsgs([PipeEvent.STARTUP_MAINUI, PipeEvent.SHOW_MAINUI,
			PipeEvent.ADD_CHILD_TO_MAINUI], this.handlePipeMessage, MainUI_ApplicationFacade);
            return;
        }

        public function dispose() : void
        {
            this.shutdown();
            PipeManager.removeMsgs([PipeEvent.STARTUP_MAINUI], MainUI_ApplicationFacade);
            Facade.removeCore(MainUI_ApplicationFacade.NAME);
            return;
        }

        override protected function initializeController() : void
        {
            super.initializeController();
            registerCommand(STARTUP, MainUI_StartupCommand);
            return;
        }

        private function handlePipeMessage(param1:Notification) : void
        {
            var _loc_2:* = param1.body;
            switch(param1.name)
            {
                case PipeEvent.STARTUP_MAINUI:
                {
                    this.startup();
                    break;
                }
				case PipeEvent.SHOW_MAINUI:
				{
					sendNotification(SHOW_MAINUI,_loc_2);
					break;
				}
				case PipeEvent.ADD_CHILD_TO_MAINUI:
				{
					sendNotification(ADD_CHILD_TO_MAINUI,_loc_2);
					break;
				}
                default:
                {
                    break;
                }
            }
            return;
        }

        private function startup() : void
        {
            sendNotification(STARTUP);
            return;
        }

        private function shutdown() : void
        {
            return;
        }

        public static function getInstance() : MainUI_ApplicationFacade
        {
            if (instanceMap[NAME] == null)
            {
                instanceMap[NAME] = new MainUI_ApplicationFacade(NAME);
            }
            return instanceMap[NAME] as MainUI_ApplicationFacade;
        }

    }
}
