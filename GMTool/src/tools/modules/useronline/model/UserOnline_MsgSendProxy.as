package tools.modules.useronline.model
{
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    import tools.managers.NetWorkManager;

    public class UserOnline_MsgSendProxy extends Proxy
    {
        public static const NAME:String = "UserOnline_MsgSendProxy";

        public function UserOnline_MsgSendProxy(param1:String = null, param2:Object = null)
        {
            super(NAME);
            return;
        }
		
		public function send_20061() : void
		{
			NetWorkManager.sendMsgData(20061, {});
			return;
		}
		
		public function send_20096(plat_id:int,server_id:int,begin_time:int,end_time:int) : void
		{
			NetWorkManager.sendMsgData(20096, {plat_id:plat_id,server_id:server_id,begin_time:begin_time,end_time:end_time});
			return;
		}

    }
}
