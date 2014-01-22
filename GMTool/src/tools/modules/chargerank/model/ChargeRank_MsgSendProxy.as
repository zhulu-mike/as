package tools.modules.chargerank.model
{
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    import tools.managers.NetWorkManager;

    public class ChargeRank_MsgSendProxy extends Proxy
    {
        public static const NAME:String = "ChargeRank_MsgSendProxy";

        public function ChargeRank_MsgSendProxy(param1:String = null, param2:Object = null)
        {
            super(NAME);
            return;
        }
		
		public function send_20086(page:int,line:int,begin_time:int,end_time:int) : void
		{
			NetWorkManager.sendMsgData(20086, {page:page,line:line,begin_time:begin_time,end_time:end_time});
			return;
		}

    }
}
