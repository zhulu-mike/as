package com.thinkido.framework.engine.helper
{
    import com.thinkido.framework.common.events.EventDispatchCenter;
    import com.thinkido.framework.engine.SceneCharacter;
    import com.thinkido.framework.engine.events.SceneEvent;
    import com.thinkido.framework.engine.events.SceneEventAction_walk;
    import com.thinkido.framework.engine.move.Jump;
    import com.thinkido.framework.engine.move.PathConverter;
    import com.thinkido.framework.engine.move.PathCutter;
    import com.thinkido.framework.engine.move.Teleport;
    import com.thinkido.framework.engine.staticdata.CharStatusType;
    import com.thinkido.framework.engine.tools.SceneCache;
    import com.thinkido.framework.engine.utils.Astar;
    import com.thinkido.framework.engine.utils.SceneUtil;
    import com.thinkido.framework.engine.utils.Transformer;
    import com.thinkido.framework.engine.vo.map.MapTile;
    import com.thinkido.framework.engine.vo.move.MoveCallBack;
    
    import flash.geom.Point;
    import flash.utils.ByteArray;
    import flash.utils.getTimer;
    
    import org.osflash.thunderbolt.Logger;
	/**
	 * 移动帮助器 
	 * @author Administrator
	 * 
	 */
    public class MoveHelper extends Object
    {

        public function MoveHelper()
        {
            return;
        }
		/**
		 * 停止移动 
		 * @param sc
		 * @param stop
		 * @param param3
		 * 
		 */
        public static function stopMove(sc:SceneCharacter, stop:Boolean = true, param3:Boolean = false) : void
        {
            sc.breakJump(false, param3);
            sc.moveData.clear();
            if (sc == sc.scene.mainChar)
            {
                sc.scene.hideMouseChar();
            }
            if (stop && (sc.getStatus() == CharStatusType.WALK || sc.getStatus() == CharStatusType.JUMP))
            {
                sc.setStatus(CharStatusType.STAND);
            }
            return;
        }

        public static function reviseMove(sc:SceneCharacter) : void
        {
            if (sc == sc.scene.mainChar)
            {
                if (sc.avatar.status == CharStatusType.WALK)
                {
                    if (sc.moveData.walk_targetP != null)
                    {
                        walk(sc, sc.moveData.walk_targetP, -1, sc.moveData.walk_standDis, sc.moveData.walk_MoveCallBack);
                    }
                    else
                    {
                        sc.moveData.clear();
                    }
                }
                else if (sc.avatar.status == CharStatusType.JUMP)
                {
                    sc.stopMove(true, true);
                }
            }
            else
            {
                sc.moveData.clear();
            }
            return;
        }

        public static function jump(param1:SceneCharacter, param2:Point, param3:Number = -1, param4:Number = -1, param5:MoveCallBack = null, param6:Boolean = false) : void
        {
            Jump.jump(param1, param2, param3, param4, param5, param6);
            return;
        }

        public static function breakJump(param1:SceneCharacter, param2:Boolean = false, param3:Boolean = false) : void
        {
            Jump.breakJump(param1, param2, param3);
            return;
        }
		/**
		 * 
		 * @see Teleport#lineTo
		 */
        public static function lineTo(sc:SceneCharacter, $point:Point, $speed:Number, $isPetJump:Boolean = false, $callBack:MoveCallBack = null) : void
        {
            Teleport.lineTo(sc, $point, $speed, $isPetJump, $callBack);
            return;
        }

        public static function lineToPiexl($sc:SceneCharacter, param2:Point, param3:Number, $callBack:Function = null) : void
        {
            Teleport.lineToPiexl($sc, param2, param3, $callBack);
            return;
        }
		/**
		 * 移动到目标点 
		 * @param sc
		 * @param $targetTile
		 * @param $walkSpeed
		 * @param $standDis 攻击距离
		 * @param $moveCallBack
		 * 
		 */		
        public static function walk(sc:SceneCharacter, $targetTile:Point, $walkSpeed:Number = -1, $standDis:Number = 0, $moveCallBack:MoveCallBack = null) : void
        {
            var se:SceneEvent = null;
            var pathArr:Array = null;
            var pathItem:Array = null;
            var pixelPoint:Point = null;
            var dis:Number = NaN;
			if (sc.isJumping())
            {
                return;
            }
            var targetMapTile:MapTile = SceneCache.mapTiles[$targetTile.x + "_" + $targetTile.y];
            if (targetMapTile == null)
            {
                if (sc.isMainChar())
                {
                    sc.scene.hideMouseChar();
                    se = new SceneEvent(SceneEvent.WALK, SceneEventAction_walk.UNABLE, [sc, targetMapTile]);
                    EventDispatchCenter.getInstance().dispatchEvent(se);
                }
                if ($moveCallBack != null && $moveCallBack.onMoveUnable != null)
                {
                    $moveCallBack.onMoveUnable(sc, targetMapTile);
                }
                return;
            }
            sc.moveData.clear();
//			如果到达目标点
            if (sc.tile_x == $targetTile.x && sc.tile_y == $targetTile.y)
            {
                if (sc == sc.scene.mainChar)
                {
                    sc.scene.hideMouseChar();
                    se = new SceneEvent(SceneEvent.WALK, SceneEventAction_walk.ARRIVED, [sc, targetMapTile]);
                    EventDispatchCenter.getInstance().dispatchEvent(se);
                }
				if (targetMapTile.isTransport)
				{
					var sEvt:SceneEvent = null;
					sEvt = new SceneEvent(SceneEvent.WALK, SceneEventAction_walk.ON_TRANSPORT, [sc, targetMapTile]);
					EventDispatchCenter.getInstance().dispatchEvent(sEvt);
				}
                if ($moveCallBack != null && $moveCallBack.onMoveArrived != null)
                {
                    $moveCallBack.onMoveArrived(sc, targetMapTile);
                }
                return;
            }
            var targetP:Point = new Point(targetMapTile.pixel_x, targetMapTile.pixel_y);
//          攻击距离
			if ($standDis != 0)
            {
                dis = (sc.pixel_x - targetMapTile.pixel_x) * (sc.pixel_x - targetMapTile.pixel_x) + (sc.pixel_y - targetMapTile.pixel_y) * (sc.pixel_y - targetMapTile.pixel_y);
                if (dis <= $standDis * $standDis)
                {
                    sc.faceToTile($targetTile.x, $targetTile.y);
                    if (sc == sc.scene.mainChar)
                    {
                        sc.scene.hideMouseChar();
                        targetMapTile = SceneCache.mapTiles[sc.tile_x + "_" + sc.tile_y];
                        se = new SceneEvent(SceneEvent.WALK, SceneEventAction_walk.ARRIVED, [sc, targetMapTile]);
                        EventDispatchCenter.getInstance().dispatchEvent(se);
                    }
                    if ($moveCallBack != null && $moveCallBack.onMoveArrived != null)
                    {
                        $moveCallBack.onMoveArrived(sc, targetMapTile);
                    }
                    return;
                }
            }
            var _scTile:MapTile = SceneCache.mapTiles[sc.tile_x + "_" + sc.tile_y];
			targetMapTile = SceneUtil.getRoundMapTile(_scTile, targetMapTile);
			if (targetMapTile == null)
            {
                sc.faceToTile($targetTile.x, $targetTile.y);
				Logger.warn("目标点不可走！");
                if (sc == sc.scene.mainChar)
                {
                    sc.scene.hideMouseChar();
                    se = new SceneEvent(SceneEvent.WALK, SceneEventAction_walk.UNABLE, [sc, targetMapTile]);
                    EventDispatchCenter.getInstance().dispatchEvent(se);
                }
                if ($moveCallBack != null && $moveCallBack.onMoveUnable != null)
                {
                    $moveCallBack.onMoveUnable(sc, targetMapTile);
                }
                return;
            }
            var isIsland:Boolean = targetMapTile.isIsland;
            if (targetMapTile.isIsland)
            {
                pathArr = Astar.search(Astar.starGrid.grids, targetMapTile.tile_x, targetMapTile.tile_y, sc.tile_x, sc.tile_y,sc.scene.mapConfig);
            }
            else
            {
                pathArr = Astar.search(Astar.starGrid.grids, sc.tile_x, sc.tile_y, targetMapTile.tile_x, targetMapTile.tile_y,sc.scene.mapConfig);
            }
            if (pathArr == null || pathArr.length < 2)
            {
                sc.faceToTile($targetTile.x, $targetTile.y);
                if (sc == sc.scene.mainChar)
                {
					Logger.warn("目标点不可走！", pathArr==null?"null":pathArr.length);
                    sc.scene.hideMouseChar();
                    se = new SceneEvent(SceneEvent.WALK, SceneEventAction_walk.UNABLE, [sc, targetMapTile]);
                    EventDispatchCenter.getInstance().dispatchEvent(se);
                }
                if ($moveCallBack != null && $moveCallBack.onMoveUnable != null)
                {
                    $moveCallBack.onMoveUnable(sc, targetMapTile);
                }
                return;
            }
            if (!isIsland)
            {
                pathArr = pathArr.reverse();
            }
            var _itemArray:Array = pathArr[(pathArr.length - 1)];
            if ($standDis != 0)
            {
                for each (pathItem in pathArr)
                {
//                  获取进入了攻击范围内的最短路径
                    pixelPoint = Transformer.transTilePoint2PixelPoint(new Point(pathItem[0], pathItem[1]));
                    if ((pixelPoint.x - targetP.x) * (pixelPoint.x - targetP.x) + (pixelPoint.y - targetP.y) * (pixelPoint.y - targetP.y) <= $standDis * $standDis)
                    {
                        pathArr = pathArr.slice(0, (pathArr.indexOf(pathItem) + 1));
                        break;
                    }
                }
            }
            else
            {
                pathItem = _itemArray;
            }
			walk0(sc, pathArr, $targetTile, $walkSpeed, $standDis, $moveCallBack);
            return;
        }
		/**
		 * 根据路劲数组移动 
		 * @param sc
		 * @param $pathArr
		 * @param $targetP
		 * @param $walkSpeed
		 * @param $standDis
		 * @param $moveCallBack
		 * 覆盖旧移动数据
		 */
        public static function walk0(sc:SceneCharacter, $pathArr:Array, $targetP:Point = null, $walkSpeed:Number = -1, $standDis:Number = 0, $moveCallBack:MoveCallBack = null) : void
        {
            var targetP:Array = null;
            var se:SceneEvent = null;
            if ($pathArr.length < 2)
            {
                return;
            }
            var pathArr:Array = $pathArr;
            sc.moveData.clear();
            if (sc == sc.scene.mainChar)
            {
                if (sc.moveData.walk_pathCutter == null)
                {
                    sc.moveData.walk_pathCutter = new PathCutter(sc);
                }
                sc.moveData.walk_pathCutter.cutMovePath(pathArr);
                sc.moveData.walk_pathCutter.walkNext(-1, -1);
            }
            if ($walkSpeed >= 0)
            {
                sc.setSpeed($walkSpeed);
            }
            if ($targetP != null)
            {
                sc.moveData.walk_targetP = $targetP;
            }
            else
            {
                targetP = pathArr[(pathArr.length - 1)];
                sc.moveData.walk_targetP = new Point(targetP[0], targetP[1]);
            }
            sc.moveData.walk_standDis = $standDis;
            sc.moveData.walk_MoveCallBack = $moveCallBack;
            var currentP:Array = pathArr.shift();
            if (sc.tile_x != currentP[0])
            {
                sc.tile_x = currentP[0];
            }
            if (sc.tile_y != currentP[1])
            {
                sc.tile_y = currentP[1];
            }
            sc.moveData.walk_pathArr = pathArr;
            var targetArr:Array = pathArr[(pathArr.length - 1)];
            var mapTile:MapTile = SceneCache.mapTiles[targetArr[0] + "_" + targetArr[1]];
            if (sc.isMainChar())
            {
                if(!sc.moveData.walk_auto){
					sc.scene.showMouseChar(targetArr[0], targetArr[1]);
				}else{
					sc.scene.hideMouseChar() ;
				}
                se = new SceneEvent(SceneEvent.WALK, SceneEventAction_walk.READY, [sc, mapTile, pathArr]);
                EventDispatchCenter.getInstance().dispatchEvent(se);
            }
            if ($moveCallBack != null && $moveCallBack.onMoveReady != null)
            {
                $moveCallBack.onMoveReady(sc, mapTile, SceneCache.mapTiles[sc.moveData.walk_targetP.x + "_" + sc.moveData.walk_targetP.y]);
            }
			return;
        }
		/**
		 * 根据2进制数据移动 ，服务器返回数据移动角色 
		 * @param sc
		 * @param $pathByteArr
		 * @param param3
		 * @param param4
		 * @param param5
		 * @param param6
		 * 
		 */
        public static function walk1(sc:SceneCharacter, $pathByteArr:ByteArray, param3:Point = null, param4:Number = -1, param5:Number = 0, param6:MoveCallBack = null) : void
        {
            var pathArr:Array = PathConverter.convertToPoint($pathByteArr);
            walk0(sc, pathArr, param3, param4, param5, param6);
            return;
        }

    }
}
