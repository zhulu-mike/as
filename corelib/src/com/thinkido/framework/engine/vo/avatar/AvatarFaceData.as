package com.thinkido.framework.engine.vo.avatar
{
	import com.thinkido.framework.engine.graphics.avatar.AvatarPart;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

    public class AvatarFaceData extends Object
    {
        public var id:String;
        public var type:String;
        public var cutRect:Rectangle;
        public var sourcePoint:Point;
        public var sourceBitmapData:BitmapData;
		public var ap:AvatarPart;

        public function AvatarFaceData($cutRect:Rectangle = null, $sourcePoint:Point = null, $sourceBitmapData:BitmapData = null, $ap:AvatarPart=null)
        {
            this.cutRect = $cutRect;
            this.sourcePoint = $sourcePoint;
            this.sourceBitmapData = $sourceBitmapData;
			this.ap = $ap;
            return;
        }
		/**
		 * 数据是否可用 
		 * @return 
		 * 
		 */
        public function isGood() : Boolean
        {
            return this.cutRect != null && this.sourcePoint != null && this.sourceBitmapData != null;
        }

    }
}
