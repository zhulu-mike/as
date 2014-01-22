package tools.modules.login
{
    import org.puremvc.as3.multicore.patterns.facade.*;
    
    import tools.events.PipeEvent;
    import tools.managers.PipeManager;
    import tools.modules.login.controller.*;
    import tools.observer.Notification;

    public class Login_ApplicationFacade extends Facade
    {
        public static const NAME:String = "tools.modules.login.Login_ApplicationFacade";
        public static const STARTUP:String = "STARTUP";
        public static const SHUTDOWN:String = "SHUTDOWN";
        public static const LOGIN_DEFEAT:String = "LOGIN_DEFEAT";
        public static const LOGIN_CONNECT:String = "LOGIN_CONNECT";
		public static const LOGIN_SUCCESS:String = "LOGIN_SUCCESS";

        public function Login_ApplicationFacade(param1:String)
        {
            super(param1);
            PipeManager.registerMsgs([PipeEvent.STARTUP_LOGIN], this.handlePipeMessage, Login_ApplicationFacade);
            return;
        }

        public function dispose() : void
        {
            this.shutdown();
            PipeManager.removeMsgs([PipeEvent.STARTUP_LOGIN], Login_ApplicationFacade);
            Facade.removeCore(Login_ApplicationFacade.NAME);
            return;
        }

        override protected function initializeController() : void
        {
            super.initializeController();
            registerCommand(STARTUP, Login_StartupCommand);
            return;
        }

        private function handlePipeMessage(param1:Notification) : void
        {
            var _loc_2:* = param1.body;
            switch(param1.name)
            {
                case PipeEvent.STARTUP_LOGIN:
                {
                    this.startup();
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
            sendNotification(SHUTDOWN);
            return;
        }

        public static function getInstance() : Login_ApplicationFacade
        {
            if (instanceMap[NAME] == null)
            {
                instanceMap[NAME] = new Login_ApplicationFacade(NAME);
            }
            return instanceMap[NAME] as Login_ApplicationFacade;
        }

    }
}
