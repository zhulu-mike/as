package tools.modules.consum.model
{
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    import tools.managers.NetWorkManager;

    public class Consum_MsgSendProxy extends Proxy
    {
        public static const NAME:String = "Consum_MsgSendProxy";

        public function Consum_MsgSendProxy(param1:String = null, param2:Object = null)
        {
            super(NAME);
            return;
        }
		
		public function send_20065(money_type:int,type:int,data:String,begin_time:int,end_time:int,line_num:int,page:int):void
		{
			NetWorkManager.sendMsgData(20065, {money_type:money_type,type:type,data:data,begin_time:begin_time,end_time:end_time,line_num:line_num,page:page});
			return;
		}

    }
}
