package tools.modules.chargecount.model
{
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    import tools.managers.NetWorkManager;

    public class ChargeCount_MsgSendProxy extends Proxy
    {
        public static const NAME:String = "ChargeCount_MsgSendProxy";

        public function ChargeCount_MsgSendProxy(param1:String = null, param2:Object = null)
        {
            super(NAME);
            return;
        }
		
		public function send_20090(begin_time:int,end_time:int):void
		{
			NetWorkManager.sendMsgData(20090, {begin_time:begin_time,end_time:end_time});
			return;
		}

    }
}
