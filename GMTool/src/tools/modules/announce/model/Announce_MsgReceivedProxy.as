package tools.modules.announce.model
{
	import org.osflash.thunderbolt.Logger;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tools.managers.NetWorkManager;
	import tools.modules.announce.Announce_ApplicationFacade;
	import tools.net.NProtocol;
	import tools.observer.Notification;

    public class Announce_MsgReceivedProxy extends Proxy
    {
        private var _msgSenderProxy:Announce_MsgSendProxy;
        public static const NAME:String = "Announce_MsgReceivedProxy";

        public function Announce_MsgReceivedProxy()
        {
            super(NAME, null);
            return;
        }

        override public function onRegister() : void
        {
            NetWorkManager.registerMsgs([33013,20085,20089], this.receivedMsgHandle, NAME);
            return;
        }

        override public function onRemove() : void
        {
            NetWorkManager.removeMsgs([33013,20085,20089], NAME);
            return;
        }

        private function get msgSenderProxy() : Announce_MsgSendProxy
        {
            if (this._msgSenderProxy == null)
            {
                this._msgSenderProxy = facade.retrieveProxy(Announce_MsgSendProxy.NAME) as Announce_MsgSendProxy;
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

		public function received_33013($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(Announce_ApplicationFacade.CREAT_ANNOUNCE,data);
		}
		
		public function received_20085($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(Announce_ApplicationFacade.ANNOUNCE_RESP,data);
		}
		
		public function received_20089($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(Announce_ApplicationFacade.DELETE_ANNOUNCE,data);
		}
       
    }
}
