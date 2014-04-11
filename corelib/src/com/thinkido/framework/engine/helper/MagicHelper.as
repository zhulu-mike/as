package com.thinkido.framework.engine.helper
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import com.greensock.plugins.DynamicPropsPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.thinkido.framework.common.handler.helper.HandlerHelper;
	import com.thinkido.framework.common.utils.ZMath;
	import com.thinkido.framework.engine.Scene;
	import com.thinkido.framework.engine.SceneCamera;
	import com.thinkido.framework.engine.SceneCharacter;
	import com.thinkido.framework.engine.graphics.avatar.AvatarPart;
	import com.thinkido.framework.engine.staticdata.CharStatusType;
	import com.thinkido.framework.engine.staticdata.SceneCharacterType;
	import com.thinkido.framework.engine.utils.Transformer;
	import com.thinkido.framework.engine.vo.avatar.AvatarParamData;
	import com.thinkido.framework.engine.vo.avatar.AvatarPlayCondition;
	import com.thinkido.framework.manager.TimerManager;
	
	import flash.geom.Point;

    public class MagicHelper extends Object
    {
		public static var MAGIC_STATUS:String = "stand";
		
        public function MagicHelper()
        {
            return;
        }
		/**
		 * 
		 * @param $from
		 * @param $toArr
		 * @param $fromApd
		 * @param $toApd
		 * @param $passApd
		 * 
		 */
        public static function showMagic_from1passNtoN($from:SceneCharacter, $toArr:Array, $fromApd:AvatarParamData = null, $toApd:AvatarParamData = null, $passApd:AvatarParamData = null) : void
        {
            var hasRun:Boolean;
            var showAttack:Function;
            var toSc:SceneCharacter;
            showAttack = function () : void
            {
                if (hasRun)
                {
                    return;
                }
                hasRun = true;
                showMagic($from, $toArr, $fromApd, $toApd, $passApd);
                return;
            }
            ;
            if ($toArr.length == 1)
            {
                toSc = $toArr[0];
                $from.faceTo(toSc.pixel_x, toSc.pixel_y);
            }
            if ($from.type != SceneCharacterType.DUMMY)
            {
                if (!$from.isJumping())
                {
                    $from.playTo(CharStatusType.ATTACK, -1, -1, new AvatarPlayCondition(true));
                    $from.showAttack = showAttack;
                }
                else
                {
                    showAttack();
                }
            }
            else
            {
                showAttack();
            }
            hasRun;
            return;
        }
		/**
		 * 
		 * @param $from
		 * @param $toP
		 * @param $fromApd
		 * @param $toApd
		 * @param $passApd
		 * 
		 */
        public static function showMagic_from1pass1toPointArea($from:SceneCharacter, $toP:Point, $fromApd:AvatarParamData = null, $toApd:AvatarParamData = null, $passApd:AvatarParamData = null) : void
        {
            var hasRun:Boolean;
            var showAttack:Function;
            showAttack = function () : void
            {
                var scene:Scene;
                var new_onPlayComplete:Function;
                new_onPlayComplete = function (value1:SceneCharacter = null, value2:AvatarPart = null) : void
                {
                    scene.removeCharacter(value1);
                    return;
                };
                if (hasRun)
                {
                    return;
                }
                hasRun = true;
                scene = $from.scene;
                var toSc:* = scene.createSceneCharacter(SceneCharacterType.DUMMY);
                toSc.setXY($toP.x, $toP.y);
                $toApd = $toApd || new AvatarParamData();
                $toApd.extendCallBack(MAGIC_STATUS, null,null, null, new_onPlayComplete);
                showMagic($from, [toSc], $fromApd, $toApd, $passApd);
                return;
            };
            $from.faceTo($toP.x, $toP.y);
            if ($from.type != SceneCharacterType.DUMMY)
            {
                if (!$from.isJumping())
                {
                    $from.playTo(CharStatusType.ATTACK, -1, -1, new AvatarPlayCondition(true));
                    $from.showAttack = showAttack;
                }
                else
                {
                    showAttack();
                }
            }
            else
            {
                showAttack();
            }
            hasRun;
            return;
        }
		/**
		 * 
		 * @param $from
		 * @param $toRectCenter
		 * @param $toRectHalfWidth
		 * @param $toRectHalfHeight
		 * @param $showSpace
		 * @param $includeCenter
		 * @param $fromApd
		 * @param $toApd
		 * @param $passApd
		 * 
		 */
        public static function showMagic_from1pass1toRectArea($from:SceneCharacter, $toRectCenter:Point, $toRectHalfWidth:int, $toRectHalfHeight:int, $showSpace:int = 30, $includeCenter:Boolean = true, $fromApd:AvatarParamData = null, $toApd:AvatarParamData = null, $passApd:AvatarParamData = null) : void
        {
            var hasRun:Boolean;
            var showAttack:Function;
            showAttack = function () : void
            {
                var scene:Scene;
                var toArr:Array;
                var pixelX:int;
                var pixelY:int;
                var toSc:SceneCharacter;
                var centerSc:SceneCharacter;
                var i:int;
                var j:int;
                var new_onPlayComplete:Function;
                var tempToApd:AvatarParamData;
                new_onPlayComplete = function (value1:SceneCharacter = null, value2:AvatarPart = null) : void
                {
                    scene.removeCharacter(value1);
                    return;
                };
                if (hasRun)
                {
                    return;
                }
                hasRun = true;
                scene = $from.scene;
                toArr =  [];
                i = 0;
                while (i <= $toRectHalfWidth)
                {
                    j = 0;
                    while (j <= $toRectHalfHeight)
                    {
                        
                        if (i == 0 && j == 0)
                        {
                            pixelX = $toRectCenter.x;
                            pixelY = $toRectCenter.y;
                            centerSc = scene.createSceneCharacter(SceneCharacterType.DUMMY);
                            centerSc.setXY(pixelX, pixelY);
                        }
                        else if (i == 0 && j != 0)
                        {
                            pixelX = $toRectCenter.x;
                            pixelY = $toRectCenter.y + j;
                            toSc = scene.createSceneCharacter(SceneCharacterType.DUMMY);
                            toSc.setXY(pixelX, pixelY);
                            toArr.push(toSc);
                            pixelX = $toRectCenter.x;
                            pixelY = $toRectCenter.y - j;
                            toSc = scene.createSceneCharacter(SceneCharacterType.DUMMY);
                            toSc.setXY(pixelX, pixelY);
                            toArr.push(toSc);
                        }
                        else if (i != 0 && j == 0)
                        {
                            pixelX = $toRectCenter.x + i;
                            pixelY = $toRectCenter.y;
                            toSc = scene.createSceneCharacter(SceneCharacterType.DUMMY);
                            toSc.setXY(pixelX, pixelY);
                            toArr.push(toSc);
                            pixelX = $toRectCenter.x - i;
                            pixelY = $toRectCenter.y;
                            toSc = scene.createSceneCharacter(SceneCharacterType.DUMMY);
                            toSc.setXY(pixelX, pixelY);
                            toArr.push(toSc);
                        }
                        else
                        {
                            pixelX = $toRectCenter.x + i;
                            pixelY = $toRectCenter.y + j;
                            toSc = scene.createSceneCharacter(SceneCharacterType.DUMMY);
                            toSc.setXY(pixelX, pixelY);
                            toArr.push(toSc);
                            pixelX = $toRectCenter.x + i;
                            pixelY = $toRectCenter.y - j;
                            toSc = scene.createSceneCharacter(SceneCharacterType.DUMMY);
                            toSc.setXY(pixelX, pixelY);
                            toArr.push(toSc);
                            pixelX = $toRectCenter.x - i;
                            pixelY = $toRectCenter.y + j;
                            toSc = scene.createSceneCharacter(SceneCharacterType.DUMMY);
                            toSc.setXY(pixelX, pixelY);
                            toArr.push(toSc);
                            pixelX = $toRectCenter.x - i;
                            pixelY = $toRectCenter.y - j;
                            toSc = scene.createSceneCharacter(SceneCharacterType.DUMMY);
                            toSc.setXY(pixelX, pixelY);
                            toArr.push(toSc);
                        }
                        j = j + $showSpace;
                    }
                    i = i + $showSpace;
                }
                $toApd = $toApd || new AvatarParamData();
                $toApd.extendCallBack(MAGIC_STATUS,null, null, null, new_onPlayComplete);
                if ($passApd != null)
                {
                    var new_onPlayStart_for_to:* = function (value1:SceneCharacter = null, value2:AvatarPart = null) : void
	                {
	                    if ($includeCenter)
	                    {
	                        toArr.unshift(centerSc);
	                    }
	                    else
	                    {
	                        scene.removeCharacter(centerSc);
	                    }
	                    showMagic($from, toArr, null, $toApd, null);
	                    return;
	                }
	                ;
                    tempToApd = new AvatarParamData();
                    tempToApd.extendCallBack(MAGIC_STATUS,null, new_onPlayStart_for_to);
                    showMagic($from, [centerSc], $fromApd, tempToApd, $passApd);
                }
                else
                {
                    if ($includeCenter)
                    {
                        toArr.unshift(centerSc);
                    }
                    else
                    {
                        scene.removeCharacter(centerSc);
                    }
                    showMagic($from, toArr, $fromApd, $toApd, null);
                }
                return;
            }
            ;
            $from.faceTo($toRectCenter.x, $toRectCenter.y);
            if ($from.type != SceneCharacterType.DUMMY)
            {
                if (!$from.isJumping())
                {
                    $from.playTo(CharStatusType.ATTACK, -1, -1, new AvatarPlayCondition(true));
                    $from.showAttack = showAttack;
                }
                else
                {
                    showAttack();
                }
            }
            else
            {
                showAttack();
            }
            hasRun;
            return;
        }
		/**
		 * 
		 * @param $from
		 * @param $toRectCenter
		 * @param $toRectHalfWidth
		 * @param $toRectHalfHeight
		 * @param $showSpace
		 * @param $includeCenter
		 * @param $fromApd
		 * @param $toApd
		 * @param $passApd
		 * 
		 */
        public static function showMagic_from1passNtoRectArea($from:SceneCharacter, $toRectCenter:Point, $toRectHalfWidth:int, $toRectHalfHeight:int, $showSpace:int = 30, $includeCenter:Boolean = true, $fromApd:AvatarParamData = null, $toApd:AvatarParamData = null, $passApd:AvatarParamData = null) : void
        {
            var hasRun:Boolean;
            var showAttack:Function;
            showAttack = function () : void
            {
                var scene:Scene;
                var pixelX:int;
                var pixelY:int;
                var toSc:SceneCharacter;
                var i:int;
                var j:int;
                var new_onPlayComplete:Function;
                new_onPlayComplete = function (value1:SceneCharacter = null, value2:AvatarPart = null) : void
                {
                    scene.removeCharacter(value1);
                    return;
                }
                ;
                if (hasRun)
                {
                    return;
                }
                hasRun = true;
                scene = $from.scene;
                var toArr:Array;
                i = 0;
                while (i <= $toRectHalfWidth)
                {
                    
                    j= 0;
                    while (j <= $toRectHalfHeight)
                    {
                        
                        if (i == 0 && j == 0)
                        {
                            pixelX = $toRectCenter.x;
                            pixelY = $toRectCenter.y;
                            if ($includeCenter)
                            {
                                toSc = scene.createSceneCharacter(SceneCharacterType.DUMMY);
                                toSc.setXY(pixelX, pixelY);
                                toArr.push(toSc);
                            }
                        }
                        else if (i == 0 && j != 0)
                        {
                            pixelX = $toRectCenter.x;
                            pixelY = $toRectCenter.y + j;
                            toSc = scene.createSceneCharacter(SceneCharacterType.DUMMY);
                            toSc.setXY(pixelX, pixelY);
                            toArr.push(toSc);
                            pixelX = $toRectCenter.x;
                            pixelY = $toRectCenter.y - j;
                            toSc = scene.createSceneCharacter(SceneCharacterType.DUMMY);
                            toSc.setXY(pixelX, pixelY);
                            toArr.push(toSc);
                        }
                        else if (i != 0 && j == 0)
                        {
                            pixelX = $toRectCenter.x + i;
                            pixelY = $toRectCenter.y;
                            toSc = scene.createSceneCharacter(SceneCharacterType.DUMMY);
                            toSc.setXY(pixelX, pixelY);
                            toArr.push(toSc);
                            pixelX = $toRectCenter.x - i;
                            pixelY = $toRectCenter.y;
                            toSc = scene.createSceneCharacter(SceneCharacterType.DUMMY);
                            toSc.setXY(pixelX, pixelY);
                            toArr.push(toSc);
                        }
                        else
                        {
                            pixelX = $toRectCenter.x + i;
                            pixelY = $toRectCenter.y + j;
                            toSc = scene.createSceneCharacter(SceneCharacterType.DUMMY);
                            toSc.setXY(pixelX, pixelY);
                            toArr.push(toSc);
                            pixelX = $toRectCenter.x + i;
                            pixelY = $toRectCenter.y - j;
                            toSc = scene.createSceneCharacter(SceneCharacterType.DUMMY);
                            toSc.setXY(pixelX, pixelY);
                            toArr.push(toSc);
                            pixelX = $toRectCenter.x - i;
                            pixelY = $toRectCenter.y + j;
                            toSc = scene.createSceneCharacter(SceneCharacterType.DUMMY);
                            toSc.setXY(pixelX, pixelY);
                            toArr.push(toSc);
                            pixelX = $toRectCenter.x - i;
                            pixelY = $toRectCenter.y - j;
                            toSc = scene.createSceneCharacter(SceneCharacterType.DUMMY);
                            toSc.setXY(pixelX, pixelY);
                            toArr.push(toSc);
                        }
                        j = j + $showSpace;
                    }
                    i = i + $showSpace;
                }
                $toApd = $toApd || new AvatarParamData();
                $toApd.extendCallBack(MAGIC_STATUS,null, null, null, new_onPlayComplete);
                showMagic($from, toArr, $fromApd, $toApd, $passApd);
                return;
            }
            ;
            $from.faceTo($toRectCenter.x, $toRectCenter.y);
            if ($from.type != SceneCharacterType.DUMMY)
            {
                if (!$from.isJumping())
                {
                    $from.playTo(CharStatusType.ATTACK, -1, -1, new AvatarPlayCondition(true));
                    $from.showAttack = showAttack;
                }
                else
                {
                    showAttack();
                }
            }
            else
            {
                showAttack();
            }
            hasRun;
            return;
        }
		/**
		 * 
		 * @param $from
		 * @param $toCircleCenter
		 * @param $toCircleR
		 * @param $edgeEffectCount
		 * @param $showSpace
		 * @param $includeCenter
		 * @param $fromApd
		 * @param $toApd
		 * @param $passApd
		 * 
		 */
        public static function showMagic_from1pass1toCircleArea($from:SceneCharacter, $toCircleCenter:Point, $toCircleR:int, $edgeEffectCount:int = 10, $showSpace:int = 30, $includeCenter:Boolean = true, $fromApd:AvatarParamData = null, $toApd:AvatarParamData = null, $passApd:AvatarParamData = null) : void
        {
            var hasRun:Boolean;
            var showAttack:Function;
            showAttack = function () : void
            {
                var scene:Scene;
                var toArr:Array;
                var pixelX:int;
                var pixelY:int;
                var toSc:SceneCharacter;
                var centerSc:SceneCharacter;
                var r:int;
                var rad:Number;
                var new_onPlayComplete:Function;
                var tempToApd:AvatarParamData;
                new_onPlayComplete = function (value1:SceneCharacter = null, value2:AvatarPart = null) : void
                {
                    scene.removeCharacter(value1);
                    return;
                }
                ;
                if (hasRun)
                {
                    return;
                }
                hasRun = true;
                scene = $from.scene;
                toArr =  [];
                var pi2:* = Math.PI * 2;
                var stepRad:* = pi2 / $edgeEffectCount;
                r=0;
                while (r <= $toCircleR)
                {
                    
                    if (r == 0)
                    {
                        pixelX = $toCircleCenter.x;
                        pixelY = $toCircleCenter.y;
                        centerSc = scene.createSceneCharacter(SceneCharacterType.DUMMY);
                        centerSc.setXY(pixelX, pixelY);
                    }
                    else
                    {
                        rad=0;
                        while (rad < pi2)
                        {
                            
                            pixelX = $toCircleCenter.x + r * Math.cos(rad);
                            pixelY = $toCircleCenter.y + r * Math.sin(rad);
                            toSc = scene.createSceneCharacter(SceneCharacterType.DUMMY);
                            toSc.setXY(pixelX, pixelY);
                            toArr.push(toSc);
                            rad = rad + stepRad;
                        }
                    }
                    r = r + $showSpace;
                }
                $toApd = $toApd || new AvatarParamData();
                $toApd.extendCallBack(MAGIC_STATUS,null, null, null, new_onPlayComplete);
                if ($passApd != null)
                {
                    var new_onPlayStart_for_to:Function = function (value1:SceneCharacter = null, value2:AvatarPart = null) : void
	                {
	                    if ($includeCenter)
	                    {
	                        toArr.unshift(centerSc);
	                    }
	                    else
	                    {
	                        scene.removeCharacter(centerSc);
	                    }
	                    showMagic($from, toArr, null, $toApd, null);
	                    return;
	                }                ;
                    tempToApd = new AvatarParamData();
                    tempToApd.extendCallBack(MAGIC_STATUS,null, new_onPlayStart_for_to);
                    showMagic($from, [centerSc], $fromApd, tempToApd, $passApd);
                }
                else
                {
                    if ($includeCenter)
                    {
                        toArr.unshift(centerSc);
                    }
                    else
                    {
                        scene.removeCharacter(centerSc);
                    }
                    showMagic($from, toArr, $fromApd, $toApd, null);
                }
                return;
            }
            ;
            $from.faceTo($toCircleCenter.x, $toCircleCenter.y);
            if ($from.type != SceneCharacterType.DUMMY)
            {
                if (!$from.isJumping())
                {
                    $from.playTo(CharStatusType.ATTACK, -1, -1, new AvatarPlayCondition(true));
                    $from.showAttack = showAttack;
                }
                else
                {
                    showAttack();
                }
            }
            else
            {
                showAttack();
            }
            hasRun;
            return;
        }
		/**
		 * 
		  * @param $from
		 * @param $toCircleCenter 原中心
		 * @param $toCircleR 圆半径
		 * @param $edgeEffectCount 攻击个数
		 * @param $showSpace 半径r之间的间隔
		 * @param $includeCenter 是否在园中心
		 * @param $fromApd
		 * @param $toApd
		 * @param $passApd
		 * 序列化攻击圆形区域
		 * 
		 */
        public static function showMagic_from1passNtoCircleArea($from:SceneCharacter, $toCircleCenter:Point, $toCircleR:int, $edgeEffectCount:int = 10, $showSpace:int = 30, $includeCenter:Boolean = true, $fromApd:AvatarParamData = null, $toApd:AvatarParamData = null, $passApd:AvatarParamData = null) : void
        {
            var hasRun:Boolean;
            var showAttack:Function;
            showAttack = function () : void
            {
                var scene:Scene;
                var pixelX:int;
                var pixelY:int;
                var toSc:SceneCharacter;
                var r:int;
                var rad:Number;
                var new_onPlayComplete:Function;
                new_onPlayComplete = function (value1:SceneCharacter = null, value2:AvatarPart = null) : void
                {
                    scene.removeCharacter(value1);
                    return;
                }
                ;
                if (hasRun)
                {
                    return;
                }
                hasRun = true;
                scene = $from.scene;
                var toArr:Array;
                var pi2:* = Math.PI * 2;
                var stepRad:* = pi2 / $edgeEffectCount;
                r=0;
                while (r <= $toCircleR)
                {
                    
                    if (r == 0)
                    {
                        pixelX = $toCircleCenter.x;
                        pixelY = $toCircleCenter.y;
                        if ($includeCenter)
                        {
                            toSc = scene.createSceneCharacter(SceneCharacterType.DUMMY);
                            toSc.setXY(pixelX, pixelY);
                            toArr.push(toSc);
                        }
                    }
                    else
                    {
                        rad=0;
                        while (rad < pi2)
                        {
                            
                            pixelX = $toCircleCenter.x + r * Math.cos(rad);
                            pixelY = $toCircleCenter.y + r * Math.sin(rad);
                            toSc = scene.createSceneCharacter(SceneCharacterType.DUMMY);
                            toSc.setXY(pixelX, pixelY);
                            toArr.push(toSc);
                            rad = rad + stepRad;
                        }
                    }
                    r = r + $showSpace;
                }
                $toApd = $toApd || new AvatarParamData();
                $toApd.extendCallBack(MAGIC_STATUS,null, null, null, new_onPlayComplete);
                showMagic($from, toArr, $fromApd, $toApd, $passApd);
                return;
            }
            ;
            $from.faceTo($toCircleCenter.x, $toCircleCenter.y);
            if ($from.type != SceneCharacterType.DUMMY)
            {
                if (!$from.isJumping())
                {
                    $from.playTo(CharStatusType.ATTACK, -1, -1, new AvatarPlayCondition(true));
                    $from.showAttack = showAttack;
                }
                else
                {
                    showAttack();
                }
            }
            else
            {
                showAttack();
            }
            hasRun;
            return;
        }
		/**
		 * 
		 * @param $from
		 * @param $toCircleCenter 原中心
		 * @param $toCircleR 圆半径
		 * @param $edgeEffectCount 攻击个数
		 * @param $showSpace 半径r之间的间隔
		 * @param $includeCenter 是否在园中心
		 * @param $fromApd
		 * @param $toApd
		 * @param $passApd
		 * @param $delay 每个间隔延迟时间、毫秒
		 * 序列化攻击圆形区域
		 */		
        public static function showMagic_from1pass0toCircleArea_byQueue($from:SceneCharacter, $toCircleCenter:Point, $toCircleR:int, $edgeEffectCount:int = 10, $showSpace:int = 30, $includeCenter:Boolean = true, $fromApd:AvatarParamData = null, $toApd:AvatarParamData = null, $passApd:AvatarParamData = null, $delay:int = 10) : void
        {
            var hasRun:Boolean;
            var showAttack:Function;
            showAttack = function () : void
            {
                var scene:Scene;
                var toArr:Array;
                var pixelX:int;
                var pixelY:int;
                var toSc:SceneCharacter;
                var r:int;
                var rad:Number;
                var new_onPlayComplete:Function;
                var tryShowMagic:Function;
                new_onPlayComplete = function (value1:SceneCharacter = null, value2:AvatarPart = null) : void
                {
                    scene.removeCharacter(value1);
                    return;
                }
                ;
                tryShowMagic = function () : void
                {
                    if (toArr.length == 0)
                    {
                        return;
                    }
                    if (!$from.usable)
                    {
                        for each (toSc in toArr)
                        {
                            
                            scene.removeCharacter(toSc);
                        }
                        toArr.length = 0;
                        return;
                    }
                    toSc = toArr.shift();
                    if (toSc.usable && toSc.data == "showMagic_from1pass0toCircleArea_byQueue")
                    {
                        showMagic($from, [toSc], $fromApd, $toApd, $passApd);
                        $fromApd = null;
                        TimerManager.addDelayCallBack($delay, tryShowMagic);
                    }
                    else
                    {
                        tryShowMagic();
                    }
                    return;
                }
                ;
                if (hasRun)
                {
                    return;
                }
                hasRun = true;
                scene = $from.scene;
                toArr = [];
                var pi2:* = Math.PI * 2;
                var stepRad:* = pi2 / $edgeEffectCount;
                var fromRad:* = Transformer.transLogicAngle2Angle($from.getLogicAngle()) / 180 * Math.PI;
                r = 0 ;
                while (r <= $toCircleR)
                {
                    
                    if (r == 0)
                    {
                        pixelX = $toCircleCenter.x;
                        pixelY = $toCircleCenter.y;
                        if ($includeCenter)
                        {
                            toSc = scene.createSceneCharacter(SceneCharacterType.DUMMY);
                            toSc.data = "showMagic_from1pass0toCircleArea_byQueue";
                            toSc.setXY(pixelX, pixelY);
                            toArr.push(toSc);
                        }
                    }
                    else
                    {
                        rad=0;
                        while (rad < pi2)
                        {
                            
                            pixelX = $toCircleCenter.x + r * Math.cos(fromRad + rad);
                            pixelY = $toCircleCenter.y + r * Math.sin(fromRad + rad);
                            toSc = scene.createSceneCharacter(SceneCharacterType.DUMMY);
                            toSc.data = "showMagic_from1pass0toCircleArea_byQueue";
                            toSc.setXY(pixelX, pixelY);
                            toArr.push(toSc);
                            rad = rad + stepRad;
                        }
                    }
                    r = r + $showSpace;
                }
                $toApd = $toApd || new AvatarParamData();
                $toApd.extendCallBack(MAGIC_STATUS,null, null, null, new_onPlayComplete);
                return;
            }
            ;
            $from.faceTo($toCircleCenter.x, $toCircleCenter.y);
            if ($from.type != SceneCharacterType.DUMMY)
            {
                if (!$from.isJumping())
                {
                    $from.playTo(CharStatusType.ATTACK, -1, -1, new AvatarPlayCondition(true));
                    $from.showAttack = showAttack;
                }
                else
                {
                    showAttack();
                }
            }
            else
            {
                showAttack();
            }
            hasRun;
            return;
        }
		/**
		 * 
		 * @param $from
		 * @param $toSectorOutCenter
		 * @param $centralAngle
		 * @param $passCount
		 * @param $fromApd
		 * @param $toApd
		 * @param $passApd
		 * 扇形区域技能
		 */
        public static function showMagic_from1passNtoSectorEdge($from:SceneCharacter, $toSectorOutCenter:Point, $centralAngle:Number = 30, $passCount:int = 10, $fromApd:AvatarParamData = null, $toApd:AvatarParamData = null, $passApd:AvatarParamData = null) : void
        {
            var hasRun:Boolean;
            var showAttack:Function;
            showAttack = function () : void
            {
                var scene:Scene;
                var startSectorPoint:Point;
                var stepAngle:Number;
                var toSc:SceneCharacter;
                var i:int;
                var new_onPlayComplete:Function;
                var stepSectorPoint:Point;
                new_onPlayComplete = function (value1:SceneCharacter = null, value2:AvatarPart = null) : void
                {
                    scene.removeCharacter(value1);
                    return;
                }
                ;
                if (hasRun)
                {
                    return;
                }
                hasRun = true;
                scene = $from.scene;
                var toArr:Array;
                if ($passCount == 1)
                {
                    startSectorPoint = $toSectorOutCenter.clone();
                }
                else if ($centralAngle == 360 && $passCount == 2)
                {
                    startSectorPoint = $toSectorOutCenter.clone();
                }
                else
                {
                    startSectorPoint = ZMath.getRotPoint($toSectorOutCenter, new Point($from.pixel_x, $from.pixel_y), (-$centralAngle) / 2);
                }
                if ($passCount == 1)
                {
                    stepAngle;
                }
                else if ($centralAngle == 360 && $passCount == 2)
                {
                    stepAngle = $centralAngle / 2;
                }
                else
                {
                    stepAngle = $centralAngle / ($passCount - 1);
                }
                i = 0;
                while (i < $passCount)
                {
                    
                    if ($centralAngle == 360 && $passCount > 1 && i == ($passCount - 1))
                    {
                    }
                    else
                    {
                        stepSectorPoint = ZMath.getRotPoint(startSectorPoint, new Point($from.pixel_x, $from.pixel_y), stepAngle * i);
                        toSc = scene.createSceneCharacter(SceneCharacterType.DUMMY);
                        toSc.setXY(stepSectorPoint.x, stepSectorPoint.y);
                        toSc.data = ($passCount - i) * i;
                        toArr.push(toSc);
                    }
                    i = (i + 1);
                }
                toArr.sortOn(["data"], Array.DESCENDING | Array.NUMERIC);
                $toApd = $toApd || new AvatarParamData();
                $toApd.extendCallBack(MAGIC_STATUS,null, null, null, new_onPlayComplete);
                showMagic($from, toArr, $fromApd, $toApd, $passApd);
                return;
            }
            ;
            if ($centralAngle < 0 || $centralAngle > 360)
            {
                $centralAngle = ($centralAngle % 360 + 360) % 360;
            }
            if ($passCount < 1)
            {
                $passCount;
            }
            if ($centralAngle == 0)
            {
                $passCount;
            }
            if ($centralAngle == 360)
            {
                $passCount = ($passCount + 1);
            }
            $from.faceTo($toSectorOutCenter.x, $toSectorOutCenter.y);
            if ($from.type != SceneCharacterType.DUMMY)
            {
                if (!$from.isJumping())
                {
                    $from.playTo(CharStatusType.ATTACK, -1, -1, new AvatarPlayCondition(true));
                    $from.showAttack = showAttack;
                }
                else
                {
                    showAttack();
                }
            }
            else
            {
                showAttack();
            }
            hasRun = false;
            return;
        }
		/**
		 * 
		 * @param $from
		 * @param $toArr
		 * @param $fromApd
		 * @param $toApd
		 * @param $passApd
		 * 
		 */
        public static function showMagic($from:SceneCharacter, $toArr:Array, $fromApd:AvatarParamData = null, $toApd:AvatarParamData = null, $passApd:AvatarParamData = null) : void
        {
            var passAndHit:Function;
            passAndHit = function (value1:SceneCharacter = null, value2:AvatarPart = null) : void
            {
                var sc:SceneCharacter = null;
                if ($passApd == null || $from == null )
                {
                    for each (sc in $toArr)
                    {
                        if (sc.usable)
                        {
                            sc.loadAvatarPart($toApd);
                            continue;
                        }
                        if ($toApd != null)
                        {
                            $toApd.executeCallBack(sc);
                        }
                    }
                }
                else
                {
                    for each (sc in $toArr)
                    {
                        showTweenAvatarPart($from, sc, $toApd != null ? ($toApd.clone()) : (null), $passApd != null ? ($passApd.clone()) : (null));
                    }
                }
                return;
            }
            ;
            $fromApd = $fromApd ? ($fromApd.clone()) : (new AvatarParamData());
            $fromApd.extendCallBack(MAGIC_STATUS,null, passAndHit, null, null);
            $from.loadAvatarPart($fromApd);
            return;
        }
		
		/**
		 * 
		 * @param $from
		 * @param $toP 像素坐标
		 * @param $fromApd
		 * @param $toApd
		 * @param $passApd
		 * 
		 */
		public static function showMagic_from1pass1toPoint_NoPath($from:SceneCharacter, $toP:Point, $fromApd:AvatarParamData = null, $toApd:AvatarParamData = null, $passApd:AvatarParamData = null) : void
		{
			var hasRun:Boolean;
			var showAttack:Function;
			showAttack = function () : void
			{
				var scene:Scene;
				var new_onPlayComplete:Function;
				new_onPlayComplete = function (value1:SceneCharacter = null, value2:AvatarPart = null) : void
				{
					scene.removeCharacter(value1);
					return;
				};
				if (hasRun)
				{
					return;
				}
				hasRun = true;
				scene = $from.scene;
				var toSc:* = scene.createSceneCharacter(SceneCharacterType.DUMMY);
				toSc.setTileXY($toP.x, $toP.y);
				$toApd = $toApd || new AvatarParamData();
				$toApd.extendCallBack(MAGIC_STATUS, null,null, null, new_onPlayComplete);
				showMagic_NoPath($from, [toSc], $fromApd, $toApd, $passApd);
				return;
			};
			$from.faceToTile($toP.x, $toP.y);
			if ($from.type != SceneCharacterType.DUMMY)
			{
				if (!$from.isJumping())
				{
					$from.playTo(CharStatusType.ATTACK, -1, -1, new AvatarPlayCondition(true));
					$from.showAttack = showAttack;
				}
				else
				{
					showAttack();
				}
			}
			else
			{
				showAttack();
			}
			hasRun;
			return;
		}
		/**
		 * 
		 * @param $from
		 * @param $toArr
		 * @param $fromApd
		 * @param $toApd
		 * @param $passApd
		 * 
		 */
		public static function showMagic_NoPath($from:SceneCharacter, $toArr:Array, $fromApd:AvatarParamData = null, $toApd:AvatarParamData = null, $passApd:AvatarParamData = null) : void
		{
			var passAndHit:Function;
			passAndHit = function (value1:SceneCharacter = null, value2:AvatarPart = null) : void
			{
				var sc:SceneCharacter = null;
				if ($passApd == null )
				{
					for each (sc in $toArr)
					{
						if (sc.usable)
						{
							sc.loadAvatarPart($toApd);
							continue;
						}
						if ($toApd != null)
						{
							$toApd.executeCallBack(sc);
						}
					}
				}
				else
				{
					for each (sc in $toArr)
					{
						showAvatarPart($from, sc, $toApd != null ? ($toApd.clone()) : (null), $passApd != null ? ($passApd.clone()) : (null));
					}
				}
				return;
			};
			if( $fromApd == null ){
				passAndHit();
			}else{
				
				$fromApd = $fromApd ? ($fromApd.clone()) : (new AvatarParamData());
				$fromApd.extendCallBack(MAGIC_STATUS,null, passAndHit, null, null);
				$from.loadAvatarPart($fromApd);
			}
			return;
		}
		
		/**
		 * 
		 * @param $fromSc
		 * @param $toSc
		 * @param $toApd
		 * @param $passApd
		 * 落石技能等，非弹道技能。
		 */
        private static function showAvatarPart($fromSc:SceneCharacter, $toSc:SceneCharacter, $toApd:AvatarParamData, $passApd:AvatarParamData) : void
        {
			var scene:Scene;
			var passSc:SceneCharacter;
			var new_onPlayBeforeStart:Function;
			new_onPlayBeforeStart = function (value1:SceneCharacter = null, value2:AvatarPart = null) : void
			{
				scene.removeCharacter(passSc,true);
				$toSc.loadAvatarPart($toApd);
				return;
			};			
			scene = $toSc.scene ;
			$passApd = $passApd || new AvatarParamData();
			$passApd.extendCallBack(MAGIC_STATUS,null,null,null,new_onPlayBeforeStart);
			passSc = scene.createSceneCharacter(SceneCharacterType.DUMMY);
			passSc.setTileXY($toSc.tile_x,$toSc.tile_y);
			passSc.loadAvatarPart($passApd);
			return;
		}
		
		/**
		 * 
		 * @param $fromSc
		 * @param $toSc
		 * @param $toApd
		 * @param $passApd
		 * 
		 */
        private static function showTweenAvatarPart($fromSc:SceneCharacter, $toSc:SceneCharacter, $toApd:AvatarParamData, $passApd:AvatarParamData) : void
        {
            var scene:Scene;
            var passSc:SceneCharacter;
            var new_onPlayBeforeStart:Function;
            new_onPlayBeforeStart = function (value1:SceneCharacter = null, value2:AvatarPart = null) : void
            {
                passSc.setXY($fromSc.pixel_x + $passApd.offsetDandaoStartX, $fromSc.pixel_y + $passApd.offsetDandaoStartY);
                tweenDandao(passSc, $toSc, hitIt, [scene, passSc, $toSc, $toApd]);
                return;
            };
			if( !$fromSc.usable ){
				trace("tween fromSc dispose");
				return ;
			}
            scene = $fromSc.scene;
            $passApd = $passApd || new AvatarParamData();
            $passApd.extendCallBack(MAGIC_STATUS,new_onPlayBeforeStart);
            passSc = scene.createSceneCharacter(SceneCharacterType.DUMMY);
            passSc.setXY($fromSc.pixel_x + $passApd.offsetDandaoStartX, $fromSc.pixel_y + $passApd.offsetDandaoStartY);
            var p0:Point = new Point(passSc.pixel_x, passSc.pixel_y);
            var p1:Point = new Point($toSc.pixel_x, $toSc.pixel_y);
            var angel:int = ZMath.getTowPointsAngle(p0, p1);
            $passApd.rotation = angel - 90;
            passSc.loadAvatarPart($passApd);
            return;
        }

        private static function tweenDandao($passSc:SceneCharacter, $toSc:SceneCharacter, $hitIt:Function, $callBackValues:Array = null, $point:Point = null) : void
        {
            var _p1:Point = null;
            var _p2:Point = null;
            var _dis:Number = NaN;
            var _time:Number = NaN;
            var _angle:Number = NaN;
            if (!$toSc.usable || !$passSc.usable)
            {
                HandlerHelper.execute(hitIt, $callBackValues);
                return;
            }
			TweenPlugin.activate([DynamicPropsPlugin]);
			$point = $point != null ? ($point) : (new Point(int.MAX_VALUE, int.MIN_VALUE));
			function getMouseX():Number {
				if( !$toSc.usable ){
					if( $passSc.usable ){
						$passSc.scene.removeCharacter($passSc);
					}
					TweenLite.killTweensOf($passSc);
				}
				return $toSc.pixel_x ;
			}
			function getMouseY():Number {
				if( !$toSc.usable ){
					if( $passSc.usable ){
						$passSc.scene.removeCharacter($passSc);
					}
					TweenLite.killTweensOf($passSc);
				}
				return $toSc.pixel_y ;
			}
			if ($point.x != $toSc.pixel_x || $point.y != $toSc.pixel_y)
            {
                $point.x = $toSc.pixel_x;
                $point.y = $toSc.pixel_y;
                TweenLite.killTweensOf($passSc);
                _p1 = new Point($passSc.pixel_x, $passSc.pixel_y);
                _p2 = new Point($toSc.pixel_x, $toSc.pixel_y);
                _dis = Point.distance(_p1, _p2);
				if( _dis <= 10 ){
					HandlerHelper.execute(hitIt, $callBackValues);
					return ;
				}
                _time = _dis * 0.0014;
                _angle = ZMath.getTowPointsAngle(_p1, _p2);
                $passSc.playTo(null, -1, _angle - 90);
                TweenLite.to($passSc, _time, {dynamicProps:{pixel_x:getMouseX, pixel_y:getMouseY },orientToBezier:true,ease:Linear.easeNone, onComplete:$hitIt, onCompleteParams:$callBackValues});
			}
            return;
        }

        private static function hitIt($scene:Scene, sc:SceneCharacter, $toSc:SceneCharacter, apd:AvatarParamData) : void
        {
            TweenLite.killTweensOf(sc);
            $scene.removeCharacter(sc);
            if (!$toSc.usable)
            {
                if (apd != null)
                {
                    apd.executeCallBack($toSc,null,MAGIC_STATUS);
                }
            }
            else
            {
                $toSc.loadAvatarPart(apd);
            }
            return;
        }

    }
}
