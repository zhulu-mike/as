package tools.modules.newplayercard.model
{
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    import tools.managers.NetWorkManager;

    public class PlayerCard_MsgSendProxy extends Proxy
    {
        public static const NAME:String = "PlayerCard_MsgSendProxy";

        public function PlayerCard_MsgSendProxy(param1:String = null, param2:Object = null)
        {
            super(NAME);
            return;
        }
		public function send_20051(id:int,num:int):void
		{
			NetWorkManager.sendMsgData(20051, {id:id,num:num});
			return;
		}
		
		public function send_20055():void
		{
			NetWorkManager.sendMsgData(20055, {});
			return;
		}
		
		public function send_20057(type:int,num:String,type_id:int,page:int,linenum:int):void
		{
			NetWorkManager.sendMsgData(20057, {type:type,num:num,type_id:type_id,page:page,linenum:linenum});
			return;
		}

    }
}
