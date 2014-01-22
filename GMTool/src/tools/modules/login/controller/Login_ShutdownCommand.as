package tools.modules.login.controller
{
    import tools.modules.login.*;
    import tools.modules.login.model.*;
    import tools.modules.login.view.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.command.*;

    public class Login_ShutdownCommand extends SimpleCommand
    {

        public function Login_ShutdownCommand()
        {
            return;
        }

        override public function execute(param1:INotification) : void
        {
            facade.removeProxy(Login_LoginSocketManager.NAME);
            facade.removeProxy(Login_MsgSenderProxy.NAME);
            facade.removeProxy(Login_MsgReceivedProxy.NAME);
            facade.removeMediator(Login_LoginMediator.NAME);
            facade.removeCommand(Login_ApplicationFacade.LOGIN_DEFEAT);
            return;
        }

    }
}
