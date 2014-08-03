package com.mike.utils
{
	import com.freshplanet.ane.AirAlert.AirAlert;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PNGEncoderOptions;
	
	import cn.sharesdk.ane.PlatformID;
	import cn.sharesdk.ane.ShareMenuArrowDirection;
	import cn.sharesdk.ane.ShareSDKExtension;
	import cn.sharesdk.ane.ShareType;
	
	import configs.GameInstance;

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
		
		/**
		 * 初始化ShareSDK
		 * 
		 */		
		public function init():void
		{
			sdk = new ShareSDKExtension();
			//android和ios之分
			if (DeviceUtil.isIos()){
				sdk.open("284c24ba9586",true);//284c24ba9586//iosv1101
				sdk.setPlatformConfig(PlatformID.SinaWeibo,{app_key:"329844495",app_secret:"d9fd751a9d3702cb58758dff2abdd50c",redirect_uri:"http://www.g6game.com/fkzs/"});
				sdk.setPlatformConfig(PlatformID.TencentWeibo,{app_key:"801528511",app_secret:"22ce70d59639dc10210744d732d4c3b1",redirect_uri:"http://www.g6game.com/fkzs/"});
				sdk.setPlatformConfig(PlatformID.WeChatTimeline,{app_id:"wx580dc9f6d9dcdda3"});
				sdk.setPlatformConfig(PlatformID.WeChatFav,{app_id:"wx580dc9f6d9dcdda3"});
				sdk.setPlatformConfig(PlatformID.WeChatSession,{app_id:"wx580dc9f6d9dcdda3"});
				sdk.setPlatformConfig(PlatformID.Facebook,{api_key:"296398530542978",ConsumerSecret:"b976649e5d1fd847207be2dfe6e53512",RedirectUrl:"http://www.g6game.com/fkzs/"});
				sdk.setPlatformConfig(PlatformID.Twitter,{consumer_key:"mD9mW55adcHFhR57vdbJUaCag",consumer_secret:"tHppzvYXXzD5hzvUMUsWneImuKVqAlH2XpOyQeIKJnE3XuEio1",redirect_uri:"http://www.g6game.com/fkzs/"});
				sdk.setPlatformConfig(PlatformID.Renren,{app_key:"d7f5e50e0e444cc7847de08f9ffced82",secret_key:"870d94936f5b43c38b574b80d807a802"});
			}else{
				sdk.open("258aa287ebe5",true);
			}
			sdk.setPlatformActionListener(shareComplete,shareError,sharecancel);
		}
		private function shareComplete(platform:int, action:int, res:Object):void
		{
			
			var json:String = (res == null ? "" : JSON.stringify(res));
			var message:String = "onComplete\nPlatform=" + platform + ", action=" + action + "\nres=" + json;
//			AirAlert.getInstance().showAlert(message,"");
//			sdk.toast(message);
//			trace(message);
		}
		private function shareError(platform:int, action:int, err:Object):void
		{
			var json:String = (err == null ? "" : JSON.stringify(err));
			var message:String = "onError\nPlatform=" + platform + ", action=" + action + "\nres=" + json;
//			AirAlert.getInstance().showAlert(message,"");
//			sdk.toast(message);
			trace(message);
		}
		private function sharecancel(platform:int, action:int):void
		{
			var message:String = "onCancel\nPlatform=" + platform + ", action=" + action;
//			AirAlert.getInstance().showAlert(message,"");
//			sdk.toast(message);
			trace(message);
		}
		
		/**
		 * 分享
		 * 
		 */		
		public function xuanYao():void
		{
			var shareParams:Object = new Object();
			shareParams.title = Language.getString("GAMENAME");
			shareParams.titleUrl = "http://www.g6game.com/fkzs/";
			shareParams.text = Language.getString("SHARECONTENT").replace("$SCORE",GameInstance.instance.score);
			shareParams.site = shareParams.title;
			shareParams.url = "http://www.g6game.com/fkzs/";
			shareParams.description = shareParams.title;
			shareParams.siteUrl = "http://www.g6game.com/fkzs/";
			shareParams.imagePath = AirUtil.screenShotAndSave();
			shareParams.type = ShareType.SHARE_WEBPAGE;
			sdk.showShareMenu(null, shareParams, GameInstance.instance.sceneWidth>>2, 50, ShareMenuArrowDirection.Up);
		}
		
	}
}