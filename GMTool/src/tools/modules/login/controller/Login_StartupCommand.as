package tools.modules.login.controller
{
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    
    import tools.managers.NetWorkManager;
    import tools.modules.login.*;
    import tools.modules.login.model.*;
    import tools.modules.login.view.*;
    import tools.modules.login.view.components.LoginPanel;

    public class Login_StartupCommand extends SimpleCommand
    {

        public function Login_StartupCommand()
        {
            return;
        }

        override public function execute(param1:INotification) : void
        {
            facade.registerProxy(new Login_LoginSocketManager());
            facade.registerProxy(new Login_MsgSenderProxy());
            facade.registerProxy(new Login_MsgReceivedProxy());
            facade.registerMediator(new Login_LoginMediator(new LoginPanel()));
//            facade.registerCommand(Login_ApplicationFacade.LOGIN_DEFEAT, Login_DefeatCommand);
            facade.registerCommand(Login_ApplicationFacade.LOGIN_CONNECT, Login_ConnectCommand);
			NetWorkManager.connectMain(Global.mainServerIP,Global.mainServerPort );
            return;
        }

    }
}
