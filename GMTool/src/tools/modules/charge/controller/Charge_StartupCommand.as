package tools.modules.charge.controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tools.modules.charge.model.Charge_MsgReceivedProxy;
	import tools.modules.charge.model.Charge_MsgSendProxy;
	import tools.modules.charge.view.Charge_ChargeMediator;
	import tools.modules.charge.view.components.ChargePanel;

    public class Charge_StartupCommand extends SimpleCommand
    {

        public function Charge_StartupCommand()
        {
            return;
        }

        override public function execute(param1:INotification) : void
        {
            facade.registerProxy(new Charge_MsgSendProxy());
            facade.registerProxy(new Charge_MsgReceivedProxy());
            facade.registerMediator(new Charge_ChargeMediator(new ChargePanel()));
            return;
        }

    }
}
