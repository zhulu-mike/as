﻿package game.modules.mainui.view
{
	import game.modules.mainui.model.MainUI_MsgSendProxy;

    public class MainUI_MainUIMediator extends Mediator
    {
        private var _msgSenderProxy:MainUI_MsgSendProxy;
        public static const NAME:String = "MainUI_MainUIMediator";

        public function MainUI_MainUIMediator(viewComponent:MainUI ) 
	{
		super( NAME, viewComponent );
	}

        protected function get mainUI() : MainUI
        {
            return viewComponent as MainUI;
        }

        override public function onRegister() : void
        {
            return;
        }

        override public function listNotificationInterests() : Array
        {
            return [];
        }

        override public function handleNotification(param1:INotification) : void
        {
            switch(param1.getName())
            {
                default:
                {
                    break;
                }
            }
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

    }
}
