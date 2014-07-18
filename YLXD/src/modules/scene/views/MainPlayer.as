package modules.scene.views
{
	import configs.PlayerState;
	
	import managers.DoorUtil;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	
	public class MainPlayer extends Sprite
	{
		private var shape:MovieClip;
		private var states:Array = PlayerState.stateList;
		private var currIndex:int = 0;
		public var state:int = 1;
		private var frameSpeed:int = 12;
		
		public function MainPlayer()
		{
			shape = DoorUtil.getPlayerMC(PlayerState.RECT);
			shape.loop = true;
			shape.currentFrame = 0;
			shape.play();
			Starling.juggler.add(shape);
			this.addChild(shape);
		}
		
		public function updateState():void
		{
			currIndex++;
			currIndex = currIndex >= states.length ? 0 : currIndex;
			shape.removeFromParent(true);
			state = states[currIndex];
			shape.stop();
			Starling.juggler.remove(shape);
			shape = DoorUtil.getPlayerMC(state);
			shape.currentFrame = 0;
			shape.fps = frameSpeed;
			this.addChild(shape);
			shape.play();
			Starling.juggler.add(shape);
			return;
			
		}
		
		public function addSpeed():void
		{
			frameSpeed = 30;
			shape.fps = frameSpeed;
		}
		
		public function stopSpeed():void
		{
			frameSpeed = 12;
			shape.fps = frameSpeed;
		}
	}
}