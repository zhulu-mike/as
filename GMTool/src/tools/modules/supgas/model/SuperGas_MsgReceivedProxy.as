package tools.modules.supgas.model
{
	import org.osflash.thunderbolt.Logger;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tools.managers.NetWorkManager;
	import tools.modules.supgas.SuperGas_ApplicationFacade;
	import tools.net.NProtocol;
	import tools.observer.Notification;


    public class SuperGas_MsgReceivedProxy extends Proxy
    {
        private var _msgSenderProxy:SuperGas_MsgSendProxy;
        public static const NAME:String = "SuperGas_MsgReceivedProxy";

        public function SuperGas_MsgReceivedProxy()
        {
            super(NAME, null);
            return;
        }

        override public function onRegister() : void
        {
            NetWorkManager.registerMsgs([20016], this.receivedMsgHandle, NAME);
            return;
        }

        override public function onRemove() : void
        {
            NetWorkManager.removeMsgs([20016], NAME);
            return;
        }

        private function get msgSenderProxy() : SuperGas_MsgSendProxy
        {
            if (this._msgSenderProxy == null)
            {
                this._msgSenderProxy = facade.retrieveProxy(SuperGas_MsgSendProxy.NAME) as SuperGas_MsgSendProxy;
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
		public function received_20016($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(SuperGas_ApplicationFacade.RESE_SUPER_GAS,data);
		}
		
       

    }
}
