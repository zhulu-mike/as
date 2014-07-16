package modules.scene.views
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	
	import configs.PlayerState;
	
	import managers.DoorUtil;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class MainPlayer extends Sprite
	{
		private var shape:DisplayObject;
		private var states:Array = PlayerState.stateList;
		private var currIndex:int = 0;
		public var state:int = 1;
		
		public function MainPlayer()
		{
			shape = DoorUtil.getDoorShape(PlayerState.RECT,false);
			this.addChild(shape);
		}
		
		public function updateState():void
		{
			currIndex++;
			currIndex = currIndex >= states.length ? 0 : currIndex;
			shape.removeFromParent(true);
			state = states[currIndex];
			shape = DoorUtil.getDoorShape(state);
			this.addChild(shape);
			return;
			switch (states[currIndex])
			{
				case PlayerState.RECT:
					shape = new Quad(30,30,0x00ff00);
					break;
				case PlayerState.TRIANGLE:
					var circle:Shape = new Shape();
					circle.graphics.beginFill(0x00ff000);
					circle.graphics.moveTo(15,0);
					circle.graphics.lineTo(0,30);
					circle.graphics.lineTo(30,30);
					circle.graphics.lineTo(15,0);
					circle.graphics.endFill();
					var bmd:BitmapData = new BitmapData(circle.width,circle.height,true,0);
					bmd.draw(circle);
					shape = new Image(Texture.fromBitmapData(bmd));
					break;
				case PlayerState.CIRCLE:
					var circle:Shape = new Shape();
					circle.graphics.beginFill(0x00ff000);
					circle.graphics.drawCircle(15,15,15);
					circle.graphics.endFill();
					var bmd:BitmapData = new BitmapData(circle.width,circle.height,true,0);
					bmd.draw(circle);
					shape = new Image(Texture.fromBitmapData(bmd));
					break;
			}
			
		}
	}
}