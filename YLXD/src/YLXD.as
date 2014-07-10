package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import starling.core.Starling;
	
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
		
		private function init(event:Event=null):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;
			app = new Starling(Game,stage,null,null,"auto","auto");
			app.start();
		}
	}
}