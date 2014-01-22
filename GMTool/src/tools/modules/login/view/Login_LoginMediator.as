package tools.modules.login.view
{
    import flash.events.MouseEvent;
    
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    
    import tools.events.PipeEvent;
    import tools.managers.LayerManager;
    import tools.managers.PipeManager;
    import tools.managers.ResizeManager;
    import tools.modules.login.Login_ApplicationFacade;
    import tools.modules.login.model.Login_MsgSenderProxy;
    import tools.modules.login.view.components.LoginPanel;

    public class Login_LoginMediator extends Mediator
    {
        private var roleArr:Array;
        private var avatar_zizeng:int = 0;
        private var _msgSenderProxy:Login_MsgSenderProxy;
        public static const NAME:String = "Login_LoginMediator";

        public function Login_LoginMediator(param1:Object = null)
        {
            super(NAME, param1);
			initUI();
			showMain();
            return;
        }
		
		protected function get mainUI():LoginPanel
		{
			return viewComponent as LoginPanel;
		}

        override public function onRegister() : void
        {
            return;
        }

        override public function onRemove() : void
        {
            return;
        }


        private function get msgSenderProxy() : Login_MsgSenderProxy
        {
            if (this._msgSenderProxy == null)
            {
                this._msgSenderProxy = facade.retrieveProxy(Login_MsgSenderProxy.NAME) as Login_MsgSenderProxy;
            }
            return this._msgSenderProxy;
        }

        override public function listNotificationInterests() : Array
        {
            return [Login_ApplicationFacade.LOGIN_SUCCESS];
        }

        override public function handleNotification(param1:INotification) : void
        {
			var data:Object = param1.getBody();
			switch(param1.getName())
			{
				case Login_ApplicationFacade.LOGIN_SUCCESS:
				{
					LayerManager.uiLayer.removeElement(mainUI);
					ResizeManager.unRegisterResize(mainUI);
					PipeManager.sendMsg(PipeEvent.STARTUP_MAINUI);
					PipeManager.sendMsg(PipeEvent.SHOW_MAINUI);
					break;
				}
				default:
				{
					break;
				}
			}
			return;
        }
		
		public function showMain():void
		{
			LayerManager.uiLayer.addElement(mainUI);
		}
		
		private function initUI():void
		{
			ResizeManager.registerResize(mainUI);
			mainUI.loginBtn.addEventListener(MouseEvent.CLICK, login);
		}

        private function login(param1:MouseEvent) : void
        {
			var user:String = mainUI.userTxt.text;
			var psd:String  = mainUI.psdTxt.text;
//			sendNotification(Login_ApplicationFacade.LOGIN_CONNECT, {id:user, psd:psd});
			sendNotification(Login_ApplicationFacade.LOGIN_SUCCESS);
			return;
		}


    }
}
