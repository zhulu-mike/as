﻿package com.thinkido.framework.engine.config
{

    public class GlobalConfig extends Object
    {
        public static var map_config_tem:String = "";
        public static var map_small_tem:String = "";
        public static var map_zone_tem:String = "";
        public static var map_slipcover_tem:String = "";
        public static var FRAME_RATE:int = 24;
        public static var SETP_TIME:int = 1000 / FRAME_RATE;
        public static var decode:Function;
		/**解析自我加密或者压缩的文件,此方法必须要有返回*/
		public static var customDecode:Function;
		
		/**
		 * 是否使用SO
		 */		
		public static var useSo:Boolean = false;
		
		
		public static var shadowYScale:Number = 0.7;
		
		/**
		 * 影子的alpha0到1
		 */		
		public static var shadowAlpha:Number = 0.35;
		/**
		 * 12点为0方向，逆时针0到360，负数表示从正时针旋转。
		 */		
		public static var shadowAngle:int = 45;

		public static var version:Function;
		
        public function GlobalConfig()
        {
            return;
        }
		public static function setGlobalConfig(framerate:int, $decode:Function, $version:Function = null) : void
		{
			FRAME_RATE = framerate;
			SETP_TIME = 1000 / framerate;
			decode = $decode;
			version = $version;
			return;
		}
        public static function getMapConfigPath(repl:* = "", p:String = "$") : String
        {
            var temp:String = null;
            var re:RegExp = new RegExp("\\" + p, "g");
            temp = map_config_tem.replace(re, repl);
            return temp;
        }

        public static function getSmallMapPath(repl:* = "", p:String = "$") : String
        {
            var temp:String = null;
            var re:RegExp = new RegExp("\\" + p, "g");
            temp = map_small_tem.replace(re, repl);
            return temp;
        }

        public static function getZoneMapFolder(repl:* = "", p:String = "$") : String
        {
            var temp:String = null;
            var re:RegExp = new RegExp("\\" + p, "g");
            temp = map_zone_tem.replace(re, repl);
            return temp;
        }

        public static function getAvatarMapSlipcoverPath(repl:* = "", p:String = "$") : String
        {
            var temp:String = null;
            var re:RegExp = new RegExp("\\" + p, "g");
            temp = map_slipcover_tem.replace(re, repl);
            return temp;
        }

    }
}
