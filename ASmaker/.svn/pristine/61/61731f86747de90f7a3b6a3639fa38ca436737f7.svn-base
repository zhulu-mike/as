package game.modules.mainui.model
{
    import com.thinkido.framework.common.observer.Notification;
    import flash.utils.ByteArray;
    import game.manager.NetWorkManager;
    import org.osflash.thunderbolt.Logger;
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;

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
			//数字忽略
            NetWorkManager.registerMsgs([], this.receivedMsgHandle, NAME);
            return;
        }

        override public function onRemove() : void
        {
            NetWorkManager.removeMsgs([], NAME);
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
            var _loc_3:* = param1.body as ByteArray;
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

       

    }
}
