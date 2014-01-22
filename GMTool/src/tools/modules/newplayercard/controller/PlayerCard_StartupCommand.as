package tools.modules.newplayercard.controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tools.modules.newplayercard.model.PlayerCard_MsgReceivedProxy;
	import tools.modules.newplayercard.model.PlayerCard_MsgSendProxy;
	import tools.modules.newplayercard.view.PlayerCard_PlayerCardMediator;
	import tools.modules.newplayercard.view.components.PlayerCardPanel;

    public class PlayerCard_StartupCommand extends SimpleCommand
    {

        public function PlayerCard_StartupCommand()
        {
            return;
        }

        override public function execute(param1:INotification) : void
        {
            facade.registerProxy(new PlayerCard_MsgSendProxy());
            facade.registerProxy(new PlayerCard_MsgReceivedProxy());
            facade.registerMediator(new PlayerCard_PlayerCardMediator(new PlayerCardPanel()));
            return;
        }

    }
}
