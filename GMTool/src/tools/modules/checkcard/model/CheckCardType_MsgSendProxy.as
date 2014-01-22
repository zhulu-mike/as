package tools.modules.checkcard.model
{
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    import tools.managers.NetWorkManager;

    public class CheckCardType_MsgSendProxy extends Proxy
    {
        public static const NAME:String = "CheckCardType_MsgSendProxy";

        public function CheckCardType_MsgSendProxy(param1:String = null, param2:Object = null)
        {
            super(NAME);
            return;
        }
		
		public function send_20053(name:String,length:int,type:int,req:Object,server:String,begin_time:int,expiration_time:int):void
		{
			NetWorkManager.sendMsgData(20053, {name:name,length:length,type:type,req:req,server:server,begin_time:begin_time,expiration_time:expiration_time});
			return;
		}
		
		public function send_20055():void
		{
			NetWorkManager.sendMsgData(20055, {});
			return;
		}

    }
}
