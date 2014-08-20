package com.mike.utils
{
	
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	
	public class FlashStatus extends Sprite
	{
		
		private var fps:TextField;
		private var frame:int = 0;
		private var lastTime:int = 0;
		private var scCount:TextField;
		public function FlashStatus()
		{
			super();
			fps = new TextField();
			fps.defaultTextFormat = new TextFormat(null,12,0xff0000);
			fps.width = 150;
			fps.height = 22;
			this.addChild(fps);
			
			scCount = new TextField();
			scCount.defaultTextFormat = new TextFormat(null,12,0xff0000);
			scCount.width = 150;
			scCount.height = 22;
			scCount.y = 30;
			this.addChild(scCount);
		}
		
		public function init(s:Stage):FlashStatus
		{
			s.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			return this;
		}
		
		protected function onEnterFrame(event:Event):void
		{
			// TODO Auto-generated method stub
			frame++;
			if (getTimer() - lastTime >= 1000)
			{
				fps.text = "FPS:"+frame+"/"+stage.frameRate;
				lastTime = getTimer();
				frame = 0;
				scCount.text = (System.privateMemory / 1024) + "";
			}
		}
		private static var _instance:FlashStatus;
		public static function get instance():FlashStatus
		{
			if (_instance == null)
				_instance = new FlashStatus();
			return _instance;
			
		}
	}
}