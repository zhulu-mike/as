package tools.modules.mainui.model
{
    import org.osflash.thunderbolt.Logger;
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    import tools.managers.NetWorkManager;
    import tools.modules.mainui.MainUI_ApplicationFacade;
    import tools.net.NProtocol;
    import tools.observer.Notification;

    public class MainUI_MsgReceivedProxy extends Proxy
    {
        private var _msgSenderProxy:MainUI_MsgSendProxy;
        public static const NAME:String = "MainUI_MsgReceivedProxy";

        public function MainUI_MsgReceivedProxy()
        {
            super(NAME, null);
            return;
        }

        override public function onRegister() : void
        {
            NetWorkManager.registerMsgs([20040,20068,20099], this.receivedMsgHandle, NAME);
            return;
        }

        override public function onRemove() : void
        {
            NetWorkManager.removeMsgs([20040,20068,20099], NAME);
            return;
        }

        private function get msgSenderProxy() : MainUI_MsgSendProxy
        {
            if (this._msgSenderProxy == null)
            {
                this._msgSenderProxy = facade.retrieveProxy(MainUI_MsgSendProxy.NAME) as MainUI_MsgSendProxy;
            }
            return this._msgSenderProxy;
        }

        private function receivedMsgHandle(param1:Notification) : void
        {
            var _loc_2:* = param1.name;
            var _loc_3:NProtocol = param1.body as NProtocol;
            if (this.hasOwnProperty("received_" + _loc_2))
            {
                this["received_" + _loc_2](_loc_3.body);
            }
            else
            {
                 Logger.info(Language.AGREE_NUM + _loc_2 + Language.NO_CUNZAI);
            }
            return;
        }

		public function received_20040(data:Object):void
		{
			sendNotification(MainUI_ApplicationFacade.SERVER_RESP, data);
		}
		
		public function received_20068(data:Object):void
		{
			sendNotification(MainUI_ApplicationFacade.RESP_SERVER_LIST, data);
		}
		
		public function received_20099(data:Object):void
		{
			sendNotification(MainUI_ApplicationFacade.KICK_OUT_REFRESH, data);
		}

    }
}
