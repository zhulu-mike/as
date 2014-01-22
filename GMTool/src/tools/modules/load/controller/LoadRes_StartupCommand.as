package tools.modules.load.controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tools.modules.load.LoadRes_ApplicationFacade;
	import tools.modules.load.model.LoadRes_MsgReceivedProxy;
	import tools.modules.load.model.LoadRes_MsgSendProxy;
	import tools.modules.load.view.LoadRes_LoadResMediator;

    public class LoadRes_StartupCommand extends SimpleCommand
    {

        public function LoadRes_StartupCommand()
        {
            return;
        }

        override public function execute(param1:INotification) : void
        {
            facade.registerProxy(new LoadRes_MsgSendProxy());
            facade.registerProxy(new LoadRes_MsgReceivedProxy());
            facade.registerCommand(LoadRes_ApplicationFacade.LOAD_BEGIN, LoadRes_LoadXMLCommand);
			facade.sendNotification(LoadRes_ApplicationFacade.LOAD_BEGIN);
            return;
        }

    }
}
