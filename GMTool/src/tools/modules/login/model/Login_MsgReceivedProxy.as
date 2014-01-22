package tools.modules.login.model
{
    import mx.controls.Alert;
    
    import org.osflash.thunderbolt.Logger;
    import org.puremvc.as3.multicore.patterns.proxy.*;
    
    import tools.events.PipeEvent;
    import tools.managers.LayerManager;
    import tools.managers.NetWorkManager;
    import tools.managers.PipeManager;
    import tools.managers.ResizeManager;
    import tools.modules.login.Login_ApplicationFacade;
    import tools.modules.login.view.Login_LoginMediator;
    import tools.net.NProtocol;
    import tools.observer.Notification;

    public class Login_MsgReceivedProxy extends Proxy
    {
        private var _loginSocketProxy:Login_LoginSocketManager;
        private var _msgSenderProxy:Login_MsgSenderProxy;
        private var _login_Mediator:Login_LoginMediator;
        public static const NAME:String = "Login_MsgReceivedProxy";

        public function Login_MsgReceivedProxy()
        {
            super(NAME, null);
            return;
        }

        private function get loginSocketProxy() : Login_LoginSocketManager
        {
            if (this._loginSocketProxy == null)
            {
                this._loginSocketProxy = facade.retrieveProxy(Login_LoginSocketManager.NAME) as Login_LoginSocketManager;
            }
            return this._loginSocketProxy;
        }

        private function get msgSenderProxy() : Login_MsgSenderProxy
        {
            if (this._msgSenderProxy == null)
            {
                this._msgSenderProxy = facade.retrieveProxy(Login_MsgSenderProxy.NAME) as Login_MsgSenderProxy;
            }
            return this._msgSenderProxy;
        }

        override public function onRegister() : void
        {
            NetWorkManager.registerMsgs([20002], this.receivedMsgHandle, NAME);
            return;
        }

        override public function onRemove() : void
        {
            NetWorkManager.removeMsgs([20002], NAME);
            return;
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

        public function received_20002($pro:NProtocol) : void
        {
				//保存数据
				var data:Object = $pro.body;
				if (data.ret != 0)
				{
					if (data.ret == 2001)
					{
						//失败提示
						Alert.show(Language.REG_USERNAME_NULL);
					}
					else if(data.ret == 2002)
					{
						Alert.show(Language.REG_PSW_NULL);
					}
					else if(data.ret == 2003)
					{
						Alert.show(Language.LOGIN_PSW_WRONG);
					}
					else if(data.ret == 2004)
					{
						Alert.show(Language.LOGIN_USERNAME_NULL);
					}
					else if(data.ret == 2005)
					{
						Alert.show(Language.LOGIN_PSW_NULL);
					}
					else if(data.ret == 2006)
					{
						Alert.show(Language.REG_FAULER);
					}
					else if(data.ret == 2007)
					{
						Alert.show(Language.LOGIN_USERNAME_NOT);
					}else{
						Alert.show(Language.LOGIN_FAULER);
					}
					return;
				}
				Global.mainVO.permission = data.permission;
				Global.mainVO.platid = data.platid;
				Global.mainVO.registertime = data.registertime;
				Global.mainVO.userName=data.passport;
				Global.mainVO.group=data.level;
				Global.mainVO.lastLogintTime=data.last_time;
				Global.mainVO.plantObj=data.v_info;//获得平台obj
				//只有平台
				var arr:Array=data.v_info;
				for (var i:int = 0; i < arr.length; i++) 
				{
					var obj:Object=new Object();
					obj.label=arr[i].plat_name;
					obj.data=arr[i].plat_id;
					Global.mainVO.platChosArr.push(obj);
					Global.mainVO.serPlatChosArr.push(obj);
				}
				//
				for (var j:int = 0; j < arr.length; j++) 
				{
					var obj1:Object=new Object();
					obj1.label=arr[j].plat_name;
					obj1.data=arr[j].plat_id;
					Global.mainVO.platChosArrA.push(obj1);
				}
				Global.mainVO.platChosArrA.splice(0,0,{label:Language.ALL,data:Global.mainVO.platChosArrA.length+1})
//				Global.mainVO.regip = data.regip;
				Global.mainVO.userid = data.userid;
				sendNotification(Login_ApplicationFacade.LOGIN_SUCCESS);
				
        }

        private function get login_Mediator() : Login_LoginMediator
        {
            if (!this._login_Mediator)
            {
                this._login_Mediator = facade.retrieveMediator(Login_LoginMediator.NAME) as Login_LoginMediator;
            }
            return this._login_Mediator;
        }
		

    }
}
