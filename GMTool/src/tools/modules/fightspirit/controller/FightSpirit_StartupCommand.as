package tools.modules.fightspirit.controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tools.modules.fightspirit.model.FightSpirit_MsgReceivedProxy;
	import tools.modules.fightspirit.model.FightSpirit_MsgSendProxy;
	import tools.modules.fightspirit.view.FightSpirit_FightSpiritMediator;
	import tools.modules.fightspirit.view.components.FightSpiritPanel;

    public class FightSpirit_StartupCommand extends SimpleCommand
    {

        public function FightSpirit_StartupCommand()
        {
            return;
        }

        override public function execute(param1:INotification) : void
        {
            facade.registerProxy(new FightSpirit_MsgSendProxy());
            facade.registerProxy(new FightSpirit_MsgReceivedProxy());
            facade.registerMediator(new FightSpirit_FightSpiritMediator(new FightSpiritPanel()));
            return;
        }

    }
}
