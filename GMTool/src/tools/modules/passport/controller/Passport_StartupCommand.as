package tools.modules.passport.controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tools.modules.passport.model.Passport_MsgReceivedProxy;
	import tools.modules.passport.model.Passport_MsgSendProxy;
	import tools.modules.passport.view.Passport_PassportMediator;
	import tools.modules.passport.view.components.PassportPanel;

    public class Passport_StartupCommand extends SimpleCommand
    {

        public function Passport_StartupCommand()
        {
            return;
        }

        override public function execute(param1:INotification) : void
        {
            facade.registerProxy(new Passport_MsgSendProxy());
            facade.registerProxy(new Passport_MsgReceivedProxy());
            facade.registerMediator(new Passport_PassportMediator(new PassportPanel()));
            return;
        }

    }
}
