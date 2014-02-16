package com.thinkido.framework.engine
{
    import com.thinkido.framework.engine.config.*;
    import com.thinkido.framework.engine.tools.*;
	/**
	 * 引擎 
	 * @author thinkido
	 */
    public class Engine extends Object
    {
        public static var engineReady:Boolean = false;
        public static var enable2Jump:Boolean = true;
        public static var enableJumpStop:Boolean = false;
        public static var font_HeadFace:String = "宋体";
        public static var font_AttackFace:String = "楷体";

        public function Engine()
        {
            return;
        }
		/**
		 * 
		 * @param $map_config_tem
		 * @param $map_small_tem
		 * @param $map_zone_tem
		 * @param $map_slipcover_tem
		 * @param $frameRate
		 * @param $decode 解码方法
		 * @param useSo 是否使用so管理文件
		 */		
        public static function initEngine($map_config_tem:String = "", $map_small_tem:String = "", $map_zone_tem:String = "", $map_slipcover_tem:String = "", $frameRate:int = 24, $decode:Function = null, useSo:Boolean=false) : void
        {
            GlobalConfig.map_config_tem = $map_config_tem;
            GlobalConfig.map_small_tem = $map_small_tem;
            GlobalConfig.map_zone_tem = $map_zone_tem;
            GlobalConfig.map_slipcover_tem = $map_slipcover_tem;
            GlobalConfig.FRAME_RATE = $frameRate;
            GlobalConfig.SETP_TIME = 1000 / $frameRate;
            GlobalConfig.decode = $decode;
			GlobalConfig.useSo = useSo;
            engineReady = true;
            return;
        }
		/**
		 * 设置传送点
		 * @param $transportArr 传送点坐标数组
		 * key  为 id_x_y 组成 
		 */
        public static function initTransport($transportArr:Array) : void
        {
            var item:Array = null;
            if ($transportArr == null)
            {
                return;
            }
            var transports:Object = {};
            for each (item in $transportArr)
            {
                
                transports[item[0] + "_" + item[1] + "_" + item[2]] = 1;
            }
            SceneCache.transports = transports;
            return;
        }

    }
}
