package com.thinkido.framework.engine.move
{
    import com.thinkido.framework.common.events.EventDispatchCenter;
    import com.thinkido.framework.common.utils.ZMath;
    import com.thinkido.framework.engine.SceneCharacter;
    import com.thinkido.framework.engine.SceneRender;
    import com.thinkido.framework.engine.config.GlobalConfig;
    import com.thinkido.framework.engine.config.SceneConfig;
    import com.thinkido.framework.engine.events.SceneEvent;
    import com.thinkido.framework.engine.events.SceneEventAction_walk;
    import com.thinkido.framework.engine.staticdata.CharAngleType;
    import com.thinkido.framework.engine.staticdata.SceneCharacterType;
    import com.thinkido.framework.engine.utils.SceneUtil;
    import com.thinkido.framework.engine.vo.map.MapTile;
    import com.thinkido.framework.engine.vo.move.MoveData;
    
    import flash.geom.Point;
    
    import org.osflash.thunderbolt.Logger;

    public class WalkStep extends Object
    {
        private static const floor:Function = Math.floor;
        private static const sin:Function = Math.sin;
        private static const cos:Function = Math.cos;
        private static const sqrt:Function = Math.sqrt;
        private static const abs:Function = Math.abs;
        private static const WALK:String = "walk";
        private static const STAND:String = "stand";
        private static const DEATH:String = "death";
        private static const TILE_WIDTH:Number = SceneConfig.TILE_WIDTH ;
        private static const TILE_HEIGHT:Number = SceneConfig.TILE_HEIGHT ;
        private static const MAX_DIS:Number = sqrt(TILE_WIDTH * TILE_WIDTH + TILE_HEIGHT + TILE_HEIGHT);
        private static const TO_RAD:Number = 0.0174533;

        public function WalkStep()
        {
            return;
        }

        public static function step(sc:SceneCharacter) : void
        {
            var sEvt:SceneEvent = null;
            var item:Array = null;
            var lastTime:int = 0;
            var stepNum:Number = NaN;
            var mapTile:MapTile = null;
            if (sc.getStatus() == DEATH)
            {
                if (sc == sc.scene.mainChar)
                {
                    sc.scene.hideMouseChar();
                }
                sc.moveData.clear();
                return;
            }
            var moveData:MoveData = sc.moveData ;
            if (moveData.walk_pathArr == null || moveData.walk_pathArr.length == 0)
            {
                if (sc.getStatus() == WALK && sc.type != SceneCharacterType.MOUNT && sc.type != SceneCharacterType.NPC_FRIEND)
                {
                    sc.playTo(STAND);
                }
                return;
            }
            var stepSpeed:Number = moveData.walk_speed / GlobalConfig.FRAME_RATE;
            var nowTime:int = SceneRender.nowTime;
            if (moveData.walk_lastTime != nowTime)
            {
                lastTime = moveData.walk_lastTime;
                moveData.walk_lastTime = nowTime;
                if (lastTime != 0)
                {
                    stepNum = (nowTime - lastTime) / GlobalConfig.SETP_TIME;
                    stepSpeed = stepSpeed * stepNum;
                }
            }
            var temp:Object = stepDistance(sc, stepSpeed);
            var tempPoint:Point = temp.standPiexl;
			tempPoint.x = Math.round(tempPoint.x);
			tempPoint.y = Math.round(tempPoint.y);			
            var items:Array = temp.throughTileArr;
            var pointAngle:Number = ZMath.getTowPointsAngle(new Point(sc.pixel_x, sc.pixel_y), tempPoint);
            var angle:int = ZMath.getNearAngel(pointAngle - 90);
			if( sc.pixel_x == tempPoint.x && sc.pixel_y == tempPoint.y  ){
				sc.playTo(WALK);
			}else{
				if( sc.isOnMount ){
					sc.playTo(STAND, CharAngleType["ANGEL_" + angle]);
				}else{
					sc.playTo(WALK, CharAngleType["ANGEL_" + angle]);
				}
			}
//			if(items.length == 0){
				sc.setXY(tempPoint.x, tempPoint.y);
//			}else{
//				var len:int = items.length;
//				sc.setTileXY(items[len - 1][0],items[len - 1][1]);
//			}
			
//			Logger.warn(sc.pixel_x + " "+ sc.pixel_y + " " + sc.tile_x + " " + sc.tile_y);
			for each (item in items)
            {
                if (sc == sc.scene.mainChar)
                {	
					moveData.walk_pathCutter.walkNext(item[0], item[1]);
                    sEvt = new SceneEvent(SceneEvent.WALK, SceneEventAction_walk.THROUGH, [sc, SceneUtil.getMapTile(item[0], item[1])]);
                 	EventDispatchCenter.getInstance().dispatchEvent(sEvt);
                }
                if (moveData.walk_MoveCallBack != null && moveData.walk_MoveCallBack.onMoveThrough != null)
                {
                    moveData.walk_MoveCallBack.onMoveThrough(sc, SceneUtil.getMapTile(item[0], item[1]));
                }
            }
			
            if (moveData.walk_pathArr == null)
            {
                return;
            }
            if (moveData.walk_pathArr.length == 0)
            {
                sc.playTo(STAND);
                sc.faceToTile(moveData.walk_targetP.x, moveData.walk_targetP.y);
                if (sc == sc.scene.mainChar)
                {
                    mapTile = SceneUtil.getMapTile(sc.tile_x, sc.tile_y);
                    sc.scene.hideMouseChar();
                    sEvt = new SceneEvent(SceneEvent.WALK, SceneEventAction_walk.ARRIVED, [sc, mapTile]);
                    EventDispatchCenter.getInstance().dispatchEvent(sEvt);
                    if (mapTile.isTransport)
                    {
                        sEvt = new SceneEvent(SceneEvent.WALK, SceneEventAction_walk.ON_TRANSPORT, [sc, mapTile]);
                        EventDispatchCenter.getInstance().dispatchEvent(sEvt);
                    }
                }
                if (moveData.walk_MoveCallBack != null && moveData.walk_MoveCallBack.onMoveArrived != null)
                {
                    moveData.walk_MoveCallBack.onMoveArrived(sc, SceneUtil.getMapTile(sc.tile_x, sc.tile_y));
                }
                moveData.clear();
            }
            return;
        }
		/**
		 * 
		 * @param sc
		 * @param $stepDis
		 * @return 
		 * 每步移动距离，
		 * temp = stepDis;
           stepDis = stepDis - temp;  需确认是否多余
		 * cos(angle) 是否可以、有必要优化
		 */
        private static function stepDistance(sc:SceneCharacter, $stepDis:Number) : Object
        {
            var temp:Number = NaN;
			/**走路中的下一个坐标点 */
            var pathItem:Array = null;
//			屏幕坐标系
            var point:Point = null;
            var distance:Number = NaN;
            var angle:Number = NaN;
            var item:Array = null;
            var pathObject:Object = {standPiexl:new Point(sc.pixel_x, sc.pixel_y), throughTileArr:[]};
            var moveData:MoveData = sc.moveData;
            var standPoint:Point = pathObject.standPiexl;
            var stepDis:Number = $stepDis;
            var throughArr:Array = pathObject.throughTileArr;
			var degree:int = 0;
			var sinx:Number = 0;
			var cosx:Number = 0;
			var abs:Number = 0;
            while (true)
            {
                pathItem = moveData.walk_pathArr[0];
                point = new Point(pathItem[0] * TILE_WIDTH , pathItem[1] * TILE_HEIGHT);
                distance = Point.distance(standPoint, point);
                if (distance > stepDis)
                {
//					Logger.warn("移动前:"+sc.tile_x+"y"+sc.tile_y+"坐标："+sc.pixel_x + "y" + sc.pixel_y);
                    temp = stepDis;
                    stepDis = stepDis - temp;
					degree = ZMath.getTowPointsAngle(standPoint, point);
					degree = degree >= 360 ? degree - 360 : degree;
					if (degree % 180 == 0)
					{
						sinx = 0;
						cosx = degree < 180 ? 1 : -1;
					}else if (degree % 90 == 0)
					{
						sinx = degree < 270 ? 1 : -1;
						cosx = 0;
					}else if (degree % 45 == 0){
						abs = Math.abs(sin(degree*Math.PI/180));
						if (degree == 45)
						{
							sinx = abs;
							cosx = abs;
						}else if (degree == 225)
						{
							sinx = -abs;
							cosx = -abs;
						}else if (degree == 135){
							sinx = abs;
							cosx = -abs;
						}else{
							sinx = -abs;
							cosx = abs;
						}
					}else{
						sinx = sin(degree*Math.PI/180);
						cosx = cos(degree*Math.PI/180);
					}
                    standPoint.x = standPoint.x + temp * cosx;
                    standPoint.y = standPoint.y + temp * sinx;
//					Logger.warn("同时移动距离："+cosx+"y"+sinx+"angle"+angle+"移动后距离"+standPoint.x+"y"+standPoint.y+"格子坐标"+(standPoint.x/SceneConfig.TILE_WIDTH)+(standPoint.y/SceneConfig.TILE_HEIGHT));
                    return pathObject;
                }
				else if (distance == stepDis)
                {
                    temp = stepDis;
                    item = moveData.walk_pathArr.shift();
                    throughArr.push(item);
                    stepDis = stepDis - temp;
                    standPoint.x = item[0] * TILE_WIDTH;
                    standPoint.y = item[1] * TILE_HEIGHT;
                    return pathObject;
                }
                temp = distance;
                item = moveData.walk_pathArr.shift();
                throughArr.push(item);
                stepDis = stepDis - temp;
                standPoint.x = item[0] * TILE_WIDTH ;
                standPoint.y = item[1] * TILE_HEIGHT ;
                if (moveData.walk_pathArr.length == 0)
                {
                    return pathObject;
                }
            }
            return pathObject;
        }

    }
}
