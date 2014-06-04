package com.thinkido.framework.engine.utils
{
    
    import com.thinkido.framework.common.utils.ZMath;
    import com.thinkido.framework.engine.Scene;
    import com.thinkido.framework.engine.SceneCamera;
    import com.thinkido.framework.engine.config.SceneConfig;
    import com.thinkido.framework.engine.tools.SceneCache;
    import com.thinkido.framework.engine.vo.BaseElement;
    import com.thinkido.framework.engine.vo.map.MapTile;
    
    import flash.geom.Point;
    
	/**
	 * 场景工具,判断可视区域，是否为阴影点,获取鼠标点击不可走点的最近点
	 * @author Administrator
	 * 
	 */
    public class SceneUtil extends Object
    {

        public function SceneUtil()
        {
            return;
        }
		
		/**
		 * 获取总共zone/2 横向、纵向 数。向上取整 
		 * @param $scene
		 * @return 
		 * 
		 */
        public static function getViewZoneRangeXY($scene:Scene) : Point
        {
            var temp:Point = new Point();
            temp.x = Math.ceil(($scene.sceneConfig.width / SceneConfig.ZONE_WIDTH - 1) / 2) + 1;
            temp.y = Math.ceil(($scene.sceneConfig.height / SceneConfig.ZONE_HEIGHT - 1) / 2) + 1;
            return temp;
        }
		/**
		 * 寻找可视区域数组 
		 * @param $tilePoint 格子坐标点
		 * @param $x 可视区宽
		 * @param $y 可视区高
		 * @return 
		 * 
		 */
        public static function findViewZonePoints($zonePoint:Point, $w:int, $h:int) : Array
        {
            var tempX:int = 0;
            var tempY:int = 0;
            var tempArr:Array = [];
            if ($w < 0 || $h < 0)
            {
                return [$zonePoint];
            }
            var minX:int = $zonePoint.x - $w;
            var maxX:int = $zonePoint.x + $w;
            var minY:int = $zonePoint.y - $h;
            var maxY:int = $zonePoint.y + $h;
            tempX = minX;
            while (tempX <= maxX)
            {
                tempY = minY;
                while (tempY <= maxY)
                {
                    tempArr.push(new Point(tempX, tempY));
                    tempY++;
                }
                tempX++;
            }
            return tempArr;
        }

        public static function getMapTile($x:int, $y:int) : MapTile
        {
            return SceneCache.mapTiles[$x + "_" + $y] as MapTile;
        }

        public static function isSolid($x:int, $y:int) : Boolean
        {
            var mapTile:MapTile = getMapTile($x, $y);
            if (mapTile != null || mapTile.isSolid)
            {
                return true;
            }
            return false;
        }

        public static function isIsland($x:int, $y:int) : Boolean
        {
            var mapTile:MapTile = getMapTile($x, $y);
            if (mapTile != null && mapTile.isIsland)
            {
                return true;
            }
            return false;
        }

        public static function isMask($x:int, $y:int) : Boolean
        {
            var mapTile:MapTile = getMapTile($x, $y);
            if (mapTile != null && mapTile.isMask)
            {
                return true;
            }
            return false;
        }

        public static function hasSolidBetween2MapTile(mapTile1:MapTile, mapTile2:MapTile) : Boolean
        {
            var mapTile:MapTile = null;
            var p1:Point = new Point(mapTile1.pixel_x, mapTile1.pixel_y);
            var p2:Point = new Point(mapTile2.pixel_x, mapTile2.pixel_y);
            var angle:Number = ZMath.getTowPointsAngle(p1, p2);
            var radian:Number = angle * Math.PI / 180;
            var cos:Number = Math.cos(radian);
            var sin:Number = Math.sin(radian);
            var dis:Number = Point.distance(p1, p2);
            var point:Point = new Point();
			point.x = p2.x;
            point.y = p2.y;
            var be:BaseElement = new BaseElement();
			be.pixel_x = point.x;
            be.pixel_y = point.y;
            while (true)
            {
                
                if (Math.abs(mapTile1.tile_x - be.tile_x) <= 1 && Math.abs(mapTile1.tile_y - be.tile_y) <= 1)
                {
                    return false;
                }
                mapTile = SceneCache.mapTiles[be.tile_x + "_" + be.tile_y];
                if (mapTile.isSolid)
                {
                    return true;
                }
                be.pixel_x = be.pixel_x - SceneConfig.TILE_WIDTH * cos;
                be.pixel_y = be.pixel_y - SceneConfig.TILE_HEIGHT * sin;
            }
            return false;
        }

        public static function getLineMapTile(param1:MapTile, param2:MapTile, param3:Number = 0) : MapTile
        {
            var _loc_13:MapTile = null;
            var _loc_4:* = new Point(param1.pixel_x, param1.pixel_y);
            var _loc_5:* = new Point(param2.pixel_x, param2.pixel_y);
            var _loc_6:* = ZMath.getTowPointsAngle(_loc_4, _loc_5);
            var _loc_7:* = ZMath.getTowPointsAngle(_loc_4, _loc_5) * Math.PI / 180;
            var _loc_8:* = Math.cos(_loc_7);
            var _loc_9:* = Math.sin(_loc_7);
            var _loc_10:* = Point.distance(_loc_4, _loc_5);
            var _loc_11:* = new Point();
            if (param3 > 0 && param3 < _loc_10)
            {
                _loc_11.x = param1.pixel_x + param3 * _loc_8;
                _loc_11.y = param1.pixel_y + param3 * _loc_9;
            }
            else
            {
                _loc_11.x = _loc_5.x;
                _loc_11.y = _loc_5.y;
            }
            var _loc_12:* = new BaseElement();
			_loc_12.pixel_x = _loc_11.x;
            _loc_12.pixel_y = _loc_11.y;
            while (true)
            {
                
                if ((param1.tile_x - _loc_12.tile_x) * (param1.tile_x - _loc_12.tile_x) + (param1.tile_y - _loc_12.tile_y) * (param1.tile_y - _loc_12.tile_y) < 2)
                {
                    return param1;
                }
                _loc_13 = SceneCache.mapTiles[_loc_12.tile_x + "_" + _loc_12.tile_y];
                if (!_loc_13.isSolid)
                {
                    return _loc_13;
                }
                _loc_12.pixel_x = _loc_12.pixel_x - SceneConfig.TILE_WIDTH * _loc_8;
                _loc_12.pixel_y = _loc_12.pixel_y - SceneConfig.TILE_HEIGHT * _loc_9;
            }
            return param1;
        }
		/**
		 * 点击不可走的区域时，获取附近可走区域
		 * @param scTile
		 * @param targetTile
		 * @return 
		 * 
		 */
        public static function getRoundMapTile(scTile:MapTile, targetTile:MapTile) : MapTile
        {
            var _loc_7:Point = null;
            var _loc_8:Point = null;
            var _loc_9:MapTile = null;
            var index:int = 0;
            var _loc_11:Array = null;
            var len:int = 0;
            if (!targetTile.isSolid)
            {
                return targetTile;
            }
            var tPixelP:Point = new Point(targetTile.pixel_x, targetTile.pixel_y);
            var tTileP:Point = new Point(targetTile.tile_x, targetTile.tile_y);
            var _loc_5:Point = new Point(tTileP.x, tTileP.x);
            var _loc_6:Point = new Point(tTileP.y, tTileP.y);
            while (true)
            {
                
                _loc_5.x -= 1;
                _loc_5.y += 1;
                _loc_6.x -= 1;
                _loc_6.y += 1;
                _loc_11 = [];
                index = _loc_5.x;
                while (index <= _loc_5.y)
                {
                    _loc_11.push(new Point(index, _loc_6.x), new Point(index, _loc_6.y));
                    index++;
                }
                index = _loc_6.x + 1;
                while (index < (_loc_6.y - 1))
                {
                    
                    _loc_11.push(new Point(_loc_5.x, index), new Point(_loc_5.y, index));
                    index++;
                }
                len = _loc_11.length;
                index = 0;
                while (index < len)
                {
                    
                    _loc_7 = _loc_11[index];
                    _loc_8 = Transformer.transTilePoint2PixelPoint(_loc_7);
                    if (scTile == null || scTile.tile_x == _loc_7.x && scTile.tile_y == _loc_7.y)
                    {
                        return scTile;
                    }
                    _loc_9 = SceneCache.mapTiles[_loc_7.x + "_" + _loc_7.y];
                    if (_loc_9 == null)
                    {
                    }
                    else if (!_loc_9.isSolid)
                    {
                        return _loc_9;
                    }
                    index++;
                }
            }
            return null;
        }

        public static function getRoundMapTile2(targetTile:MapTile, $dis:Number = 0) : MapTile
        {
            var _loc_7:Point = null;
            var _loc_8:Point = null;
            var _loc_9:MapTile = null;
            var _loc_10:int = 0;
            var _loc_11:Array = null;
            var _loc_12:int = 0;
            if (!targetTile.isSolid)
            {
                return targetTile;
            }
            var _loc_3:* = new Point(targetTile.pixel_x, targetTile.pixel_y);
            var _loc_4:* = new Point(targetTile.tile_x, targetTile.tile_y);
            var _loc_5:* = new Point(_loc_4.x, _loc_4.x);
            var _loc_6:* = new Point(_loc_4.y, _loc_4.y);
            while (true)
            {
                
                (_loc_5.x - 1);
                (_loc_5.y + 1);
                (_loc_6.x - 1);
                (_loc_6.y + 1);
                _loc_11 = [];
                _loc_10 = _loc_5.x;
                while (_loc_10 <= _loc_5.y)
                {
                    
                    _loc_11.push(new Point(_loc_10, _loc_6.x), new Point(_loc_10, _loc_6.y));
                    _loc_10++;
                }
                _loc_10 = _loc_6.x + 1;
                while (_loc_10 < (_loc_6.y - 1))
                {
                    
                    _loc_11.push(new Point(_loc_5.x, _loc_10), new Point(_loc_5.y, _loc_10));
                    _loc_10++;
                }
                _loc_12 = _loc_11.length;
                _loc_10 = 0;
                while (_loc_10 < _loc_12)
                {
                    
                    _loc_7 = _loc_11[_loc_10];
                    _loc_8 = Transformer.transTilePoint2PixelPoint(_loc_7);
                    if (Point.distance(_loc_3, _loc_8) >= $dis)
                    {
                        return null;
                    }
                    _loc_9 = SceneCache.mapTiles[_loc_7.x + "_" + _loc_7.y];
                    if (_loc_9 == null)
                    {
                    }
                    else if (!_loc_9.isSolid)
                    {
                        return _loc_9;
                    }
                    _loc_10++;
                }
            }
            return null;
        }

    }
}
