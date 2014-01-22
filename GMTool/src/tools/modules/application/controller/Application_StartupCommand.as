package tools.modules.application.controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tools.modules.application.model.Application_MsgReceivedProxy;
	import tools.modules.application.model.Application_MsgSendProxy;
	import tools.modules.application.view.Application_ApplicationMediator;
	import tools.modules.application.view.components.ApplicationPanel;

    public class Application_StartupCommand extends SimpleCommand
    {

        public function Application_StartupCommand()
        {
            return;
        }

        override public function execute(param1:INotification) : void
        {
            facade.registerProxy(new Application_MsgSendProxy());
            facade.registerProxy(new Application_MsgReceivedProxy());
            facade.registerMediator(new Application_ApplicationMediator(new ApplicationPanel()));
            return;
        }

    }
}
