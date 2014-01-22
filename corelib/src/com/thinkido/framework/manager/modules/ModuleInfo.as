package com.thinkido.framework.manager.modules
{
	import flash.events.EventDispatcher;
	/**
	 * 模块化开发使用的模块化信息 
	 * @author Administrator
	 * 
	 */
    public class ModuleInfo extends EventDispatcher
    {
        public var url:String;
        public var name:String;
        public var isLoaded:Boolean;
        public var isLoading:Boolean;
        public var error:Boolean;
        public var module:IModule;

        public function ModuleInfo($name:String = null, $url:String = null)
        {
            this.name = $name;
            this.url = $url;
            return;
        }

    }
}
