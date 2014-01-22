package tools.modules.announce.model
{
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    import tools.managers.NetWorkManager;

    public class Announce_MsgSendProxy extends Proxy
    {
        public static const NAME:String = "Announce_MsgSendProxy";

        public function Announce_MsgSendProxy(param1:String = null, param2:Object = null)
        {
            super(NAME);
            return;
        }
		
		/**
		 *创建系统公告请求 
		 * @param content
		 * @param times
		 * @param marquee
		 * @param chat
		 * @param begint_ime
		 * @param end_time
		 * @param colour
		 * 
		 */
		public function send_20082(content:String,times:int,marquee:int,chat:int,begint_ime:int,end_time:int,colour:int):void
		{
			NetWorkManager.sendMsgData(20082, {content:content,times:times,marquee:marquee,chat:chat,begint_ime:begint_ime,end_time:end_time,colour:colour});
			return;
		}
		
		/**
		 *发送获取公告列表 
		 */
		public function send_20084():void
		{
			NetWorkManager.sendMsgData(20084, {});
			return;
		}
		
		/**
		 * 发送删除公告协议 
		 * @param id
		 * 
		 */
		public function send_20088(id:int):void
		{
			NetWorkManager.sendMsgData(20088, {id:id});
			return;
		}

    }
}
