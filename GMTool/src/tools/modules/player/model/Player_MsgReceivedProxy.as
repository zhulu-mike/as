package tools.modules.player.model
{
	import flash.utils.ByteArray;
	
	import org.osflash.thunderbolt.Logger;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tools.managers.NetWorkManager;
	import tools.modules.player.Player_ApplicationFacade;
	import tools.modules.player.view.Player_PlayerMediator;
	import tools.net.NProtocol;
	import tools.observer.Notification;

    public class Player_MsgReceivedProxy extends Proxy
    {
        private var _msgSenderProxy:Player_MsgSendProxy;
        public static const NAME:String = "Player_MsgReceivedProxy";

        public function Player_MsgReceivedProxy()
        {
            super(NAME, null);
            return;
        }

        override public function onRegister() : void
        {
            NetWorkManager.registerMsgs([20008,20012,20018,20078,20080,33005,33007,33009], this.receivedMsgHandle, NAME);
            return;
        }

        override public function onRemove() : void
        {
            NetWorkManager.removeMsgs([20008,20012,20018,20078,20080,33005,33007,33009], NAME);
            return;
        }

        private function get msgSenderProxy() : Player_MsgSendProxy
        {
            if (this._msgSenderProxy == null)
            {
                this._msgSenderProxy = facade.retrieveProxy(Player_MsgSendProxy.NAME) as Player_MsgSendProxy;
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
		
		public function received_20008($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(Player_ApplicationFacade.RESEARCH,data);
		}
		
		public function received_20012($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(Player_ApplicationFacade.PACKAGE_RESEARCH,data);
		}
		
		public function received_20018($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(Player_ApplicationFacade.SKILL_RESEARCH,data);
		}
		
		public function received_20078($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(Player_ApplicationFacade.FORBID_PASSPOET,data);
		}
		
		public function received_20080($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(Player_ApplicationFacade.UNFORBID_PASSPOET,data);
		}
		
		public function received_33005($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(Player_ApplicationFacade.NO_PRESSION_CLICK_PEOPLE,data);
		}
		
		public function received_33007($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(Player_ApplicationFacade.CLICK_PEOPLE,data);
		}
		
		public function received_33009($pro:NProtocol) : void
		{
			var data:Object = $pro.body;
			sendNotification(Player_ApplicationFacade.FORBID_SPEAK,data);
		}
		

    }
}
