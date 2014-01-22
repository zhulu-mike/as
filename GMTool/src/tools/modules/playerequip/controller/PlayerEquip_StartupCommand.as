package tools.modules.playerequip.controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tools.modules.playerequip.model.PlayerEquip_MsgReceivedProxy;
	import tools.modules.playerequip.model.PlayerEquip_MsgSendProxy;
	import tools.modules.playerequip.view.PlayerEquip_PlayerEquipMediator;
	import tools.modules.playerequip.view.components.PlayerEquipPanel;

    public class PlayerEquip_StartupCommand extends SimpleCommand
    {

        public function PlayerEquip_StartupCommand()
        {
            return;
        }

        override public function execute(param1:INotification) : void
        {
            facade.registerProxy(new PlayerEquip_MsgSendProxy());
            facade.registerProxy(new PlayerEquip_MsgReceivedProxy());
            facade.registerMediator(new PlayerEquip_PlayerEquipMediator(new PlayerEquipPanel()));
            return;
        }

    }
}
