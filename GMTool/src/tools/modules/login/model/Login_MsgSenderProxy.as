package tools.modules.login.model
{
    import org.osflash.thunderbolt.Logger;
    import org.puremvc.as3.multicore.patterns.proxy.*;
    
    import tools.managers.NetWorkManager;

    public class Login_MsgSenderProxy extends Proxy
    {
        public static const NAME:String = "Login_MsgSenderProxy";

        public function Login_MsgSenderProxy()
        {
            super(NAME, null);
            return;
        }

		/**
		 * 登陆
		 * @param passport 用户名
		 * @param pwd 密码
		 * 
		 */		
        public function send_20001(passport:String, pwd:String) : void
        {
            NetWorkManager.sendMsgData(20001, {passport:passport, pwd:pwd});
            return;
        }


        
    }
}
