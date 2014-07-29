package com.mike.utils
{
	import com.freshplanet.ane.AirAlert.AirAlert;
	
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
			if (DeviceUtil.isIos())
				sdk.open("iosv1101",true);
			else
				sdk.open("258aa287ebe5",true);
			sdk.setPlatformActionListener(shareComplete,shareError,sharecancel);
		}
		private function shareComplete(platform:int, action:int, res:Object):void
		{
			
			var json:String = (res == null ? "" : JSON.stringify(res));
			var message:String = "onComplete\nPlatform=" + platform + ", action=" + action + "\nres=" + json;
//			AirAlert.getInstance().showAlert(message,"");
//			sdk.toast(message);
		}
		private function shareError(platform:int, action:int, err:Object):void
		{
			var json:String = (err == null ? "" : JSON.stringify(err));
			var message:String = "onError\nPlatform=" + platform + ", action=" + action + "\nres=" + json;
//			AirAlert.getInstance().showAlert(message,"");
//			sdk.toast(message);
			
		}
		private function sharecancel(platform:int, action:int):void
		{
			var message:String = "onCancel\nPlatform=" + platform + ", action=" + action;
//			AirAlert.getInstance().showAlert(message,"");
//			sdk.toast(message);
		}
		
		/**
		 * 分享
		 * 
		 */		
		public function xuanYao():void
		{
			var shareParams:Object = new Object();
			shareParams.title = "疯狂之手";
			shareParams.text = "我在《疯狂之手》中得到了"+GameInstance.instance.score+"分，谁敢一战？下载地址：http://www.g6game.com/fkzs/";
			shareParams.site = "疯狂之手";
			shareParams.url = "http://www.g6game.com/fkzs/";
			shareParams.description = "疯狂之手";
			shareParams.imagePath = AirUtil.screenShotAndSave();
			shareParams.type = ShareType.SHARE_WEBPAGE;
			sdk.showShareMenu(null, shareParams, GameInstance.instance.sceneWidth>>2, 50, ShareMenuArrowDirection.Up);
//			var shareParams:Object = new Object();
//			shareParams.title = "ShareSDK for ANE发布";
//			shareParams.titleUrl = "http://sharesdk.cn";
//			shareParams.text = "好耶～好高兴啊～";
//			shareParams.imageUrl = "http://f1.sharesdk.cn/imgs/2014/02/26/owWpLZo_638x960.jpg";
//			shareParams.site = "ShareSDK";
//			shareParams.siteUrl = "http://sharesdk.cn";
//			shareParams.description = "asdfdsafsadf";
//			shareParams.type = ShareType.SHARE_WEBPAGE;
//			sdk.showShareMenu(null, shareParams, 320, 460, ShareMenuArrowDirection.Any);
		}
		
	}
}