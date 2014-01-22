package game.modules.mainui.controller
{
	import game.modules.mainui.model.MainUI_MsgReceivedProxy;
	import game.modules.mainui.model.MainUI_MsgSendProxy;
	import game.modules.mainui.view.MainUI_MainUIMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

    public class MainUI_StartupCommand extends SimpleCommand
    {

        public function MainUI_StartupCommand()
        {
            return;
        }

        override public function execute(param1:INotification) : void
        {
            facade.registerProxy(new MainUI_MsgSendProxy());
            facade.registerProxy(new MainUI_MsgReceivedProxy());
            facade.registerMediator();
            return;
        }

    }
}
