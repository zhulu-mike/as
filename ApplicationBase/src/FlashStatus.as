package
{
	
	import com.thinkido.framework.engine.SceneCharacter;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import game.config.GameInstance;
	
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
			fps.defaultTextFormat = new TextFormat(null,12,0x00ff00);
			fps.width = 150;
			fps.height = 22;
			this.addChild(fps);
			
			scCount = new TextField();
			scCount.defaultTextFormat = new TextFormat(null,12,0x00ff00);
			scCount.width = 150;
			scCount.height = 22;
			scCount.y = 30;
			this.addChild(scCount);
		}
		
		public function init(s:Stage):void
		{
			s.addEventListener(Event.ENTER_FRAME, onEnterFrame);
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
				
				var scs:Array = GameInstance.scene.sceneCharacters;
				var sc:SceneCharacter,count:int = 0;
				for each (sc in scs)
				{
					if (sc.isInView)
						count++;
				}
				scCount.text = "元素数量："+count.toString();
			}
		}
	}
}