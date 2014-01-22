package com.thinkido.framework.engine.config
{
	/**
	 * 场景配置 
	 * @author Administrator
	 * 
	 */
    public class SceneConfig extends Object
    {
		/**
		 *  场景宽 
		 */		
        public var width:Number = 1000; 
		/**
		 * 场景高 
		 */		
        public var height:Number = 580;
		/**
		 * 网格宽 
		 */		
        public static const TILE_WIDTH:Number = 25;
		/**
		 * 网格高 
		 */		
        public static const TILE_HEIGHT:Number = 25;
		/**
		 * 地图图片宽 
		 */		
        public static const ZONE_WIDTH:Number = 200;
		/**
		 * 地图图片高 
		 */		
        public static const ZONE_HEIGHT:Number = 200;
		/**
		 * 网格与地图图片  缩放比例
		 */		
        public static const ZONE_SCALE:Number = ZONE_WIDTH /TILE_WIDTH ;    //8

        public function SceneConfig(w:Number, h:Number)
        {
            this.width = w;
            this.height = h;
            return;
        }

    }
}
