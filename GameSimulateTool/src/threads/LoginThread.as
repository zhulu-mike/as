package threads
{
	import com.adobe.crypto.MD5;
	
	import flash.html.HTMLHost;
	import flash.html.HTMLLoader;
	import flash.html.HTMLWindowCreateOptions;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import mx.events.ResizeEvent;
	
	import configs.GameConfig;

	/**
	 * 登陆模拟线程
	 * @author Administrator
	 * 
	 */	
	public class LoginThread
	{
		
		public var uid:int = 1;
		
		public var platid:int = 1;
		
		public var sid:int = 1;
		
		public var adult:int = 1;
		
		public var loader:HTMLLoader;
		
		
		public function LoginThread($uid:int, $platid:int=1)
		{
			uid = $uid;
			platid = $platid;
		}
		
		public function startSimulate(htmlHost:HTMLHost):void
		{
			var request:URLRequest = new URLRequest(GameConfig.game_login_url);
			var val:URLVariables = new URLVariables();
			val["uid"] = uid;
			val["platid"] = platid;
			val["sid"] = sid;
			val["time"] = int(new Date().getTime()*0.001);
			val["adult"] = adult;
			val["backurl"] = "";
			val["useraccount"] = uid;
			var mysign:String = MD5.hash(uid+platid.toString()+GameConfig.game_login_key+val["time"]+sid+val["useraccount"]);
			val["sign"] = mysign;
			
			request.method = URLRequestMethod.GET;
			request.data = val;
//			navigateToURL(request);
			
//			loader.load(request); 
			var option:HTMLWindowCreateOptions = new HTMLWindowCreateOptions();
			option.width = 1000;
			option.height = 600;
			option.resizable = true;
			loader = htmlHost.createWindow(option);
			loader.load(request);
			loader.addEventListener(ResizeEvent.RESIZE, resize);
		}
		
		public function resize(event:ResizeEvent):void
		{
			loader.width = loader.stage.stageWidth;
			loader.height = loader.stage.stageHeight;
		}
		
		public function refresh():void
		{
			loader.reload();
		}
	}
}