package com.thinkido.framework.engine.move
{
    import com.greensock.TweenLite;
    import com.greensock.TweenMax;
    import com.greensock.easing.Linear;
    import com.thinkido.framework.common.events.EventDispatchCenter;
    import com.thinkido.framework.common.utils.ZMath;
    import com.thinkido.framework.engine.Engine;
    import com.thinkido.framework.engine.SceneCharacter;
    import com.thinkido.framework.engine.events.SceneEvent;
    import com.thinkido.framework.engine.events.SceneEventAction_walk;
    import com.thinkido.framework.engine.staticdata.AvatarPartType;
    import com.thinkido.framework.engine.staticdata.CharAngleType;
    import com.thinkido.framework.engine.staticdata.CharStatusType;
    import com.thinkido.framework.engine.tools.SceneCache;
    import com.thinkido.framework.engine.utils.SceneUtil;
    import com.thinkido.framework.engine.vo.avatar.AvatarPlayCondition;
    import com.thinkido.framework.engine.vo.map.MapTile;
    import com.thinkido.framework.engine.vo.move.MoveCallBack;
    
    import flash.geom.Point;

    public class Jump extends Object
    {

        public function Jump()
        {
            return;
        }
		/**
		 * 
		 * @param $sc
		 * @param $tileP
		 * @param $speed
		 * @param $maxDis
		 * @param $jump_MoveCallBack
		 * @param $is2Jump
		 *  跳，点击距离超过最大取最大，
		 */
        public static function jump($sc:SceneCharacter, $tileP:Point, $speed:Number = -1, $maxDis:Number = -1, $jump_MoveCallBack:MoveCallBack = null, $is2Jump:Boolean = false) : void
        {
            var mapTile:MapTile;
            var evt:SceneEvent;
            var p1:Point;
                var jumpHight:Number = 0;
            var jumpSpeed:Number;
            var tm:TweenMax;
            var hasSolid:Boolean;
            if ($sc.isMainChar())
            {
                if (Engine.enable2Jump)
                {
                    if ($sc.on2Jumping())
                    {
                        return;
                    }
                }
                else if ($sc.isJumping())
                {
                    return;
                }
            }
            var fromTile:MapTile = SceneCache.mapTiles[$sc.tile_x + "_" + $sc.tile_y];
            mapTile = SceneCache.mapTiles[$tileP.x + "_" + $tileP.y];
            if (fromTile == null)
            {
                return;
            }
            if (mapTile == null)
            {
                return;
            }
            var p0:Point = new Point($sc.pixel_x, $sc.pixel_y);
            p1 = new Point(mapTile.pixel_x, mapTile.pixel_y);
            var angle:int = ZMath.getTowPointsAngle(p0, p1);
            var distance:int = Point.distance(p0, p1);
			if ($maxDis == -1)
			{
				$maxDis = $sc.moveData.jump_maxDis;
			}
            if ($sc.isMainChar())
            {
                mapTile = SceneUtil.getLineMapTile(fromTile, mapTile, $maxDis);
                if (fromTile.tile_x == mapTile.tile_x && fromTile.tile_y == mapTile.tile_y)
                {
                    if ($sc.isJumping())
                    {
                        return;
                    }
                }
                p1 = new Point(mapTile.pixel_x, mapTile.pixel_y);
                angle = ZMath.getTowPointsAngle(p0, p1);
                distance = Point.distance(p0, p1);
                $sc.scene.showMouseChar($tileP.x, $tileP.y);
                evt = new SceneEvent(SceneEvent.WALK, SceneEventAction_walk.SEND_JUMP_PATH, [$sc, fromTile, mapTile]);
                EventDispatchCenter.getInstance().dispatchEvent(evt);
            }
			if ($sc.isJumping())
			{
				TweenMax.killTweensOf($sc);
			}
            $sc.moveData.clear();
            if ($is2Jump)
            {
                $sc.moveData.isJumping = true;
                $sc.moveData.on2Jumping = false;
            }
            if ($speed == -1)
            {
                $speed = $sc.moveData.jump_speed;
            }
            $sc.moveData.jump_targetP = $tileP;
            $sc.moveData.jump_MoveCallBack = $jump_MoveCallBack;
            if ($speed == 0)
            {
                return;
            }
            if ($sc.isMainChar())
            {
                evt = new SceneEvent(SceneEvent.WALK, SceneEventAction_walk.JUMP_READY, [$sc, fromTile, mapTile]);
                EventDispatchCenter.getInstance().dispatchEvent(evt);
            }
            if ($jump_MoveCallBack != null && $jump_MoveCallBack.onMoveReady != null)
            {
                $jump_MoveCallBack.onMoveReady($sc, fromTile, mapTile);
            }
            if (!$is2Jump)
            {
                if ($sc.isOnMount)
                {
                    hasSolid = SceneUtil.hasSolidBetween2MapTile(fromTile, mapTile);
                    if (hasSolid)
                    {
                        $sc.hideAvatarPartsByType(AvatarPartType.MOUNT);
                    }
                    else if ($sc.scene.isAlwaysShowChar($sc) || $sc.scene.getCharAvatarVisible($sc.type))
                    {
                        $sc.showAvatarPartsByType(AvatarPartType.MOUNT);
                    }
                }
            }
            $sc.hideAvatarPartsByType(AvatarPartType.WEAPON);
            $sc.hideAvatarPartsByType(AvatarPartType.BOW);
            if ($is2Jump)
            {
                if (!$sc.isJumping())
                {
                    $sc.specilize_x = $sc.pixel_x;
                    $sc.specilize_y = $sc.pixel_y;
                }
                $sc.moveData.isJumping = true;
                $sc.moveData.on2Jumping = true;
                p0 = new Point($sc.specilize_x, $sc.specilize_y);
                angle = ZMath.getTowPointsAngle(p0, p1);
                jumpSpeed = $speed * 1.5;
                jumpHight = 300;
            }
            else
            {
                if (!$sc.isJumping())
                {
                    $sc.specilize_x = $sc.pixel_x;
                    $sc.specilize_y = $sc.pixel_y;
                }
                $sc.moveData.isJumping = true;
                $sc.moveData.on2Jumping = false;
                jumpSpeed = $speed;
                jumpHight = 300;
            }
            angle = ZMath.getNearAngel(angle - 90);
            $sc.playTo(CharStatusType.JUMP, CharAngleType["ANGEL_" + angle], -1, new AvatarPlayCondition(true, true));
            var middleX:Number = (p0.x + p1.x) >> 1;
            var middleY:Number = ((p0.y + p1.y) >> 1) - jumpHight;
            var time:Number = Math.max(distance / jumpSpeed, 0.5);
            tm = TweenMax.to($sc, time, {pixel_x:p1.x, pixel_y:p1.y, bezier:[{specilize_x:middleX, specilize_y:middleY}, {specilize_x:p1.x, specilize_y:p1.y}], ease:Linear.easeIn, onUpdate:function () : void
            {
                if ($sc.usable == false)
                {
					tm.kill();
                    return;
                }
                if (Engine.enableJumpStop)
                {
                    if ($sc.getStatus() == CharStatusType.DEATH)
                    {
                        if ($sc == $sc.scene.mainChar)
                        {
                            $sc.scene.hideMouseChar();
                        }
                        if ($sc.scene.isAlwaysShowChar($sc) || $sc.scene.getCharAvatarVisible($sc.type))
                        {
                            $sc.showAvatarPartsByType(AvatarPartType.MOUNT);
                        }
                        $sc.showAvatarPartsByType(AvatarPartType.WEAPON);
                        $sc.showAvatarPartsByType(AvatarPartType.BOW);
                        $sc.moveData.clear();
                        $sc.setXY($sc.pixel_x, $sc.pixel_y);
                        mapTile = SceneCache.mapTiles[$sc.tile_x + "_" + $sc.tile_y];
                        if ($sc == $sc.scene.mainChar)
                        {
                            evt = new SceneEvent(SceneEvent.WALK, SceneEventAction_walk.JUMP_ARRIVED, [$sc, mapTile]);
                            EventDispatchCenter.getInstance().dispatchEvent(evt);
                        }
                        if ($jump_MoveCallBack != null && $jump_MoveCallBack.onMoveArrived != null)
                        {
                            $jump_MoveCallBack.onMoveArrived($sc, mapTile);
                        }
						tm.kill();
                        return;
                    }
                }
                mapTile = SceneCache.mapTiles[$sc.tile_x + "_" + $sc.tile_y];
                if ($sc.isMainChar())
                {
                    evt = new SceneEvent(SceneEvent.WALK, SceneEventAction_walk.JUMP_THROUGH, [$sc, mapTile]);
                    EventDispatchCenter.getInstance().dispatchEvent(evt);
                }
                if ($jump_MoveCallBack != null && $jump_MoveCallBack.onMoveThrough != null)
                {
                    $jump_MoveCallBack.onMoveThrough($sc, mapTile);
                }
                return;
            }
            , onComplete:function () : void
            {
                if (!$sc.usable)
                {
                    return;
                }
                if ($sc == $sc.scene.mainChar)
                {
                    $sc.scene.hideMouseChar();
                }
                if ($sc.scene.isAlwaysShowChar($sc) || $sc.scene.getCharAvatarVisible($sc.type))
                {
                    $sc.showAvatarPartsByType(AvatarPartType.MOUNT);
                }
                $sc.showAvatarPartsByType(AvatarPartType.WEAPON);
                $sc.showAvatarPartsByType(AvatarPartType.BOW);
                $sc.moveData.clear();
                if ($sc.getStatus() != CharStatusType.DEATH)
                {
                    $sc.playTo(CharStatusType.STAND, -1, -1);
                }
                $sc.setXY(p1.x, p1.y);
                if ($sc == $sc.scene.mainChar)
                {
                    evt = new SceneEvent(SceneEvent.WALK, SceneEventAction_walk.JUMP_ARRIVED, [$sc, mapTile]);
                    EventDispatchCenter.getInstance().dispatchEvent(evt);
                }
                if ($jump_MoveCallBack != null && $jump_MoveCallBack.onMoveArrived != null)
                {
                    $jump_MoveCallBack.onMoveArrived($sc, mapTile);
                }
                return;
            }
            });
            return;
        }

        public static function breakJump(sc:SceneCharacter, $complete:Boolean = false, value3:Boolean = false) : void
        {
            if (!value3 && !Engine.enableJumpStop)
            {
                return;
            }
            if (!sc.usable)
            {
                return;
            }
            if (!sc.isJumping())
            {
                return;
            }
            TweenLite.killTweensOf(sc, $complete);
            if (!$complete)
            {
                if (sc == sc.scene.mainChar)
                {
                    sc.scene.hideMouseChar();
                }
                if (sc.scene.isAlwaysShowChar(sc) || sc.scene.getCharAvatarVisible(sc.type))
                {
                    sc.showAvatarPartsByType(AvatarPartType.MOUNT);
                }
                sc.showAvatarPartsByType(AvatarPartType.WEAPON);
                sc.showAvatarPartsByType(AvatarPartType.BOW);
                sc.moveData.clear();
                if (sc.getStatus() != CharStatusType.DEATH)
                {
                    sc.playTo(CharStatusType.STAND, -1, -1);
                }
            }
            return;
        }

    }
}
