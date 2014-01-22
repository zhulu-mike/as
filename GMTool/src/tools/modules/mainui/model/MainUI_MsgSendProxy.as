package tools.modules.mainui.model
{
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    import tools.managers.NetWorkManager;

    public class MainUI_MsgSendProxy extends Proxy
    {
        public static const NAME:String = "MainUI_MsgSendProxy";

        public function MainUI_MsgSendProxy(param1:String = null, param2:Object = null)
        {
            super(NAME);
            return;
        }

		/**
		 * 请求服务器更改数据库
		 * @param id
		 * 
		 */		
		public function send_20039(id:int):void
		{
			NetWorkManager.sendMsgData(20039, {id:id});
		}
		
		public function send_20067(platid:int):void
		{
			NetWorkManager.sendMsgData(20067, {platid:platid});
		}
    }
}
