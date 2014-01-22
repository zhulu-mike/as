package tools.modules.chargecount.model
{
	import org.osflash.thunderbolt.Logger;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tools.managers.NetWorkManager;
	import tools.modules.chargecount.ChargeCount_ApplicationFacade;
	import tools.net.NProtocol;
	import tools.observer.Notification;

    public class ChargeCount_MsgReceivedProxy extends Proxy
    {
        private var _msgSenderProxy:ChargeCount_MsgSendProxy;
        public static const NAME:String = "ChargeCount_MsgReceivedProxy";

        public function ChargeCount_MsgReceivedProxy()
        {
            super(NAME, null);
            return;
        }

        override public function onRegister() : void
        {
            NetWorkManager.registerMsgs([20091], this.receivedMsgHandle, NAME);
            return;
        }

        override public function onRemove() : void
        {
            NetWorkManager.removeMsgs([20091], NAME);
            return;
        }

        private function get msgSenderProxy() : ChargeCount_MsgSendProxy
        {
            if (this._msgSenderProxy == null)
            {
                this._msgSenderProxy = facade.retrieveProxy(ChargeCount_MsgSendProxy.NAME) as ChargeCount_MsgSendProxy;
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
		
		public function received_20091($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(ChargeCount_ApplicationFacade.CHECK_CHARGE_RESP,data);
		}

       

    }
}
