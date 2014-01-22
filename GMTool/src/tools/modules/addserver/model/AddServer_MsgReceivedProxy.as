package tools.modules.addserver.model
{
	import flash.utils.ByteArray;
	
	import org.osflash.thunderbolt.Logger;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tools.managers.NetWorkManager;
	import tools.modules.addserver.AddServer_ApplicationFacade;
	import tools.net.NProtocol;
	import tools.observer.Notification;

    public class AddServer_MsgReceivedProxy extends Proxy
    {
        private var _msgSenderProxy:AddServer_MsgSendProxy;
        public static const NAME:String = "AddServer_MsgReceivedProxy";

        public function AddServer_MsgReceivedProxy()
        {
            super(NAME, null);
            return;
        }

        override public function onRegister() : void
        {
            NetWorkManager.registerMsgs([20068,20070,20072,20074], this.receivedMsgHandle, NAME);
            return;
        }

        override public function onRemove() : void
        {
            NetWorkManager.removeMsgs([20068,20070,20072,20074], NAME);
            return;
        }

        private function get msgSenderProxy() : AddServer_MsgSendProxy
        {
            if (this._msgSenderProxy == null)
            {
                this._msgSenderProxy = facade.retrieveProxy(AddServer_MsgSendProxy.NAME) as AddServer_MsgSendProxy;
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
		public function received_20068($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(AddServer_ApplicationFacade.RESP_CHOOSE_SERVER,data);
		}

		
		public function received_20070($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(AddServer_ApplicationFacade.RESP_ADD_SERVER,data);
		}
		
		public function received_20072($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(AddServer_ApplicationFacade.CHANGE_SERVER_LIST,data);
		}
		
		public function received_20074(data:Object):void
		{
			sendNotification(AddServer_ApplicationFacade.RESP_SERVER_LIST, data);
		}
       

    }
}
