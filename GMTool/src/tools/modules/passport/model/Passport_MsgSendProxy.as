package tools.modules.passport.model
{
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    import tools.managers.NetWorkManager;

    public class Passport_MsgSendProxy extends Proxy
    {
        public static const NAME:String = "Passport_MsgSendProxy";

        public function Passport_MsgSendProxy(param1:String = null, param2:Object = null)
        {
            super(NAME);
            return;
        }
		public function send_20003(passport:String,pwd:String,platid:int,permission:String,level:int):void
		{
			NetWorkManager.sendMsgData(20003, {passport:passport,pwd:pwd,platid:platid,permission:permission,level:level});
			return;
		}
		
		public function send_20021(type:int,condition:String):void
		{
			NetWorkManager.sendMsgData(20021, {type:type,condition:condition});
			return;
		}
		
		public function send_20023(name:String):void
		{
			NetWorkManager.sendMsgData(20023, {name:name});
			return;
		}
		
		public function send_20025(permission:String,aimid:int,user_level:int):void
		{
			NetWorkManager.sendMsgData(20025, {permission:permission,aimid:aimid,user_level:user_level});
			return;
		}
		
		public function send_20027(aimid:int,user_level:int,pwd:String,oldpwd:String):void
		{
			NetWorkManager.sendMsgData(20027, {aimid:aimid,user_level:user_level,pwd:pwd,oldpwd:oldpwd});
			return;
		}
		
		public function send_20029(id:int,user_level:int):void
		{
			NetWorkManager.sendMsgData(20029, {id:id,user_level:user_level});
			return;
		}
		
		public function send_20031(newplatid:int,aimid:int,user_level:int):void
		{
			NetWorkManager.sendMsgData(20031, {newplatid:newplatid,aimid:aimid,user_level:user_level});
			return;
		}
    }
	
}
