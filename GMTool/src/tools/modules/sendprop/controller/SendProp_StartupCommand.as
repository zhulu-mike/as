package tools.modules.sendprop.controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tools.modules.sendprop.model.SendProp_MsgReceivedProxy;
	import tools.modules.sendprop.model.SendProp_MsgSendProxy;
	import tools.modules.sendprop.view.SendProp_SendPropMediator;
	import tools.modules.sendprop.view.components.SendPropPanel;

    public class SendProp_StartupCommand extends SimpleCommand
    {

        public function SendProp_StartupCommand()
        {
            return;
        }

        override public function execute(param1:INotification) : void
        {
            facade.registerProxy(new SendProp_MsgSendProxy());
            facade.registerProxy(new SendProp_MsgReceivedProxy());
            facade.registerMediator(new SendProp_SendPropMediator(new SendPropPanel()));
            return;
        }

    }
}
