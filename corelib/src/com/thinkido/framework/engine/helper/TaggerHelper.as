package com.thinkido.framework.engine.helper
{
	import com.greensock.TweenLite;
	import com.thinkido.framework.engine.SceneCharacter;
	import com.thinkido.framework.engine.graphics.tagger.AttackFace;
	import com.thinkido.framework.engine.graphics.tagger.HeadFace;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * 显示头像上的相关文字 
	 * @author thinkido
	 * 
	 */
    public class TaggerHelper extends Object
    {
        private static var xDis:Number = 100;
        private static var yDis:Number = 70;
        private static var xyDis:Number = (xDis + yDis) / 2 * Math.cos(Math.PI / 4);
        private static var YDis:Number = 20;
        private static var duration:Number = 1.2;

        public function TaggerHelper()
        {
            return;
        }

        public static function showHeadFace(sc:SceneCharacter, value2:String = "", value3:uint = 16777215, value4:String = "", value5:DisplayObject = null, value6:DisplayObject = null) : void
        {
            var _hf:HeadFace = null;
            if (!sc.usable)
            {
                return;
            }
            sc.enableContainer(sc.scene.sceneHeadLayer);
            if (sc.headFace == null)
            {
                _hf = HeadFace.createHeadFace(value2, value3, value4, value5, value6);
                sc.headFace = _hf;
                sc.showContainer.headFace = _hf;
                if (sc.scene.isAlwaysShowChar(sc) || sc.scene.getCharHeadVisible(sc.type))
                {
                    sc.showContainer.showHeadFaceContainer();
                }
                else
                {
                    sc.showContainer.hideHeadFaceContainer();
                }
            }
            else
            {
                _hf = sc.headFace;
                _hf.reSet([value2, value3, value4, value5, value6]);
            }
			_hf.x = 0;
            var _rect:Rectangle = sc.mouseRect || sc.oldMouseRect;
            _hf.y = _rect != null ? (_rect.y - sc.pixel_y - HeadFace.HEADFACE_SPACE) : (HeadFace.DEFAULT_HEADFACE_Y);
            return;
        }

        private static function myEaseOut(value1:Number, value2:Number, value3:Number, value4:Number, value5:Number = 6) : Number
        {
            var _loc_6:* = value1 / value4 - 1;
            value1 = value1 / value4 - 1;
            return value3 * (_loc_6 * value1 * ((value5 + 1) * value1 + value5) + 1) + value2;
        }
		/**
		 * 
		 * @param $sc 
		 * @param $attackType 攻击类型
		 * @param $attackValue 攻击伤害
		 * @param $selfText 显示文字
		 * @param $selfFontSize 字体大小
		 * @param $selfFontColor 字体颜色
		 * 
		 */
        public static function showAttackFace($sc:SceneCharacter, $attackType:String = "", $attackValue:Number = 0, $selfText:String = "", $selfFontSize:uint = 0, $selfFontColor:uint = 0) : void
        {
            var attackFace:AttackFace;
            var onComplete:Function;
            onComplete = function () : void
            {
                if (attackFace.parent)
                {
                    attackFace.parent.removeChild(attackFace);
                }
                AttackFace.recycleAttackFace(attackFace);
                return;
            }
            ;
            if (!$sc.usable)
            {
                return;
            }
            if (!$sc.avatar.visible)
            {
                return;
            }
            $sc.enableContainer($sc.scene.sceneHeadLayer);
            attackFace = AttackFace.createAttackFace($attackType, $attackValue, $selfText, $selfFontSize, $selfFontColor);
            var mouseRect:Rectangle = $sc.mouseRect || $sc.oldMouseRect;
            var from:Point = new Point(0, mouseRect != null ? (mouseRect.y - $sc.pixel_y + YDis) : (-40 + YDis));
            var to:Point = from.clone();
            var dir:int = attackFace.dir;
            if (dir == 2)
            {
                to.x = from.x - xDis;
            }
            else if (dir == 3)
            {
                to.x = from.x - xyDis;
                to.y = from.y - xyDis;
            }
            else if (dir == 6)
            {
                to.x = from.x + xDis;
            }
            else
            {
                to.y = from.y - yDis;
            }
            attackFace.x = from.x;
            attackFace.y = from.y;
            $sc.showContainer.showAttackFaceContainer();
            $sc.showContainer.attackFaceContainer.addChild(attackFace);
            TweenLite.to(attackFace, duration, {x:to.x, y:to.y, onComplete:onComplete, ease:myEaseOut});
            return;
        }

        public static function getCustomFaceByName(sc:SceneCharacter, $name:String) : DisplayObject
        {
            if (!sc.usable || !sc.useContainer)
            {
                return null;
            }
            var temp:DisplayObject = sc.showContainer.customFaceContainer.getChildByName($name);
            return temp;
        }
		/**
		 *  显示自定义称号等
		 * @param sc
		 * @param showObj
		 * 
		 */
        public static function addCustomFace(sc:SceneCharacter, showObj:DisplayObject) : void
        {
            if (!sc.usable)
            {
                return;
            }
            sc.enableContainer(sc.scene.sceneHeadLayer);
            if (sc.avatar.visible)
            {
                sc.showContainer.showCustomFaceContainer();
            }
            else
            {
                sc.showContainer.hideCustomFaceContainer();
            }
            sc.showContainer.customFaceContainer.addChild(showObj);
            return;
        }

        public static function removeCustomFace(sc:SceneCharacter, showObj:DisplayObject) : void
        {
            if (!sc.usable || !sc.useContainer)
            {
                return;
            }
            if (showObj.parent)
            {
                showObj.parent.removeChild(showObj);
            }
            return;
        }

        public static function removeCustomFaceByName(sc:SceneCharacter, $name:String) : void
        {
            if (!sc.usable || !sc.useContainer)
            {
                return;
            }
            var temp:DisplayObject = sc.showContainer.customFaceContainer.getChildByName($name);
            if (temp != null)
            {
                sc.showContainer.customFaceContainer.removeChild(temp);
            }
            return;
        }

    }
}
