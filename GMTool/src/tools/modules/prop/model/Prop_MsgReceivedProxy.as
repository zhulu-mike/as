package tools.modules.prop.model
{
	import flash.utils.ByteArray;
	
	import org.osflash.thunderbolt.Logger;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tools.managers.NetWorkManager;
	import tools.modules.prop.Prop_ApplicationFacade;
	import tools.net.NProtocol;
	import tools.observer.Notification;

    public class Prop_MsgReceivedProxy extends Proxy
    {
        private var _msgSenderProxy:Prop_MsgSendProxy;
        public static const NAME:String = "Prop_MsgReceivedProxy";

        public function Prop_MsgReceivedProxy()
        {
            super(NAME, null);
            return;
        }

        override public function onRegister() : void
        {
            NetWorkManager.registerMsgs([20036], this.receivedMsgHandle, NAME);
            return;
        }

        override public function onRemove() : void
        {
            NetWorkManager.removeMsgs([20036], NAME);
            return;
        }

        private function get msgSenderProxy() : Prop_MsgSendProxy
        {
            if (this._msgSenderProxy == null)
            {
                this._msgSenderProxy = facade.retrieveProxy(Prop_MsgSendProxy.NAME) as Prop_MsgSendProxy;
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
			sendNotification(Prop_ApplicationFacade.PROP_RESEARCH,data);
		}
		

       

    }
}
