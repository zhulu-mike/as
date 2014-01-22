package tools.modules.chargerank.model
{
	import org.osflash.thunderbolt.Logger;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tools.managers.NetWorkManager;
	import tools.modules.chargerank.ChargeRank_ApplicationFacade;
	import tools.net.NProtocol;
	import tools.observer.Notification;

    public class ChargeRank_MsgReceivedProxy extends Proxy
    {
        private var _msgSenderProxy:ChargeRank_MsgSendProxy;
        public static const NAME:String = "ChargeRank_MsgReceivedProxy";

        public function ChargeRank_MsgReceivedProxy()
        {
            super(NAME, null);
            return;
        }

        override public function onRegister() : void
        {
            NetWorkManager.registerMsgs([20087], this.receivedMsgHandle, NAME);
            return;
        }

        override public function onRemove() : void
        {
            NetWorkManager.removeMsgs([20087], NAME);
            return;
        }

        private function get msgSenderProxy() : ChargeRank_MsgSendProxy
        {
            if (this._msgSenderProxy == null)
            {
                this._msgSenderProxy = facade.retrieveProxy(ChargeRank_MsgSendProxy.NAME) as ChargeRank_MsgSendProxy;
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
		
		public function received_20087($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(ChargeRank_ApplicationFacade.CHARGE_RANK_RESP,data);
		}

       

    }
}
