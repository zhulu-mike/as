package tools.modules.mainui.controller
{
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    
    import tools.modules.mainui.model.MainUI_MsgReceivedProxy;
    import tools.modules.mainui.model.MainUI_MsgSendProxy;
    import tools.modules.mainui.view.MainUI_Mediator;
    import tools.modules.mainui.view.ServerList_Mediator;
    import tools.modules.mainui.view.components.MainUIPanel;
    import tools.modules.mainui.view.components.ServerListPanel;
    

    public class MainUI_StartupCommand extends SimpleCommand
    {

        public function MainUI_StartupCommand()
        {
            return;
        }

        override public function execute(param1:INotification) : void
        {
			facade.registerProxy(new MainUI_MsgReceivedProxy());
			facade.registerProxy(new MainUI_MsgSendProxy());
            facade.registerMediator(new MainUI_Mediator(new MainUIPanel()));
//            facade.registerMediator(new ServerList_Mediator(new ServerListPanel()));
            return;
        }

    }
}
