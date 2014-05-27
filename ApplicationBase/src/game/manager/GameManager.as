package game.manager
{
	import com.thinkido.framework.engine.SceneCharacter;
	import com.thinkido.framework.engine.config.SceneConfig;
	import com.thinkido.framework.engine.graphics.avatar.AvatarPart;
	import com.thinkido.framework.engine.staticdata.AvatarPartType;
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
					var i:int = 0, len:int = 50;
					var sc:SceneCharacter, apd:AvatarParamData;
					var indx:int, indy:int ;
					var bx:int = GameInstance.scene.mainChar.tile_x, by:int = GameInstance.scene.mainChar.tile_y;
					for (;i<len;i++)
					{
						sc = GameInstance.scene.createSceneCharacter(SceneCharacterType.PLAYER);
						indx = (Math.random() * 80 - 40) + bx;
						indy = (Math.random() * 40 - 20) + by;
						sc.setTileXY(indx, indy);
					
						sc.data = {body:null};
						if (sc.inViewDistance())
						{
//							apd = new AvatarParamData(ResourceUtil.getAvatarPath(804),AvatarPartType.MOUNT);
//							apd.clearSameType = true;
//							sc.loadAvatarPart(apd);
//							sc.data.mount = apd;
//							apd = new AvatarParamData(ResourceUtil.getAvatarPath(2001),AvatarPartType.WING);
//							apd.clearSameType = true;
//							sc.loadAvatarPart(apd);
//							sc.data.wing = apd;
//							apd = new AvatarParamData(ResourceUtil.getAvatarPath(101),AvatarPartType.WEAPON);
//							apd.clearSameType = true;
//							sc.loadAvatarPart(apd);
//							sc.data.weapon = apd;
							apd = new AvatarParamData(ResourceUtil.getAvatarPath(1));
							apd.clearSameType = true;
							sc.data.body = apd;
							sc.loadAvatarPart(apd);
						}else{
							sc.removeAllAvatarParts(false);
//							apd = new AvatarParamData(ResourceUtil.getAvatarPath(101),AvatarPartType.WEAPON);
//							apd.clearSameType = true;
//							sc.data.weapon = apd;
//							apd = new AvatarParamData(ResourceUtil.getAvatarPath(804),AvatarPartType.MOUNT);
//							apd.clearSameType = true;
//							sc.data.mount = apd;
//							apd = new AvatarParamData(ResourceUtil.getAvatarPath(2001),AvatarPartType.WING);
//							apd.clearSameType = true;
//							sc.data.wing = apd;
							apd = new AvatarParamData(ResourceUtil.getAvatarPath(1));
							apd.clearSameType = true;
							sc.data.body = apd;
						}
					}
					break;
			}
		}
	}
}