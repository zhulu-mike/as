package tools.modules.passport.model
{
	import flash.utils.ByteArray;
	
	import org.osflash.thunderbolt.Logger;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tools.managers.NetWorkManager;
	import tools.modules.passport.Passport_ApplicationFacade;
	import tools.net.NProtocol;
	import tools.observer.Notification;

    public class Passport_MsgReceivedProxy extends Proxy
    {
        private var _msgSenderProxy:Passport_MsgSendProxy;
        public static const NAME:String = "Passport_MsgReceivedProxy";

        public function Passport_MsgReceivedProxy()
        {
            super(NAME, null);
            return;
        }

        override public function onRegister() : void
        {
			NetWorkManager.registerMsgs([20004,20022,20024,20026,20028,20030,20032], this.receivedMsgHandle, NAME);
            return;
        }

        override public function onRemove() : void
        {
			NetWorkManager.removeMsgs([20004,20022,20024,20026,20028,20030,20032], NAME);
            return;
        }

        private function get msgSenderProxy() : Passport_MsgSendProxy
        {
            if (this._msgSenderProxy == null)
            {
                this._msgSenderProxy = facade.retrieveProxy(Passport_MsgSendProxy.NAME) as Passport_MsgSendProxy;
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
		public function received_20004($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(Passport_ApplicationFacade.RESP_LOGIN,data);
		}
		public function received_20022($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(Passport_ApplicationFacade.RESP_PASSPORT,data);
		}
		public function received_20024($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(Passport_ApplicationFacade.RESP_CREAT_PLAT,data);
		}
		public function received_20026($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(Passport_ApplicationFacade.RESP_MANAGER_PERIMSS,data);
		}
		public function received_20028($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(Passport_ApplicationFacade.RESP_MANAGER_PSW,data);
		}
		public function received_20030($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(Passport_ApplicationFacade.RESP_DELETE,data);
		}
		public function received_20032($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(Passport_ApplicationFacade.RESP_MODIFY_PLAT,data);
		}
       

    }
}
