package tools.modules.vipcareer.model
{
	import org.osflash.thunderbolt.Logger;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tools.managers.NetWorkManager;
	import tools.modules.vipcareer.VipCareer_ApplicationFacade;
	import tools.net.NProtocol;
	import tools.observer.Notification;

    public class VipCareer_MsgReceivedProxy extends Proxy
    {
        private var _msgSenderProxy:VipCareer_MsgSendProxy;
        public static const NAME:String = "VipCareer_MsgReceivedProxy";

        public function VipCareer_MsgReceivedProxy()
        {
            super(NAME, null);
            return;
        }

        override public function onRegister() : void
        {
            NetWorkManager.registerMsgs([20093], this.receivedMsgHandle, NAME);
            return;
        }

        override public function onRemove() : void
        {
            NetWorkManager.removeMsgs([20093], NAME);
            return;
        }

        private function get msgSenderProxy() : VipCareer_MsgSendProxy
        {
            if (this._msgSenderProxy == null)
            {
                this._msgSenderProxy = facade.retrieveProxy(VipCareer_MsgSendProxy.NAME) as VipCareer_MsgSendProxy;
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
		
		public function received_20093($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(VipCareer_ApplicationFacade.VIP_CAREER_RESP,data);
		}

       

    }
}
