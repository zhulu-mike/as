package tools.modules.load.model
{
    import org.osflash.thunderbolt.Logger;
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    import tools.managers.NetWorkManager;
    import tools.net.NProtocol;
    import tools.observer.Notification;

    public class LoadRes_MsgReceivedProxy extends Proxy
    {
        private var _msgSenderProxy:LoadRes_MsgSendProxy;
        public static const NAME:String = "LoadRes_MsgReceivedProxy";

        public function LoadRes_MsgReceivedProxy()
        {
            super(NAME, null);
            return;
        }

        override public function onRegister() : void
        {
            NetWorkManager.registerMsgs([], this.receivedMsgHandle, NAME);
            return;
        }

        override public function onRemove() : void
        {
            NetWorkManager.removeMsgs([], NAME);
            return;
        }

        private function get msgSenderProxy() : LoadRes_MsgSendProxy
        {
            if (this._msgSenderProxy == null)
            {
                this._msgSenderProxy = facade.retrieveProxy(LoadRes_MsgSendProxy.NAME) as LoadRes_MsgSendProxy;
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

       

    }
}
