package tools.modules.login.model
{
    
    import mx.controls.Alert;
    
    import org.osflash.thunderbolt.Logger;
    import org.puremvc.as3.multicore.patterns.proxy.*;
    
    import tools.managers.NetWorkManager;
    import tools.modules.login.Login_ApplicationFacade;
    import tools.net.SSocket;
    import tools.net.TSocketEvent;

    public class Login_LoginSocketManager extends Proxy
    {
        public static const NAME:String = "Login_LoginSocketProxy";

        public function Login_LoginSocketManager()
        {
            super(NAME, NetWorkManager.mainSocket);
            return;
        }

        override public function onRegister() : void
        {
            this.socket.addEventListener(TSocketEvent.LOGIN_SUCCESS, this.socketLoginSuccessHandler);
            this.socket.addEventListener(TSocketEvent.LOGIN_FAILURE, this.socketLoginFailureHandler);
            this.socket.addEventListener(TSocketEvent.CLOSE, this.socketCloseHandler);
            return;
        }

        override public function onRemove() : void
        {
            this.socket.removeEventListener(TSocketEvent.LOGIN_SUCCESS, this.socketLoginSuccessHandler);
            this.socket.removeEventListener(TSocketEvent.LOGIN_FAILURE, this.socketLoginFailureHandler);
            this.socket.removeEventListener(TSocketEvent.CLOSE, this.socketCloseHandler);
            return;
        }

        protected function get socket() : SSocket
        {
            return data as SSocket;
        }

        private function socketLoginSuccessHandler(event:TSocketEvent = null) : void
        {
			NetWorkManager.sendAuthString();
            Logger.warn(Language.CON_SERV_SUCCESS);   
            return;
        }

        private function socketLoginFailureHandler(event:TSocketEvent = null) : void
        {
            var e:* = event;
            Logger.warn(Language.CON_SERV_FAULER);
			Alert.show(Language.CON_SERV_FAULER,Language.TISHI);
            return;
        }

        private function socketCloseHandler(event:TSocketEvent = null) : void
        {
            Logger.warn(Language.CON_SERV_BREAK);
			Alert.show(Language.CON_SERV_BREAK,Language.TISHI);
            return;
        }

    }
}
