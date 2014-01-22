package tools.modules.consum.model
{
	import flash.utils.ByteArray;
	
	import org.osflash.thunderbolt.Logger;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tools.managers.NetWorkManager;
	import tools.modules.consum.Consum_ApplicationFacade;
	import tools.net.NProtocol;
	import tools.observer.Notification;

    public class Consum_MsgReceivedProxy extends Proxy
    {
        private var _msgSenderProxy:Consum_MsgSendProxy;
        public static const NAME:String = "Consum_MsgReceivedProxy";

        public function Consum_MsgReceivedProxy()
        {
            super(NAME, null);
            return;
        }

        override public function onRegister() : void
        {
            NetWorkManager.registerMsgs([20066], this.receivedMsgHandle, NAME);
            return;
        }

        override public function onRemove() : void
        {
            NetWorkManager.removeMsgs([20066], NAME);
            return;
        }

        private function get msgSenderProxy() : Consum_MsgSendProxy
        {
            if (this._msgSenderProxy == null)
            {
                this._msgSenderProxy = facade.retrieveProxy(Consum_MsgSendProxy.NAME) as Consum_MsgSendProxy;
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
		
		public function received_20066($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(Consum_ApplicationFacade.CONSUM_RESP,data);
		}

       

    }
}
