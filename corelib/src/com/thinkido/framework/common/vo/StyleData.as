package com.thinkido.framework.common.vo
{

    public class StyleData extends Object
    {
        public var lineThickness:Number;
        public var lineColor:uint;
        public var lineAlpha:Number;
        public var fillColor:uint;
        public var fillAlpha:Number;
        public static const DEFAULT:StyleData = new StyleData(0, 0, 1, 0, 1);

        public function StyleData($thickness:Number = 0, $color:uint = 0, $alpha:Number = 1, $fillColor:uint = 0, $fillAlpha:Number = 1)
        {
            this.lineThickness = $thickness;
            this.lineColor = $color;
            this.lineAlpha = $alpha;
            this.fillColor = $fillColor;
            this.fillAlpha = $fillAlpha;
            return;
        }

    }
}
