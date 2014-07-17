package managers
{
	import com.mike.weixin.MicroMessage;
	
	import flash.display.BitmapData;
	import flash.display.BitmapEncodingColorSpace;
	import flash.display.JPEGEncoderOptions;
	import flash.display.PNGEncoderOptions;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import cn.sharesdk.ane.PlatformID;
	import cn.sharesdk.ane.ShareMenuArrowDirection;
	import cn.sharesdk.ane.ShareSDKExtension;
	import cn.sharesdk.ane.ShareType;
	
	import starling.display.Image;

	public class ShareManager
	{
		public function ShareManager()
		{
		}
		
		private static var _instance:ShareManager;
		
		public static function get instance():ShareManager
		{
			if (_instance == null)
				_instance = new ShareManager();
			return _instance;
		}
		private var sdk:ShareSDKExtension;
		
		public function init():void
		{
			sdk = new ShareSDKExtension();
			sdk.open("258aa287ebe5",true);
			sdk.setPlatformActionListener(shareComplete,shareError,sharecancel);
		}
		private function shareComplete(platform:int, action:int, res:Object):void
		{
			var json:String = (res == null ? "" : JSON.stringify(res));
			var message:String = "onComplete\nPlatform=" + platform + ", action=" + action + "\nres=" + json;
			sdk.toast(message);
		}
		private function shareError(platform:int, action:int, err:Object):void
		{
			var json:String = (err == null ? "" : JSON.stringify(err));
			var message:String = "onError\nPlatform=" + platform + ", action=" + action + "\nres=" + json;
			sdk.toast(message);
			
		}
		private function sharecancel(platform:int, action:int):void
		{
			var message:String = "onCancel\nPlatform=" + platform + ", action=" + action;
			sdk.toast(message);
		}
		
		public function xuanYao():void
		{
			var shareParams:Object = new Object();
			shareParams.title = "真疯狂猜你妹";
			shareParams.text = "我再《真疯狂猜你妹》中得到了100分，谁敢一战？下载地址：http://www.baidu.com";
			shareParams.site = "疯狂猜你妹";
			shareParams.url = "http://www.baidu.com";
			shareParams.description = "真疯狂猜你妹";
			shareParams.imagePath = AirUtil.screenShotAndSave();
			shareParams.type = ShareType.SHARE_WEBPAGE;
			sdk.showShareMenu(null, shareParams, 0, 100, ShareMenuArrowDirection.Any);
		}
		
		public function screenshot():String
		{
			return sdk.screenshot();
		}
		
	}
}