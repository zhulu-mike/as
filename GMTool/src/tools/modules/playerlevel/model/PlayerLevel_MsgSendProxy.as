package tools.modules.playerlevel.model
{
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    import tools.managers.NetWorkManager;

    public class PlayerLevel_MsgSendProxy extends Proxy
    {
        public static const NAME:String = "PlayerLevel_MsgSendProxy";

        public function PlayerLevel_MsgSendProxy(param1:String = null, param2:Object = null)
        {
            super(NAME);
            return;
        }
		
		public function send_20094(time:int,day_num:int):void
		{
			NetWorkManager.sendMsgData(20094, {time:time,day_num:day_num});
			return;
		}

    }
}
