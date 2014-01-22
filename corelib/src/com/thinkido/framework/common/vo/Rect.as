package com.thinkido.framework.common.vo
{
    import flash.geom.*;

    public class Rect extends Rectangle
    {

        public function Rect(value1:int = 0, value2:int = 0, value3:int = 0, value4:int = 0)
        {
            super(value1, value2, value3, value4);
            return;
        }

        public function get area() : int
        {
            return width * height;
        }

        override public function clone() : Rectangle
        {
            return new Rect(x, y, width, height);
        }

    }
}
