package tools.modules.playerequip.model
{
    import org.osflash.thunderbolt.Logger;
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    import tools.managers.NetWorkManager;
    import tools.modules.playerequip.PlayerEquip_ApplicationFacade;
    import tools.modules.playerequip.view.PlayerEquip_PlayerEquipMediator;
    import tools.net.NProtocol;
    import tools.observer.Notification;

    public class PlayerEquip_MsgReceivedProxy extends Proxy
    {
        private var _msgSenderProxy:PlayerEquip_MsgSendProxy;
        public static const NAME:String = "PlayerEquip_MsgReceivedProxy";

        public function PlayerEquip_MsgReceivedProxy()
        {
            super(NAME, null);
            return;
        }

        override public function onRegister() : void
        {
			NetWorkManager.registerMsgs([20010], this.receivedMsgHandle, NAME);
            return;
        }

        override public function onRemove() : void
        {
			NetWorkManager.removeMsgs([20010], NAME);
			return;
        }

        private function get msgSenderProxy() : PlayerEquip_MsgSendProxy
        {
            if (this._msgSenderProxy == null)
            {
                this._msgSenderProxy = facade.retrieveProxy(PlayerEquip_MsgSendProxy.NAME) as PlayerEquip_MsgSendProxy;
            }
            return this._msgSenderProxy;
        }

        private function receivedMsgHandle(param1:Notification) : void
        {
            var _loc_2:* = param1.name;
            var _loc_3:* = param1.body as NProtocol;
            if (this.hasOwnProperty("received_" + _loc_2))
            {
                this["received_" + _loc_2](_loc_3);
            }
            else
            {
                 Logger.info(Language.AGREE_NUM + _loc_2 + Language.NO_CUNZAI);
            }
            return;
        }
		public function received_20010($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(PlayerEquip_ApplicationFacade.RESE_EQUIP,data);
		}
       

    }
}
