package tools.modules.charge.model
{
    import org.osflash.thunderbolt.Logger;
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    import tools.managers.NetWorkManager;
    import tools.modules.charge.Charge_ApplicationFacade;
    import tools.net.NProtocol;
    import tools.observer.Notification;

    public class Charge_MsgReceivedProxy extends Proxy
    {
        private var _msgSenderProxy:Charge_MsgSendProxy;
        public static const NAME:String = "Charge_MsgReceivedProxy";

        public function Charge_MsgReceivedProxy()
        {
            super(NAME, null);
            return;
        }

        override public function onRegister() : void
        {
            NetWorkManager.registerMsgs([20064], this.receivedMsgHandle, NAME);
            return;
        }

        override public function onRemove() : void
        {
            NetWorkManager.removeMsgs([20064], NAME);
            return;
        }

        private function get msgSenderProxy() : Charge_MsgSendProxy
        {
            if (this._msgSenderProxy == null)
            {
                this._msgSenderProxy = facade.retrieveProxy(Charge_MsgSendProxy.NAME) as Charge_MsgSendProxy;
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

		
		public function received_20064($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(Charge_ApplicationFacade.RESP_CHARGE_NUMBER,data);
		}

    }
}
