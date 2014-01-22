package tools.modules.user.model
{
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    import tools.managers.NetWorkManager;

    public class User_MsgSendProxy extends Proxy
    {
        public static const NAME:String = "User_MsgSendProxy";

        public function User_MsgSendProxy(param1:String = null, param2:Object = null)
        {
            super(NAME);
            return;
        }
		
		/**
		 * 注册时间 
		 * @param begintime
		 * @param endtime
		 * 
		 */
		public function send_20005(begintime:int, endtime:int, page:int,  linenumber:int) : void
		{
			NetWorkManager.sendMsgData(20005, {begintime:begintime, endtime:endtime, page:page, linenumber:linenumber});
			return;
		}

    }
}
