package tools.modules.application.model
{
	import flash.utils.ByteArray;
	
	import org.osflash.thunderbolt.Logger;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tools.managers.NetWorkManager;
	import tools.modules.application.Application_ApplicationFacade;
	import tools.net.NProtocol;
	import tools.observer.Notification;

    public class Application_MsgReceivedProxy extends Proxy
    {
        private var _msgSenderProxy:Application_MsgSendProxy;
        public static const NAME:String = "Application_MsgReceivedProxy";

        public function Application_MsgReceivedProxy()
        {
            super(NAME, null);
            return;
        }

        override public function onRegister() : void
        {
            NetWorkManager.registerMsgs([20044,20042,20060], this.receivedMsgHandle, NAME);
            return;
        }

        override public function onRemove() : void
        {
            NetWorkManager.removeMsgs([20044,20042,20060], NAME);
            return;
        }

        private function get msgSenderProxy() : Application_MsgSendProxy
        {
            if (this._msgSenderProxy == null)
            {
                this._msgSenderProxy = facade.retrieveProxy(Application_MsgSendProxy.NAME) as Application_MsgSendProxy;
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
		
		public function received_20044($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(Application_ApplicationFacade.RESE_EQUIP,data);
		}
		
		public function received_20042($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(Application_ApplicationFacade.AGREE_APP,data);
		}
		
		public function received_20060($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(Application_ApplicationFacade.DISAGREE_APP,data);
		}

       

    }
}
