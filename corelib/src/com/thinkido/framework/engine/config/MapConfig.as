﻿package com.thinkido.framework.engine.config
{

    public class MapConfig extends Object
    {
		/**
		 * 地图id 
		 */		
        public var mapID:int;
		/**
		 * x 格数 
		 */		
        public var mapGridX:int;
		/**
		 * y 格数
		 */        
		public var mapGridY:int; 
		/**
		 * 地图总宽 
		 */		
        public var width:int;
		/**
		 * 地图总高 
		 */		
        public var height:int;
        public var zoneMapDir:String;
		/**
		 *小地图url 
		 */		
        public var smallMapUrl:String;
        public var slipcovers:Array;

        public function MapConfig()
        {
            return;
        }

    }
}
