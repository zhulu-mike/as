package tools.modules.charge.model
{
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    import tools.managers.NetWorkManager;

    public class Charge_MsgSendProxy extends Proxy
    {
        public static const NAME:String = "Charge_MsgSendProxy";

        public function Charge_MsgSendProxy(param1:String = null, param2:Object = null)
        {
            super(NAME);
            return;
        }
		public function send_20063(type:int,data:String,begin_time:int,end_time:int,line_num:int,page:int) : void
		{
			NetWorkManager.sendMsgData(20063, {type:type,data:data,begin_time:begin_time,end_time:end_time,line_num:line_num,page:page});
			return;
		}

    }
}
