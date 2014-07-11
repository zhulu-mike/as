package
{
	import flash.desktop.SystemIdleMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import managers.LogManager;
	
	import starling.core.Starling;
	import starling.utils.SystemUtil;
	
	public class YLXD extends Sprite
	{
		
		private var app:Starling;
		public function YLXD()
		{
			super();
			
			// support autoOrients
			if (stage){
				init(null);
			}else{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		protected function onResize(event:Event):void
		{
			trace(stage.stageWidth, stage.stageHeight);
		}
		
		private function init(event:Event=null):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;
			stage.setOrientation(StageOrientation.ROTATED_RIGHT);
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			LogManager.logTrace(Multitouch.inputMode);
			LogManager.logTrace(Multitouch.maxTouchPoints);
			LogManager.logTrace(Capabilities.screenResolutionX+"-"+Capabilities.screenResolutionY);
			var rect:Rectangle = new Rectangle(0,0,Capabilities.screenResolutionX,Capabilities.screenResolutionY);
			app = new Starling(Game,stage,rect,null,"auto","auto");
			app.start();
		}
	}
}