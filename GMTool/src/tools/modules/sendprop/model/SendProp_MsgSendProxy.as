package tools.modules.sendprop.model
{
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    import tools.managers.NetWorkManager;

    public class SendProp_MsgSendProxy extends Proxy
    {
        public static const NAME:String = "SendProp_MsgSendProxy";

        public function SendProp_MsgSendProxy(param1:String = null, param2:Object = null)
        {
            super(NAME);
            return;
        }
		
		public function send_20035():void
		{
			NetWorkManager.sendMsgData(20035, {});
			return;
		}
		
		public function send_20037(type:int,range_type:int,range:String,req:Object):void
		{
			NetWorkManager.sendMsgData(20037, {type:type,range_type:range_type,range:range,req:req});
			return;
		}
		
		public function send_20045(type:int,range_type:int,range:String,req:Object):void
		{
			NetWorkManager.sendMsgData(20045, {type:type,range_type:range_type,range:range,req:req});
			return;
		}
		
		public function send_20047(v_id:Array):void
		{
			NetWorkManager.sendMsgData(20047, {v_id:v_id});
			return;
		}
		
		public function send_20049():void
		{
			NetWorkManager.sendMsgData(20049, {});
			return;
		}
		
		public function send_20067(platid:int):void
		{
			NetWorkManager.sendMsgData(20067, {platid:platid});
			return;
		}

    }
}
