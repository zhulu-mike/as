package com.thinkido.framework.engine.move
{
    import com.greensock.TweenMax;
    import com.greensock.easing.Cubic;
    import com.greensock.easing.Expo;
    import com.greensock.easing.Linear;
    import com.thinkido.framework.common.handler.helper.HandlerHelper;
    import com.thinkido.framework.common.utils.ZMath;
    import com.thinkido.framework.engine.Engine;
    import com.thinkido.framework.engine.SceneCharacter;
    import com.thinkido.framework.engine.staticdata.CharAngleType;
    import com.thinkido.framework.engine.staticdata.CharStatusType;
    import com.thinkido.framework.engine.tools.SceneCache;
    import com.thinkido.framework.engine.utils.SceneUtil;
    import com.thinkido.framework.engine.vo.avatar.AvatarPlayCondition;
    import com.thinkido.framework.engine.vo.map.MapTile;
    import com.thinkido.framework.engine.vo.move.MoveCallBack;
    
    import flash.geom.Point;

    public class Teleport extends Object
    {

        public function Teleport()
        {
            return;
        }

        public static function lineTo($sc:SceneCharacter, $tileP:Point, $speed:Number, $isPetJump:Boolean = false, $callBack:MoveCallBack = null) : void
        {
            var mapTile:MapTile;
            var p1:Point;
            var easeFun:Function;
            var hasSolid:Boolean;
            var tm:TweenMax;            
            TweenMax.killTweensOf($sc);
            $sc.moveData.clear();
            if ($speed == 0)
            {
                return;
            }
            var fromTile:MapTile = SceneCache.mapTiles[$sc.tile_x + "_" + $sc.tile_y];
            mapTile = SceneCache.mapTiles[$tileP.x + "_" + $tileP.y];
            if (fromTile == null || mapTile == null)
            {
				$sc.data.isBeat = false ;	
                return;
            }
            var p0:Point = new Point($sc.pixel_x, $sc.pixel_y);
            p1 = new Point(mapTile.pixel_x, mapTile.pixel_y);
            var angle:Number = ZMath.getTowPointsAngle(p0, p1);
            var distance:Number = Point.distance(p0, p1);
            if ($isPetJump)
            {
                hasSolid = SceneUtil.hasSolidBetween2MapTile(fromTile, mapTile);
                if (hasSolid)
                {
                    $sc.visible = false;
                }
                else if ($sc.scene.isAlwaysShowChar($sc) || $sc.scene.getCharVisible($sc.type))
                {
                    $sc.visible = true;
                }
                angle = ZMath.getNearAngel(angle - 90);
                $sc.playTo(CharStatusType.WALK, CharAngleType["ANGEL_" + angle], -1, new AvatarPlayCondition(true));
                easeFun = Linear.easeNone;
            }
            else
            {
                easeFun = Expo.easeOut;
            }
            $sc.specilize_x = $sc.pixel_x;
            $sc.specilize_y = $sc.pixel_y;
            if ($callBack != null && $callBack.onMoveReady != null)
            {
                $callBack.onMoveReady($sc, fromTile, mapTile);
            }
            var time:* = $isPetJump ? (Math.max(distance / $speed, 0.7)) : (distance / $speed);
            tm = TweenMax.to($sc, time, {pixel_x:p1.x, pixel_y:p1.y, specilize_x:p1.x, specilize_y:p1.y, ease:easeFun, onUpdate:function () : void
	            {
	                if ($sc.usable == false)
	                {
						tm.kill() ;
						$sc.data.isBeat = false ;	
						return;
	                }
	                if (Engine.enableJumpStop)
	                {
	                    if ($sc.getStatus() == CharStatusType.DEATH)
	                    {
	                        $sc.moveData.clear();
	                        if ($isPetJump)
	                        {
	                            if ($sc.scene.isAlwaysShowChar($sc) || $sc.scene.getCharVisible($sc.type))
	                            {
	                                $sc.visible = true;
	                            }
	                        }
	                        mapTile = SceneCache.mapTiles[$sc.tile_x + "_" + $sc.tile_y];
	                        if ($callBack != null && $callBack.onMoveArrived != null)
	                        {
	                            $callBack.onMoveArrived($sc, mapTile);
	                        }
							tm.kill() ;
	                        return;
	                    }
	                }
	                return;
	            }
            , onComplete:function () : void
	            {
					$sc.data.isBeat = false ;
					if (!$sc.usable)
	                {
						return;
	                }
	                $sc.moveData.clear();
	                if ($isPetJump)
	                {
	                    if ($sc.scene.isAlwaysShowChar($sc) || $sc.scene.getCharVisible($sc.type))
	                    {
	                        $sc.visible = true;
	                    }
	                    if ($sc.getStatus() != CharStatusType.DEATH)
	                    {
	                        $sc.playTo(CharStatusType.STAND);
	                    }
	                }
	                $sc.setXY(p1.x, p1.y);
	                if ($callBack != null && $callBack.onMoveArrived != null)
	                {
	                    $callBack.onMoveArrived($sc, mapTile);
	                }
	                return;
	            }
            });
            return;
        }

        public static function lineToPiexl($sc:SceneCharacter, $pixelP:Point, $speed:Number, $onComplete:Function = null) : void
        {
            var p1:Point;
            var tm:TweenMax;
            var tm1:TweenMax;
            TweenMax.killTweensOf($sc);
            $sc.moveData.clear();
            if ($speed == 0)
            {
                return;
            }
            var p0:Point = new Point($sc.pixel_x, $sc.pixel_y);
            p1 = new Point($pixelP.x, $pixelP.y);
            var distance:* = Point.distance(p0, p1);
            $sc.specilize_x = $sc.pixel_x;
            $sc.specilize_y = $sc.pixel_y;
            var time:* = distance / $speed;
            tm = TweenMax.to($sc, time, {pixel_x:p1.x, pixel_y:p1.y, specilize_x:p1.x,overwrite:3, specilize_y:p1.y, ease:Cubic.easeOut, onUpdate:function () : void
	            {
	                if ($sc.usable == false)
	                {
						tm.kill() ;
						tm1.kill() ;
	                    return;
	                }
	                return;
	            }
            , onComplete:function () : void
	            {
					if( $sc.isMainChar() ){
						tweenComplete();
					}else{
						TweenMax.to($sc, 0.4 , {alpha:0,delay:time, ease:Cubic.easeOut,onComplete:tweenComplete});
					}
	            }
            });
			
			var tweenComplete:Function = function():void{
				if (!$sc.usable)
				{
					return;
				}
				$sc.moveData.clear();
				$sc.setXY(p1.x, p1.y);
				if ($onComplete != null)
				{
					HandlerHelper.execute($onComplete,[$sc]);
				}
				return;
			}
            return;
        }

    }
}
