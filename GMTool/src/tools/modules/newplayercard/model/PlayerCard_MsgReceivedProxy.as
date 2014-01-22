package tools.modules.newplayercard.model
{
	
	import org.osflash.thunderbolt.Logger;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tools.managers.NetWorkManager;
	import tools.modules.newplayercard.PlayerCard_ApplicationFacade;
	import tools.net.NProtocol;
	import tools.observer.Notification;

    public class PlayerCard_MsgReceivedProxy extends Proxy
    {
        private var _msgSenderProxy:PlayerCard_MsgSendProxy;
        public static const NAME:String = "PlayerCard_MsgReceivedProxy";

        public function PlayerCard_MsgReceivedProxy()
        {
            super(NAME, null);
            return;
        }

        override public function onRegister() : void
        {
            NetWorkManager.registerMsgs([20052,20056,20058], this.receivedMsgHandle, NAME);
            return;
        }

        override public function onRemove() : void
        {
            NetWorkManager.removeMsgs([20052,20056,20058], NAME);
            return;
        }

        private function get msgSenderProxy() : PlayerCard_MsgSendProxy
        {
            if (this._msgSenderProxy == null)
            {
                this._msgSenderProxy = facade.retrieveProxy(PlayerCard_MsgSendProxy.NAME) as PlayerCard_MsgSendProxy;
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

		public function received_20052($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(PlayerCard_ApplicationFacade.MAKE_CARD_NUM,data);
		}
		
		public function received_20056($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(PlayerCard_ApplicationFacade.CHECK_NEWCARD_TYPE,data);
		}
		
		public function received_20058($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(PlayerCard_ApplicationFacade.RESP_CHECK_INFO,data);
		}
       

    }
}
