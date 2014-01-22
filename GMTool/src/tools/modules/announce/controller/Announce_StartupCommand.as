package tools.modules.announce.controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tools.modules.announce.model.Announce_MsgReceivedProxy;
	import tools.modules.announce.model.Announce_MsgSendProxy;
	import tools.modules.announce.view.Announce_AnnounceMediator;
	import tools.modules.announce.view.components.AnnouncePanel;

    public class Announce_StartupCommand extends SimpleCommand
    {

        public function Announce_StartupCommand()
        {
            return;
        }

        override public function execute(param1:INotification) : void
        {
            facade.registerProxy(new Announce_MsgSendProxy());
            facade.registerProxy(new Announce_MsgReceivedProxy());
            facade.registerMediator(new Announce_AnnounceMediator(new AnnouncePanel()));
            return;
        }

    }
}
