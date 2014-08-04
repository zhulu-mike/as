package com.mike.utils
{
	import com.kunpeng.ad360.Ad360;
	import com.kunpeng.ad360.Ad360BannerEvent;
	import com.kunpeng.ad360.Ad360InsertEvent;
	import com.unionsy.sdk.ane.AdsCallbackEvent;
	import com.unionsy.sdk.ane.Constants;
	import com.unionsy.sdk.ane.SsjjAdsManager;
	
	import flash.desktop.NativeApplication;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	
	import configs.GameInstance;
	
	import so.cuo.platform.admob.Admob;
	import so.cuo.platform.admob.AdmobEvent;
	import so.cuo.platform.admob.AdmobPosition;
	import so.cuo.platform.baidu.BaiDu;
	import so.cuo.platform.baidu.BaiDuAdEvent;
	import so.cuo.platform.baidu.RelationPosition;

	public class AdvertiseUtil
	{
		public function AdvertiseUtil()
		{
		}
		
		private static var stage:Stage;
		private static var isIos:Boolean = false;
		
		public static function initBaiDu(s:Stage):void
		{
			stage = s;
			
				//android和ios之分
			isIos = DeviceUtil.isIos();
			if (isIos || PlatUtil.isCertainPlat(PlatType.GOOGLE_PLAY))
			{
//				if (Admob.getInstance().supportDevice)
//				{
//					if (isIos)
//						Admob.getInstance().setKeys("ca-app-pub-7801284693895243/1462394619","ca-app-pub-7801284693895243/4415861017");
//					else
//						Admob.getInstance().setKeys("ca-app-pub-7801284693895243/8332539819","ca-app-pub-7801284693895243/3762739414");
//					Admob.getInstance().cacheInterstitial();
//					Admob.getInstance().addEventListener(AdmobEvent.onInterstitialDismiss, onFullMiss);
//					Admob.getInstance().addEventListener(AdmobEvent.onInterstitialReceive, onFullReveive);
//					Admob.getInstance().addEventListener(AdmobEvent.onInterstitialFailedReceive, onFullFailedReveive);
//					Admob.getInstance().addEventListener(AdmobEvent.onInterstitialLeaveApplication, onFullLeave);
//					Admob.getInstance().addEventListener(AdmobEvent.onInterstitialPresent, onFullPresent);
//				}
			}else if (PlatUtil.isCertainPlat(PlatType.ANDROID_4399)){
//				SsjjAdsManager.getInstance().init();
//				SsjjAdsManager.getInstance().addEventListener(Constants.EVENT_TYPE_ADS_CALLBACK, onAdsCallback);
			}else if (PlatUtil.isCertainPlat(PlatType.ANDROID_360)){
				Ad360.instance.init("48415163d9dfe2657656da45dc523132","9b826737771399dcc63fa76155db0fa7");
//				Ad360.instance.init("bb92999153bbc9861de3399be84c3a14","78c5db4fd9bb8367ba26868893847738");
				Ad360.instance.loadInsert();
				Ad360.instance.addEventListener(Ad360BannerEvent.REQUEST_SUCCESS, onAd360Banner);
				Ad360.instance.addEventListener(Ad360BannerEvent.REQUEST_FAILED, onAd360Banner);
				Ad360.instance.addEventListener(Ad360BannerEvent.SHOW_SUCCESS, onAd360Banner);
				Ad360.instance.addEventListener(Ad360InsertEvent.SHOW_SUCCESS, onAd360Insert);
				Ad360.instance.addEventListener(Ad360InsertEvent.REQUEST_FAILED, onAd360Insert);
				Ad360.instance.addEventListener(Ad360InsertEvent.REQUEST_SUCCESS, onAd360Insert);
			}else{
//				if (BaiDu.getInstance().supportDevice)
//				{
//					BaiDu.getInstance().setKeys("1003ba05","1003ba05");// BaiDu.getInstance().setKeys("appsid","计费id");
//					BaiDu.getInstance().cacheInterstitial();
//					BaiDu.getInstance().addEventListener(BaiDuAdEvent.onInterstitialDismiss, onFullMiss);
//					BaiDu.getInstance().addEventListener(BaiDuAdEvent.onInterstitialReceive, onFullReveive);
//					BaiDu.getInstance().addEventListener(BaiDuAdEvent.onInterstitialFailedReceive, onFullFailedReveive);
//					BaiDu.getInstance().addEventListener(BaiDuAdEvent.onInterstitialLeaveApplication, onFullLeave);
//					BaiDu.getInstance().addEventListener(BaiDuAdEvent.onInterstitialPresent, onFullPresent);
//				}
			}
		}
		
		protected static function onAd360Insert(event:Ad360InsertEvent):void
		{
			trace("insert" + event.type);
		}
		
		protected static function onAd360Banner(event:Ad360BannerEvent):void
		{
			trace("banner" + event.type);
		}
		
		/*private static function onAdsCallback(e:AdsCallbackEvent):void{
			//广告类展示、关闭、失败回调
			if(e.adType == Constants.AD_TYPE_BANNER){
				//banner
			}else if(e.adType == Constants.AD_TYPE_PAUSE){
				//插屏
			}else if(e.adType == Constants.AD_TYPE_FULL){
				//全屏
			}else if(e.adType == Constants.AD_TYPE_OFFERS){
				//积分墙
			}else if(e.adType == Constants.AD_TYPE_EXIT){
				//退出时广告显示
				if(e.status == Constants.STATUS_EXIT_YES){
					//确定退出
					clearAdCache();
					NativeApplication.nativeApplication.exit();
				}else if(e.status == Constants.STATUS_EXIT_NO){
					//取消退出
				} 
			}
			trace("4399广告类型："+e.adType,"展示状态"+e.status);
		}*/
		
		protected static function onFullPresent(event:Event):void
		{
			// TODO Auto-generated method stub
			trace("全屏广告present");
		}
		
		protected static function onFullLeave(event:Event):void
		{
			trace("全屏广告离开");
		}
		
		protected static function onFullFailedReveive(event:Event):void
		{
			// TODO Auto-t method stub
			trace("全屏广告接收失败");
		}
		
		protected static function onFullReveive(event:Event):void
		{
			trace("收到全屏广告");
		}
		
		protected static function onFullMiss(event:Event):void
		{
			trace("全屏广告关闭");
//			if (isIos || PlatUtil.isCertainPlat(PlatType.GOOGLE_PLAY))
//				Admob.getInstance().cacheInterstitial();
//			else
//				BaiDu.getInstance().cacheInterstitial();
		}
		
		
		
		public static function showBaiDuBanner():void
		{
			trace(stage.orientation);
//			if (isIos || PlatUtil.isCertainPlat(PlatType.GOOGLE_PLAY))
//				Admob.getInstance().showBanner(Admob.BANNER,AdmobPosition.BOTTOM_CENTER);
//			else if (PlatUtil.isCertainPlat(PlatType.ANDROID_4399))
//				SsjjAdsManager.getInstance().showBanner();
//			else if (PlatUtil.isCertainPlat(PlatType.ANDROID_360)
				Ad360.instance.showBanner();
//			else
//				BaiDu.getInstance().showBanner(BaiDu.BANNER,RelationPosition.BOTTOM_CENTER);
		}
		
		public static function hideBaiDuBanner():void
		{
//			if (isIos || PlatUtil.isCertainPlat(PlatType.GOOGLE_PLAY))
//				Admob.getInstance().hideBanner();
//			else if (PlatUtil.isCertainPlat(PlatType.ANDROID_4399))
//				SsjjAdsManager.getInstance().hideBanner();
//			else if (PlatUtil.isCertainPlat(PlatType.ANDROID_360)
					Ad360.instance.hideBanner();
//			else
//				BaiDu.getInstance().hideBanner();
		}
		
		public static function cacheInterstitial():void
		{
//			if (isIos || PlatUtil.isCertainPlat(PlatType.GOOGLE_PLAY))
//				Admob.getInstance().cacheInterstitial();
//			else if (PlatUtil.isCertainPlat(PlatType.ANDROID_360)
				Ad360.instance.loadInsert();
//			else
//				BaiDu.getInstance().cacheInterstitial();
		}
		
		public static function isInterstitialReady():Boolean
		{
//			if (isIos || PlatUtil.isCertainPlat(PlatType.GOOGLE_PLAY))
//				return Admob.getInstance().isInterstitialReady();
//			else
//				return BaiDu.getInstance().isInterstitialReady();
			return true;
		}
		
		public static function showInterstitial():void
		{
			trace(GameInstance.instance.sceneWidth, GameInstance.instance.sceneHeight,stage.orientation,stage.autoOrients);
//			if (isIos || PlatUtil.isCertainPlat(PlatType.GOOGLE_PLAY))
//				Admob.getInstance().showInterstitial();
//			else if (PlatUtil.isCertainPlat(PlatType.ANDROID_4399))
//				SsjjAdsManager.getInstance().showFullScreen();
//			else if (PlatUtil.isCertainPlat(PlatType.ANDROID_360)
				Ad360.instance.showInsert();
//			else
//				BaiDu.getInstance().showInterstitial();
		}
		
		public static function getBaiDuInstance():EventDispatcher
		{
//			if (isIos || PlatUtil.isCertainPlat(PlatType.GOOGLE_PLAY))
//				return Admob.getInstance();
//			else if (PlatUtil.isCertainPlat(PlatType.ANDROID_4399))
//				return SsjjAdsManager.getInstance();
//			else if (PlatUtil.isCertainPlat(PlatType.ANDROID_360)
				Ad360.instance;
//			else
//				return BaiDu.getInstance();
			return null;
		}
		
		/**
		 * 4399显示退出插屏广告
		 * 
		 */		
		public static function showExitScreen():void
		{
//			SsjjAdsManager.getInstance().showExitScreen(); 
		}
		
		/**
		 * 清除广告缓存
		 * 
		 */		
		public static function clearAdCache():void
		{
//			if (PlatUtil.isCertainPlat(PlatType.ANDROID_4399))
//					SsjjAdsManager.getInstance().clearAdsCache();
		}
		
	}
}