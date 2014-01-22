package tools.modules.chat.controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tools.modules.chat.model.Chat_MsgReceivedProxy;
	import tools.modules.chat.model.Chat_MsgSendProxy;
	import tools.modules.chat.view.Chat_ChatMediator;
	import tools.modules.chat.view.components.ChatPanel;

    public class Chat_StartupCommand extends SimpleCommand
    {

        public function Chat_StartupCommand()
        {
            return;
        }

        override public function execute(param1:INotification) : void
        {
            facade.registerProxy(new Chat_MsgSendProxy());
            facade.registerProxy(new Chat_MsgReceivedProxy());
//            facade.registerMediator(new Chat_ChatMediator(new ChatPanel()));
            return;
        }

    }
}
