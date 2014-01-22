package tools.modules.chargecount.controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tools.modules.chargecount.model.ChargeCount_MsgReceivedProxy;
	import tools.modules.chargecount.model.ChargeCount_MsgSendProxy;
	import tools.modules.chargecount.view.ChargeCount_ChargeCountMediator;
	import tools.modules.chargecount.view.components.ChargeCountPanel;

    public class ChargeCount_StartupCommand extends SimpleCommand
    {

        public function ChargeCount_StartupCommand()
        {
            return;
        }

        override public function execute(param1:INotification) : void
        {
            facade.registerProxy(new ChargeCount_MsgSendProxy());
            facade.registerProxy(new ChargeCount_MsgReceivedProxy());
            facade.registerMediator(new ChargeCount_ChargeCountMediator(new ChargeCountPanel()));
            return;
        }

    }
}
