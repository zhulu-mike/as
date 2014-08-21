package com.mike.utils
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.Dictionary;
	
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import managers.ResManager;
	

	public class SoundUtil
	{
		public function SoundUtil()
		{
		}
		
		private static var soundList:Dictionary = new Dictionary();
		
		public static function playSound(url:String, callBack:Function=null):void
		{
			if (soundList[url] == undefined)
				registerSound(url,callBack);
			else if (soundList[url] != 1)
				soundList[url].sound.play();
		}
		
		public static function playLoopSound(url:String):void
		{
			var callBack:Function = function():void
			{
//				(soundList[url] as Sound).
				var channel:SoundChannel = soundList[url].sound.play(0,int.MAX_VALUE);
				soundList[url].channel = channel;
			};
			if (soundList[url] == undefined)
				registerSound(url,callBack);
			else if (soundList[url] != 1){
				callBack();
			}
		}
		
		public static function stopSound(url:String):void
		{
			if (soundList[url] != 1){
				soundList[url].channel.stop();
			}
		}
		
		private static function registerSound(url:String, callBack:Function=null):void
		{
			soundList[url] = 1;
			var loadData:LoadingItem = ResManager.resLoader.add(url);
			var comp:Function = function(e:flash.events.Event):void
			{
				loadData.removeEventListener(flash.events.Event.COMPLETE, comp);
				soundList[url] = {sound:loadData.content as Sound,channel:null};
				if (callBack)
				{
					callBack();
				}
			}
			loadData.addEventListener(flash.events.Event.COMPLETE, comp);
			ResManager.resLoader.loadNow(loadData);
		}
	}
}