package tools.modules.addserver.controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tools.modules.addserver.model.AddServer_MsgReceivedProxy;
	import tools.modules.addserver.model.AddServer_MsgSendProxy;
	import tools.modules.addserver.view.AddServer_AddServerMediator;
	import tools.modules.addserver.view.components.AddServerPanel;

    public class AddServer_StartupCommand extends SimpleCommand
    {

        public function AddServer_StartupCommand()
        {
            return;
        }

        override public function execute(param1:INotification) : void
        {
            facade.registerProxy(new AddServer_MsgSendProxy());
            facade.registerProxy(new AddServer_MsgReceivedProxy());
            facade.registerMediator(new AddServer_AddServerMediator(new AddServerPanel()));
            return;
        }

    }
}
