package com.mike.utils
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
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
				if (Admob.getInstance().supportDevice)
				{
					if (isIos)
						Admob.getInstance().setKeys("ca-app-pub-7801284693895243/1462394619","ca-app-pub-7801284693895243/4415861017");
					else
						Admob.getInstance().setKeys("ca-app-pub-7801284693895243/8332539819","ca-app-pub-7801284693895243/3762739414");
					Admob.getInstance().cacheInterstitial();
					Admob.getInstance().addEventListener(AdmobEvent.onInterstitialDismiss, onFullMiss);
					Admob.getInstance().addEventListener(AdmobEvent.onInterstitialReceive, onFullReveive);
					Admob.getInstance().addEventListener(AdmobEvent.onInterstitialFailedReceive, onFullFailedReveive);
					Admob.getInstance().addEventListener(AdmobEvent.onInterstitialLeaveApplication, onFullLeave);
					Admob.getInstance().addEventListener(AdmobEvent.onInterstitialPresent, onFullPresent);
				}
			}else{
				if (BaiDu.getInstance().supportDevice)
				{
					BaiDu.getInstance().setKeys("1003ba05","1003ba05");// BaiDu.getInstance().setKeys("appsid","计费id");
					BaiDu.getInstance().cacheInterstitial();
					BaiDu.getInstance().addEventListener(BaiDuAdEvent.onInterstitialDismiss, onFullMiss);
					BaiDu.getInstance().addEventListener(BaiDuAdEvent.onInterstitialReceive, onFullReveive);
					BaiDu.getInstance().addEventListener(BaiDuAdEvent.onInterstitialFailedReceive, onFullFailedReveive);
					BaiDu.getInstance().addEventListener(BaiDuAdEvent.onInterstitialLeaveApplication, onFullLeave);
					BaiDu.getInstance().addEventListener(BaiDuAdEvent.onInterstitialPresent, onFullPresent);
				}
			}
		}
		
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
			if (isIos || PlatUtil.isCertainPlat(PlatType.GOOGLE_PLAY))
				Admob.getInstance().cacheInterstitial();
			else
				BaiDu.getInstance().cacheInterstitial();
		}
		
		
		
		public static function showBaiDuBanner():void
		{
			trace(stage.orientation);
			if (isIos || PlatUtil.isCertainPlat(PlatType.GOOGLE_PLAY))
				Admob.getInstance().showBanner(Admob.BANNER,AdmobPosition.BOTTOM_CENTER);
			else
				BaiDu.getInstance().showBanner(BaiDu.BANNER,RelationPosition.BOTTOM_CENTER);
		}
		
		public static function hideBaiDuBanner():void
		{
			if (isIos || PlatUtil.isCertainPlat(PlatType.GOOGLE_PLAY))
				Admob.getInstance().hideBanner();
			else
				BaiDu.getInstance().hideBanner();
		}
		
		public static function cacheInterstitial():void
		{
			if (isIos || PlatUtil.isCertainPlat(PlatType.GOOGLE_PLAY))
				Admob.getInstance().cacheInterstitial();
			else
				BaiDu.getInstance().cacheInterstitial();
		}
		
		public static function isInterstitialReady():Boolean
		{
			if (isIos || PlatUtil.isCertainPlat(PlatType.GOOGLE_PLAY))
				return Admob.getInstance().isInterstitialReady();
			else
				return BaiDu.getInstance().isInterstitialReady();
			return false;
		}
		
		public static function showInterstitial():void
		{
			trace(GameInstance.instance.sceneWidth, GameInstance.instance.sceneHeight,stage.orientation,stage.autoOrients);
			if (isIos || PlatUtil.isCertainPlat(PlatType.GOOGLE_PLAY))
				Admob.getInstance().showInterstitial();
			else
				BaiDu.getInstance().showInterstitial();
		}
		
		public static function getBaiDuInstance():EventDispatcher
		{
			if (isIos || PlatUtil.isCertainPlat(PlatType.GOOGLE_PLAY))
				return Admob.getInstance();
			else
				return BaiDu.getInstance();
			return null;
		}
		
	}
}