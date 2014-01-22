package tools.modules.chargerank.controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tools.modules.chargerank.model.ChargeRank_MsgReceivedProxy;
	import tools.modules.chargerank.model.ChargeRank_MsgSendProxy;
	import tools.modules.chargerank.view.ChargeRank_ChargeRankMediator;
	import tools.modules.chargerank.view.components.ChargeRankPanel;

    public class ChargeRank_StartupCommand extends SimpleCommand
    {

        public function ChargeRank_StartupCommand()
        {
            return;
        }

        override public function execute(param1:INotification) : void
        {
            facade.registerProxy(new ChargeRank_MsgSendProxy());
            facade.registerProxy(new ChargeRank_MsgReceivedProxy());
            facade.registerMediator(new ChargeRank_ChargeRankMediator(new ChargeRankPanel()));
            return;
        }

    }
}
