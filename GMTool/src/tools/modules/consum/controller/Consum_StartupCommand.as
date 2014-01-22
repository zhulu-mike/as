package tools.modules.consum.controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tools.modules.consum.model.Consum_MsgReceivedProxy;
	import tools.modules.consum.model.Consum_MsgSendProxy;
	import tools.modules.consum.view.Consum_ConsumMediator;
	import tools.modules.consum.view.components.ConsumPanel;

    public class Consum_StartupCommand extends SimpleCommand
    {

        public function Consum_StartupCommand()
        {
            return;
        }

        override public function execute(param1:INotification) : void
        {
            facade.registerProxy(new Consum_MsgSendProxy());
            facade.registerProxy(new Consum_MsgReceivedProxy());
            facade.registerMediator(new Consum_ConsumMediator(new ConsumPanel()));
            return;
        }

    }
}
