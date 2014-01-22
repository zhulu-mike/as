package tools.modules.useronline.model
{
	import org.osflash.thunderbolt.Logger;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tools.managers.NetWorkManager;
	import tools.modules.useronline.UserOnline_ApplicationFacade;
	import tools.net.NProtocol;
	import tools.observer.Notification;

    public class UserOnline_MsgReceivedProxy extends Proxy
    {
        private var _msgSenderProxy:UserOnline_MsgSendProxy;
        public static const NAME:String = "UserOnline_MsgReceivedProxy";

        public function UserOnline_MsgReceivedProxy()
        {
            super(NAME, null);
            return;
        }

        override public function onRegister() : void
        {
            NetWorkManager.registerMsgs([33005,20097], this.receivedMsgHandle, NAME);
            return;
        }

        override public function onRemove() : void
        {
            NetWorkManager.removeMsgs([33005,20097], NAME);
            return;
        }

        private function get msgSenderProxy() : UserOnline_MsgSendProxy
        {
            if (this._msgSenderProxy == null)
            {
                this._msgSenderProxy = facade.retrieveProxy(UserOnline_MsgSendProxy.NAME) as UserOnline_MsgSendProxy;
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

		public function received_33005($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(UserOnline_ApplicationFacade.SHOW_ONLINE_NUM,data);
		}
		
		public function received_20097($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(UserOnline_ApplicationFacade.SHOW_ONLINE_ALL_NUM,data);
		}
       

    }
}
