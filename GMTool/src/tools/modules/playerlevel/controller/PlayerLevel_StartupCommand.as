package tools.modules.playerlevel.controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tools.modules.playerlevel.model.PlayerLevel_MsgReceivedProxy;
	import tools.modules.playerlevel.model.PlayerLevel_MsgSendProxy;
	import tools.modules.playerlevel.view.PlayerLevel_PlayerLevelMediator;
	import tools.modules.playerlevel.view.components.PlayerLevelPanel;

    public class PlayerLevel_StartupCommand extends SimpleCommand
    {

        public function PlayerLevel_StartupCommand()
        {
            return;
        }

        override public function execute(param1:INotification) : void
        {
            facade.registerProxy(new PlayerLevel_MsgSendProxy());
            facade.registerProxy(new PlayerLevel_MsgReceivedProxy());
            facade.registerMediator(new PlayerLevel_PlayerLevelMediator(new PlayerLevelPanel()));
            return;
        }

    }
}
