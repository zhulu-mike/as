package tools.modules.supgas.controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tools.modules.supgas.model.SuperGas_MsgReceivedProxy;
	import tools.modules.supgas.model.SuperGas_MsgSendProxy;
	import tools.modules.supgas.view.SuperGas_SuperGasMediator;
	import tools.modules.supgas.view.components.SuperGasPanel;

    public class SuperGas_StartupCommand extends SimpleCommand
    {

        public function SuperGas_StartupCommand()
        {
            return;
        }

        override public function execute(param1:INotification) : void
        {
            facade.registerProxy(new SuperGas_MsgSendProxy());
            facade.registerProxy(new SuperGas_MsgReceivedProxy());
            facade.registerMediator(new SuperGas_SuperGasMediator(new SuperGasPanel()));
            return;
        }

    }
}
