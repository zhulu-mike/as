package tools.modules.fightspirit.model
{
	import flash.utils.ByteArray;
	
	import org.osflash.thunderbolt.Logger;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tools.managers.NetWorkManager;
	import tools.modules.fightspirit.FightSpirit_ApplicationFacade;
	import tools.net.NProtocol;
	import tools.observer.Notification;

    public class FightSpirit_MsgReceivedProxy extends Proxy
    {
        private var _msgSenderProxy:FightSpirit_MsgSendProxy;
        public static const NAME:String = "FightSpirit_MsgReceivedProxy";

        public function FightSpirit_MsgReceivedProxy()
        {
            super(NAME, null);
            return;
        }

        override public function onRegister() : void
        {
            NetWorkManager.registerMsgs([20020], this.receivedMsgHandle, NAME);
            return;
        }

        override public function onRemove() : void
        {
            NetWorkManager.removeMsgs([20020], NAME);
            return;
        }

        private function get msgSenderProxy() : FightSpirit_MsgSendProxy
        {
            if (this._msgSenderProxy == null)
            {
                this._msgSenderProxy = facade.retrieveProxy(FightSpirit_MsgSendProxy.NAME) as FightSpirit_MsgSendProxy;
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
		
		public function received_20020($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(FightSpirit_ApplicationFacade.RESQ_FIGHT,data);
		}

       

    }
}
