package tools.modules.prop.controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tools.modules.prop.model.Prop_MsgReceivedProxy;
	import tools.modules.prop.model.Prop_MsgSendProxy;
	import tools.modules.prop.view.Prop_PropMediator;
	import tools.modules.prop.view.components.PropManagerPanel;

    public class Prop_StartupCommand extends SimpleCommand
    {

        public function Prop_StartupCommand()
        {
            return;
        }

        override public function execute(param1:INotification) : void
        {
            facade.registerProxy(new Prop_MsgSendProxy());
            facade.registerProxy(new Prop_MsgReceivedProxy());
            facade.registerMediator(new Prop_PropMediator(new PropManagerPanel()));
            return;
        }

    }
}
