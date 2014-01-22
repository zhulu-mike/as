package tools.modules.user.model
{
    import org.osflash.thunderbolt.Logger;
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    import tools.managers.NetWorkManager;
    import tools.modules.user.User_ApplicationFacade;
    import tools.net.NProtocol;
    import tools.observer.Notification;

    public class User_MsgReceivedProxy extends Proxy
    {
        private var _msgSenderProxy:User_MsgSendProxy;
        public static const NAME:String = "User_MsgReceivedProxy";

        public function User_MsgReceivedProxy()
        {
            super(NAME, null);
            return;
        }

        override public function onRegister() : void
        {
            NetWorkManager.registerMsgs([20006], this.receivedMsgHandle, NAME);
            return;
        }

        override public function onRemove() : void
        {
            NetWorkManager.removeMsgs([20006], NAME);
            return;
        }

        private function get msgSenderProxy() : User_MsgSendProxy
        {
            if (this._msgSenderProxy == null)
            {
                this._msgSenderProxy = facade.retrieveProxy(User_MsgSendProxy.NAME) as User_MsgSendProxy;
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
		
		public function received_20006($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(User_ApplicationFacade.RESEARCH,data);
		}
		
       
    }
}
