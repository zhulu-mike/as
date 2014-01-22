package tools.modules.equip.controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tools.modules.equip.model.EquipManager_MsgReceivedProxy;
	import tools.modules.equip.model.EquipManager_MsgSendProxy;
	import tools.modules.equip.view.EquipManager_EquipManagerMediator;
	import tools.modules.equip.view.components.EquipManagerPanel;

    public class EquipManager_StartupCommand extends SimpleCommand
    {

        public function EquipManager_StartupCommand()
        {
            return;
        }

        override public function execute(param1:INotification) : void
        {
            facade.registerProxy(new EquipManager_MsgSendProxy());
            facade.registerProxy(new EquipManager_MsgReceivedProxy());
            facade.registerMediator(new EquipManager_EquipManagerMediator(new EquipManagerPanel()));
            return;
        }

    }
}
