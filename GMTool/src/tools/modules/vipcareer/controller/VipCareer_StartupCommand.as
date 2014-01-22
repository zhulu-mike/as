package tools.modules.vipcareer.controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tools.modules.vipcareer.model.VipCareer_MsgReceivedProxy;
	import tools.modules.vipcareer.model.VipCareer_MsgSendProxy;
	import tools.modules.vipcareer.view.VipCareer_VipCareerMediator;
	import tools.modules.vipcareer.view.components.VipCareerPanel;

    public class VipCareer_StartupCommand extends SimpleCommand
    {

        public function VipCareer_StartupCommand()
        {
            return;
        }

        override public function execute(param1:INotification) : void
        {
            facade.registerProxy(new VipCareer_MsgSendProxy());
            facade.registerProxy(new VipCareer_MsgReceivedProxy());
            facade.registerMediator(new VipCareer_VipCareerMediator(new VipCareerPanel()));
            return;
        }

    }
}
