package com.mike.utils
{
	import flash.events.EventDispatcher;
	
	import so.cuo.platform.baidu.BaiDu;
	import so.cuo.platform.baidu.BaiDuAdEvent;
	import so.cuo.platform.baidu.RelationPosition;

	public class AdvertiseUtil
	{
		public function AdvertiseUtil()
		{
		}
		
		public static function initBaiDu():void
		{
			if (BaiDu.getInstance().supportDevice)
			{
				BaiDu.getInstance().setKeys("debug","debug");// BaiDu.getInstance().setKeys("appsid","计费id");
				BaiDu.getInstance().cacheInterstitial();
			}
		}
		
		public static function showBaiDuBanner():void
		{
			BaiDu.getInstance().showBanner(BaiDu.BANNER,RelationPosition.BOTTOM_CENTER);
		}
		
		public static function hideBaiDuBanner():void
		{
			BaiDu.getInstance().hideBanner();
		}
		
		public static function cacheInterstitial():void
		{
			BaiDu.getInstance().cacheInterstitial();
		}
		
		public static function isInterstitialReady():Boolean
		{
			return BaiDu.getInstance().isInterstitialReady();
			return false;
		}
		
		public static function showInterstitial():void
		{
			BaiDu.getInstance().showInterstitial();
			var closeFunc:Function = function(event:BaiDuAdEvent):void
			{
				BaiDu.getInstance().removeEventListener(BaiDuAdEvent.onInterstitialLeaveApplication,closeFunc);
				cacheInterstitial();
			};
			BaiDu.getInstance().addEventListener(BaiDuAdEvent.onInterstitialLeaveApplication,closeFunc);
		}
		
		public static function getBaiDuInstance():EventDispatcher
		{
			return BaiDu.getInstance();
			return null;
		}
		
	}
}