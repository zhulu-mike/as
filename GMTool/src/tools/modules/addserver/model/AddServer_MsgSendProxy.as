package tools.modules.addserver.model
{
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    import tools.managers.NetWorkManager;

    public class AddServer_MsgSendProxy extends Proxy
    {
        public static const NAME:String = "AddServer_MsgSendProxy";

        public function AddServer_MsgSendProxy(param1:String = null, param2:Object = null)
        {
            super(NAME);
            return;
        }
		
		public function send_20069(name:String,platid:int,ip:String,port:int,dbhost:String,dbuser:String,dbpwd:String,dbname:String,dbport:int,maindbhost:String,
								   maindbuser:String,maindbpwd:String,maindbname:String,maindbport:int):void
		{
			NetWorkManager.sendMsgData(20069, {name:name,platid:platid,ip:ip,port:port,dbhost:dbhost,dbuser:dbuser,dbpwd:dbpwd,dbname:dbname,dbport:dbport,maindbhost:maindbhost,
				maindbuser:maindbuser,maindbpwd:maindbpwd,maindbname:maindbname,maindbport:maindbport});
			return;
		}
		
		public function send_20071(id:int,name:String,platid:int,ip:String,port:int,dbhost:String,dbuser:String,dbpwd:String,dbname:String,dbport:int,maindbhost:String,
								   maindbuser:String,maindbpwd:String,maindbname:String,maindbport:int):void
		{
			NetWorkManager.sendMsgData(20071, {id:id,name:name,platid:platid,ip:ip,port:port,dbhost:dbhost,dbuser:dbuser,dbpwd:dbpwd,dbname:dbname,dbport:dbport,maindbhost:maindbhost,
				maindbuser:maindbuser,maindbpwd:maindbpwd,maindbname:maindbname,maindbport:maindbport});
			return;
		}
		
		public function send_20073(id:int):void
		{
			NetWorkManager.sendMsgData(20073, {id:id});
		}
		
		public function send_20067(platid:int):void
		{
			NetWorkManager.sendMsgData(20067, {platid:platid});
		}

    }
}
