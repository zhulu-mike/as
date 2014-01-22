package com.thinkido.framework.engine.vo.map
{
	import com.thinkido.framework.common.pool.IPoolClass;
	import com.thinkido.framework.engine.vo.BaseElement;

	/**
	 * 地图网格， 
	 * @author thinkido
	 * 
	 */	
    public class MapTile extends BaseElement implements IPoolClass
    {
		/**
		 * 障碍点
		 * true: 不可走 1
		 * false: 可走
		 */		
        public var isSolid:Boolean;
		/**
		 *暂时没有出现  2
		 */		
        public var isIsland:Boolean;
		/**
		 * 遮挡  1
		 */		
        public var isMask:Boolean;
		/**
		 * 传送点 
		 */		
        public var isTransport:Boolean;

        public function MapTile($tile_x:int, $tile_y:int, $isSolid:Boolean = false, $isIsland:Boolean = false, $isMask:Boolean = false, $isTransport:Boolean = false)
        {
//            tile_x = $tile_x;
//            tile_y = $tile_y;
//            this.isSolid = $isSolid;
//            this.isIsland = $isIsland;
//            this.isMask = $isMask;
//            this.isTransport = $isTransport;
			reSet([$tile_x,$tile_y,$isSolid,$isIsland,$isMask,$isTransport]);
            return;
        }


		public function dispose():void
		{
			
		}

		public function reSet($inits:Array):void
		{
			tile_x = $inits[0];
			tile_y = $inits[1];
			this.isSolid = $inits[2];
			this.isIsland = $inits[3];
			this.isMask = $inits[4];
			this.isTransport = $inits[5];
		}


    }
}
