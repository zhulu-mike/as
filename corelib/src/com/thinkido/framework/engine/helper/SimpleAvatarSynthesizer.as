package com.thinkido.framework.engine.helper
{
	import com.thinkido.framework.engine.SceneCharacter;
	import com.thinkido.framework.engine.graphics.avatar.AvatarPart;
	import com.thinkido.framework.engine.staticdata.SceneCharacterType;
	import com.thinkido.framework.engine.vo.avatar.AvatarParamData;
	import com.thinkido.framework.engine.vo.avatar.AvatarPlayCondition;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * 
	 * @author thinkido
	 * 
	 */
    public class SimpleAvatarSynthesizer extends Object
    {

        public function SimpleAvatarSynthesizer()
        {
            return;
        }
		/**
		 * 
		 * @param $id
		 * @param $callBack
		 * @param $apdArr
		 * @param $frame
		 * @param $charStatus
		 * @param $charLogicAngle
		 * @param $maxBDWidth
		 * @param $maxBDHeight
		 * @see example 使用方法
		 * <listing version="3.0"> 
				var callBack:Function = function ($id:String, bmd:BitmapData) : void
				{
					if ($id != GameInstance.mainChar.id + "_" + avatar_zizeng)
					{
						return;
					}
					mainUI.avatarScene.bitmapData = bmd ;
					return;
				};
				var apdArr:Array =  Player.avatarInfo.getSimpleAPDList(sc.isOnMount);
				var avatar_zizeng:int =  1;
				SimpleAvatarSynthesizer.synthesisSimpleAvatar(sc.id + "_" + avatar_zizeng, callBack, apdArr);
				return;
		   </listing> 
		 * 
		 */
        public static function synthesisSimpleAvatar($id:String, $callBack:Function, $apdArr:Array, $frame:int = 1, $charStatus:String = "stand", $charLogicAngle:int = 0, $maxBDWidth:Number = 512, $maxBDHeight:Number = 512) : void
        {
            var totalNum:int;
            var loadedNum:int;
            var sc:SceneCharacter;
            var apd:AvatarParamData;
            var onAvatarPartAdd:Function;
            onAvatarPartAdd = function (value1:SceneCharacter = null, value2:AvatarPart = null) : void
            {
                var bd:BitmapData = null;
                var rec:Rectangle = null;
                var bd1:BitmapData = null;
				loadedNum +=1 ;
                if (loadedNum <= totalNum)
                {
                    bd = new BitmapData($maxBDWidth, $maxBDHeight, true, 0);
                    sc.playTo($charStatus, $charLogicAngle, -1, new AvatarPlayCondition(true));
                    sc.runAvatar($frame);
                    sc.drawAvatar(bd);
                    rec = bd.getColorBoundsRect(4278190080, 0, false);
                    rec.x = 0;
                    rec.width = $maxBDWidth;
                    if (rec.width > 0 && rec.height > 0)
                    {
                        bd1 = new BitmapData(rec.width, rec.height, true, 0);
                        bd1.copyPixels(bd, rec, new Point(0, 0), null, null, true);
                    }
                    $callBack($id, bd1);
                }
                if (loadedNum == totalNum)
                {
                    SceneCharacter.recycleSceneCharacter(sc);
                }
                return;
            };
            $frame = Math.max(($frame - 1), 0);
            totalNum = $apdArr.length;
            loadedNum;
            sc = SceneCharacter.createSceneCharacter(SceneCharacterType.PLAYER, null);
            var index:int = 0;
            var len:int = $apdArr.length;
            while (index < len)
            {
                apd = $apdArr[index];
                apd = apd.clone();
                apd.playCallBack = null;
                apd.useType = 0;
                apd.clearSameType = false;
                apd.extendCallBack(null, null, null, null, onAvatarPartAdd);
                sc.loadAvatarPart(apd);
				index ++ ;
            }
            return;
        }

    }
}
