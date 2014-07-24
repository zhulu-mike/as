package com.mike.utils
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.utils.Dictionary;
	
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import managers.ResManager;
	

	public class SoundUtil
	{
		public function SoundUtil()
		{
		}
		
		private static var soundList:Dictionary = new Dictionary();
		
		public static function playSound(url:String):void
		{
			if (soundList[url] == undefined)
				registerSound(url);
			else if (soundList[url] != 1)
				soundList[url].play();
		}
		
		private static function registerSound(url:String):void
		{
			soundList[url] = 1;
			var loadData:LoadingItem = ResManager.resLoader.add(url);
			var comp:Function = function(e:flash.events.Event):void
			{
				loadData.removeEventListener(flash.events.Event.COMPLETE, comp);
				soundList[url] = loadData.content as Sound;
			}
			loadData.addEventListener(flash.events.Event.COMPLETE, comp);
			ResManager.resLoader.loadNow(loadData);
		}
	}
}