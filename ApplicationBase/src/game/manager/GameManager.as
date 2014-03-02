package game.manager
{
	import com.thinkido.framework.engine.SceneCharacter;
	import com.thinkido.framework.engine.config.SceneConfig;
	import com.thinkido.framework.engine.staticdata.SceneCharacterType;
	import com.thinkido.framework.engine.vo.avatar.AvatarParamData;
	import com.thinkido.framework.engine.vo.map.MapTile;
	import com.thinkido.framework.manager.keyBoard.KeyBoardManager;
	import com.thinkido.framework.manager.keyBoard.KeyEvent;
	
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import game.config.GameInstance;
	import game.utils.ResourceUtil;

	public class GameManager
	{
		public function GameManager()
		{
		}
		
		public static function init():void
		{
			KeyBoardManager.instance.addEventListener(KeyEvent.KEY_DOWN, onKeyDown);
		}
		
		protected static function onKeyDown(event:KeyEvent):void
		{
			// TODO Auto-generated method stub
			switch(event.keyEvent.keyCode)
			{
				case Keyboard.SPACE:
					var mousex:Number = GameInstance.scene.mouseX;
					var mousey:Number = GameInstance.scene.mouseY;
					var p:Point = new Point(int(mousex/SceneConfig.TILE_WIDTH), int(mousey/SceneConfig.TILE_HEIGHT));
					GameInstance.scene.mainChar.jump(p,-1,-1,null,true);
					break;
				case Keyboard.X:
					var i:int = 0, len:int = 400;
					var sc:SceneCharacter, apd:AvatarParamData;
					for (;i<len;i++)
					{
						sc = GameInstance.scene.createSceneCharacter(SceneCharacterType.PLAYER);
						sc.setTileXY(Math.random()*GameInstance.scene.mapConfig.mapGridX, Math.random()*GameInstance.scene.mapConfig.mapGridY);
						apd = new AvatarParamData(ResourceUtil.getAvatarPath(569));
						apd.clearSameType = true;
						sc.data = {body:apd};
						if (sc.inViewDistance())
						{
							sc.loadAvatarPart(apd);
						}else{
							sc.removeAllAvatarParts(false);
						}
					}
					break;
			}
		}
	}
}