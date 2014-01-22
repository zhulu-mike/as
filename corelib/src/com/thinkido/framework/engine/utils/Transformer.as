package com.thinkido.framework.engine.utils
{
    import com.thinkido.framework.common.utils.*;
    import com.thinkido.framework.engine.config.*;
    import com.thinkido.framework.engine.staticdata.*;
    
    import flash.geom.Point;

    public class Transformer extends Object
    {

        public function Transformer()
        {
            return;
        }

        public static function transTilePoint2ZonePoint(tilePoint:Point) : Point
        {
            return new Point(int(tilePoint.x / SceneConfig.ZONE_SCALE), int(tilePoint.y / SceneConfig.ZONE_SCALE));
        }

        public static function transTilePoint2PixelPoint(tilePoint:Point) : Point
        {
            return new Point(tilePoint.x * SceneConfig.TILE_WIDTH, tilePoint.y * SceneConfig.TILE_HEIGHT);
        }

        public static function transPixelPoint2TilePoint(pixelPoint:Point) : Point
        {
            return new Point(int(pixelPoint.x / SceneConfig.TILE_WIDTH), int(pixelPoint.y / SceneConfig.TILE_HEIGHT));
        }

        public static function transZoneTilePoint2ZonePixelPoint(tilePoint:Point) : Point
        {
            return new Point(tilePoint.x * SceneConfig.ZONE_WIDTH, tilePoint.y * SceneConfig.ZONE_HEIGHT);
        }

        public static function transAngle2LogicAngle(param1:Number, param2:int = 8) : int
        {
            var temp:int = ZMath.getNearAngel(param1 - 90, param2);
            return CharAngleType["ANGEL_" + temp] == undefined ? 0 : CharAngleType["ANGEL_" + temp] ;
        }

        public static function transLogicAngle2Angle(param1:int, param2:int = 8) : int
        {
            var temp:int = 360 / param2;
            return param1 * temp % 360;
        }

    }
}
