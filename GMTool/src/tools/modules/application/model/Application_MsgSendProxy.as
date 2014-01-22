package tools.modules.application.model
{
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    import tools.managers.NetWorkManager;

    public class Application_MsgSendProxy extends Proxy
    {
        public static const NAME:String = "Application_MsgSendProxy";

        public function Application_MsgSendProxy(param1:String = null, param2:Object = null)
        {
            super(NAME);
            return;
        }
		
		public function send_20043():void
		{
			NetWorkManager.sendMsgData(20043, {});
			return;
		}
		
		public function send_20041(v_id:Array):void
		{
			NetWorkManager.sendMsgData(20041, {v_id:v_id});
			return;
		}
		
		public function send_20059(v_id:Array):void
		{
			NetWorkManager.sendMsgData(20059, {v_id:v_id});
			return;
		}

    }
}
