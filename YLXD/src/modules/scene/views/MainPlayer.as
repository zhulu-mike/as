package modules.scene.views
{
	import com.mike.utils.MathUtil;
	
	import configs.GameInstance;
	import configs.PlayerState;
	
	import managers.DoorUtil;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
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
		
		public function setSpeed(speed:int):void
		{
			frameSpeed = (speed/GameInstance.INIT_SPEED)*12;
			shape.fps = frameSpeed;
		}
		
		public function flyOut(h:int):void
		{
			var tween:Tween = new Tween(this,0.8,Transitions.EASE_OUT);
			Starling.juggler.add(tween);
			tween.animate("y", h);
			this.rotation = MathUtil.angleToRadian(90);
			this.x += this.width;
			tween.onComplete = destroy;
			this.shape.stop();
		}
		
		public function destroy():void
		{
			this.removeFromParent();
			DoorUtil.recyclePlayerMC(state, shape);
		}
		
	}
}