package tools.modules.checkcard.model
{
	import org.osflash.thunderbolt.Logger;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tools.managers.NetWorkManager;
	import tools.modules.checkcard.CheckCardType_ApplicationFacade;
	import tools.net.NProtocol;
	import tools.observer.Notification;

    public class CheckCardType_MsgReceivedProxy extends Proxy
    {
        private var _msgSenderProxy:CheckCardType_MsgSendProxy;
        public static const NAME:String = "CheckCardType_MsgReceivedProxy";

        public function CheckCardType_MsgReceivedProxy()
        {
            super(NAME, null);
            return;
        }

        override public function onRegister() : void
        {
            NetWorkManager.registerMsgs([20054,20056], this.receivedMsgHandle, NAME);
            return;
        }

        override public function onRemove() : void
        {
            NetWorkManager.removeMsgs([20054,20056], NAME);
            return;
        }

        private function get msgSenderProxy() : CheckCardType_MsgSendProxy
        {
            if (this._msgSenderProxy == null)
            {
                this._msgSenderProxy = facade.retrieveProxy(CheckCardType_MsgSendProxy.NAME) as CheckCardType_MsgSendProxy;
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
		
		public function received_20054($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(CheckCardType_ApplicationFacade.MAKE_NEWCARD_TYPE,data);
		}
		
		public function received_20056($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(CheckCardType_ApplicationFacade.CHECK_NEWCARD_TYPE,data);
		}

       

    }
}
