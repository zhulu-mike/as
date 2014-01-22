package tools.modules.playerlevel.model
{
	import org.osflash.thunderbolt.Logger;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tools.managers.NetWorkManager;
	import tools.modules.announce.Announce_ApplicationFacade;
	import tools.modules.playerlevel.PlayerLevel_ApplicationFacade;
	import tools.net.NProtocol;
	import tools.observer.Notification;

    public class PlayerLevel_MsgReceivedProxy extends Proxy
    {
        private var _msgSenderProxy:PlayerLevel_MsgSendProxy;
        public static const NAME:String = "PlayerLevel_MsgReceivedProxy";

        public function PlayerLevel_MsgReceivedProxy()
        {
            super(NAME, null);
            return;
        }

        override public function onRegister() : void
        {
            NetWorkManager.registerMsgs([20095], this.receivedMsgHandle, NAME);
            return;
        }

        override public function onRemove() : void
        {
            NetWorkManager.removeMsgs([20095], NAME);
            return;
        }

        private function get msgSenderProxy() : PlayerLevel_MsgSendProxy
        {
            if (this._msgSenderProxy == null)
            {
                this._msgSenderProxy = facade.retrieveProxy(PlayerLevel_MsgSendProxy.NAME) as PlayerLevel_MsgSendProxy;
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
                 Logger.info("协议号" + _loc_2 + "不存在");
            }
            return;
        }
		
		public function received_20095($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(PlayerLevel_ApplicationFacade.LAST_LOGIN_RESP,data);
		}

       

    }
}
