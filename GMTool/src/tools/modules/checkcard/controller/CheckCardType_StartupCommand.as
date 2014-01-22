package tools.modules.checkcard.controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tools.modules.checkcard.model.CheckCardType_MsgReceivedProxy;
	import tools.modules.checkcard.model.CheckCardType_MsgSendProxy;
	import tools.modules.checkcard.view.CheckCardType_CheckCardTypeMediator;
	import tools.modules.checkcard.view.components.CheckCardType;

    public class CheckCardType_StartupCommand extends SimpleCommand
    {

        public function CheckCardType_StartupCommand()
        {
            return;
        }

        override public function execute(param1:INotification) : void
        {
            facade.registerProxy(new CheckCardType_MsgSendProxy());
            facade.registerProxy(new CheckCardType_MsgReceivedProxy());
            facade.registerMediator(new CheckCardType_CheckCardTypeMediator(new CheckCardType()));
            return;
        }

    }
}
