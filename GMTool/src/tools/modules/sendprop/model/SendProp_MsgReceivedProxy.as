package tools.modules.sendprop.model
{
	import flash.utils.ByteArray;
	
	import org.osflash.thunderbolt.Logger;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tools.managers.NetWorkManager;
	import tools.modules.sendprop.SendProp_ApplicationFacade;
	import tools.net.NProtocol;
	import tools.observer.Notification;


    public class SendProp_MsgReceivedProxy extends Proxy
    {
        private var _msgSenderProxy:SendProp_MsgSendProxy;
        public static const NAME:String = "SendProp_MsgReceivedProxy";

        public function SendProp_MsgReceivedProxy()
        {
            super(NAME, null);
            return;
        }

        override public function onRegister() : void
        {
            NetWorkManager.registerMsgs([20036], this.receivedMsgHandle, NAME);
			NetWorkManager.registerMsgs([20038], this.receivedMsgHandle, NAME);
			NetWorkManager.registerMsgs([20046], this.receivedMsgHandle, NAME);
			NetWorkManager.registerMsgs([20048], this.receivedMsgHandle, NAME);
			NetWorkManager.registerMsgs([20050], this.receivedMsgHandle, NAME);
			NetWorkManager.registerMsgs([20068], this.receivedMsgHandle, NAME);
            return;
        }

        override public function onRemove() : void
        {
            NetWorkManager.removeMsgs([20036], NAME);
			NetWorkManager.removeMsgs([20038], NAME);
			NetWorkManager.removeMsgs([20046], NAME);
			NetWorkManager.removeMsgs([20048], NAME);
			NetWorkManager.removeMsgs([20050], NAME);
			NetWorkManager.removeMsgs([20068], NAME);
            return;
        }

        private function get msgSenderProxy() : SendProp_MsgSendProxy
        {
            if (this._msgSenderProxy == null)
            {
                this._msgSenderProxy = facade.retrieveProxy(SendProp_MsgSendProxy.NAME) as SendProp_MsgSendProxy;
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
		
		public function received_20036($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(SendProp_ApplicationFacade.PROP_RESEARCH,data);
		}
		
		public function received_20038($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(SendProp_ApplicationFacade.SEND_RESEARCH,data);
		}
		
		public function received_20046($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(SendProp_ApplicationFacade.APP_LIST_RES,data);
		}
		
		public function received_20048($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(SendProp_ApplicationFacade.DELETE_APP,data);
		}
		
		public function received_20050($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(SendProp_ApplicationFacade.LOOK_MINE_APP,data);
		}
		
		public function received_20068($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(SendProp_ApplicationFacade.SERVER_RESP,data);
		}

       

    }
}
