package tools.modules.useronline.controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tools.modules.useronline.model.UserOnline_MsgReceivedProxy;
	import tools.modules.useronline.model.UserOnline_MsgSendProxy;
	import tools.modules.useronline.view.UserOnline_UserOnlineMediator;
	import tools.modules.useronline.view.components.UserOnlinePanel;

    public class UserOnline_StartupCommand extends SimpleCommand
    {

        public function UserOnline_StartupCommand()
        {
            return;
        }

        override public function execute(param1:INotification) : void
        {
            facade.registerProxy(new UserOnline_MsgSendProxy());
            facade.registerProxy(new UserOnline_MsgReceivedProxy());
            facade.registerMediator(new UserOnline_UserOnlineMediator(new UserOnlinePanel()));
            return;
        }

    }
}
