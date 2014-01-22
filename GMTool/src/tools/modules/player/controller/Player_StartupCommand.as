package tools.modules.player.controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tools.modules.player.model.Player_MsgReceivedProxy;
	import tools.modules.player.model.Player_MsgSendProxy;
	import tools.modules.player.view.Player_PlayerMediator;
	import tools.modules.player.view.components.PlayerInfoPanel;

    public class Player_StartupCommand extends SimpleCommand
    {

        public function Player_StartupCommand()
        {
            return;
        }

        override public function execute(param1:INotification) : void
        {
            facade.registerProxy(new Player_MsgSendProxy());
            facade.registerProxy(new Player_MsgReceivedProxy());
            facade.registerMediator(new Player_PlayerMediator(new PlayerInfoPanel()));
            return;
        }

    }
}
