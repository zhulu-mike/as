package tools.modules.user.controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tools.modules.user.model.User_MsgReceivedProxy;
	import tools.modules.user.model.User_MsgSendProxy;
	import tools.modules.user.view.User_UserMediator;
	import tools.modules.user.view.components.RegisterUserPanel;

    public class User_StartupCommand extends SimpleCommand
    {

        public function User_StartupCommand()
        {
            return;
        }

        override public function execute(param1:INotification) : void
        {
            facade.registerProxy(new User_MsgSendProxy());
            facade.registerProxy(new User_MsgReceivedProxy());
            facade.registerMediator(new User_UserMediator(new RegisterUserPanel()));
            return;
        }

    }
}
