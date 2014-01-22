package tools.modules.vipcareer.model
{
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    import tools.managers.NetWorkManager;

    public class VipCareer_MsgSendProxy extends Proxy
    {
        public static const NAME:String = "VipCareer_MsgSendProxy";

        public function VipCareer_MsgSendProxy(param1:String = null, param2:Object = null)
        {
            super(NAME);
            return;
        }
		
		public function send_20092(vip:int):void
		{
			NetWorkManager.sendMsgData(20092, {vip:vip});
			return;
		}

    }
}
