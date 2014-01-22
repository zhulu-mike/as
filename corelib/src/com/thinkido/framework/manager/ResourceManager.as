package com.thinkido.framework.manager
{
	import flash.display.DisplayObject;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	import org.osflash.thunderbolt.Logger;
	/**
	 * 资源管理器，存储游戏使用过的资源 
	 * @author thinkido
	 * 
	 */	
	public class ResourceManager
	{
		private var _resLibDic:Dictionary ;
		private var _appDomainDic:Dictionary ;
		
		
		private static var instance : ResourceManager;
		/**
		 * 主要使用rslloadermanager 
		 * 
		 */		
		public function ResourceManager() 
		{   
			if ( instance != null )
			{
				throw new Error("ResourceManager is singleton" );
			}
			
			instance = this;
			
			_resLibDic = new Dictionary(true);
			_appDomainDic = new Dictionary(true);
			
		}
		
		public static function getInstance() : ResourceManager 
		{
			if ( instance == null )
				instance = new ResourceManager();
			
			return instance;
		}
		/**
		 * 
		 * @param resName 资源名
		 * @param resValue 资源
		 * @return
		 * 
		 */		
		public function addResource(resName:String ,resValue:Object):void{
			if( !_resLibDic[resName] ){
				_resLibDic[resName] = resValue ;
				if( resValue is DisplayObject){
					addAppDomain(resName,DisplayObject(resValue).loaderInfo.applicationDomain);
				}
			}else{
				Logger.error("resouceManager_addResource resouce:",resName,"重复添加！");
			}
		}
		/**
		 * 根据资源名返回资源
		 * @param resName  资源名
		 * @return 资源 （通常是一个swf）
		 * 
		 */		
		public function getResource(resName:String ):Object{
			var result:Object = _resLibDic[resName] ;
			return result ;
		}
		
		public function delResource(resName:String):Boolean{
			var result:Boolean = false ;
			if( _resLibDic[resName] ){
				if( _resLibDic[resName] is DisplayObject){
					delAppDomain(resName);
				}
				_resLibDic[resName] = null ;
				result = true ;
			}else{
				trace("resouceManager_delResource resouce:",resName,"没有找到！");
			}
			return result ;
		}
		/**
		 * 添加应用程序域，作为资源库
		 * @param name 
		 * @param appDomain
		 * 
		 */		
		private function addAppDomain(name:String,appDomain:ApplicationDomain):void{
			if( !_appDomainDic[name] ){
				_appDomainDic[name] = appDomain ;
			}
		}
		
		private function delAppDomain(name:String):Boolean{
			var result:Boolean = false ;
			if( _appDomainDic[name] ){
				_appDomainDic[name] = null ;
				result = true ;
			}else{
				
			}
			return result ;
		}
		
		public function getClass(name:String,libArr:Array = null):Class{
			var tempClass:Class = null ;
			if( libArr && libArr.length > 0 ){
				for (var i:int = 0; i < libArr.length; i++) 
				{
					if(libArr[i].hasDefinition(name)){
						tempClass = libArr[i].getDefinition(name) as Class ;
						break;
					}
				}
			}
			for each(var item:ApplicationDomain in _appDomainDic){
				if(item.hasDefinition(name)){
					tempClass = item.getDefinition(name) as Class ;
					break;
				}				
			}		
			if( !tempClass ){
//				tempClass = stage.loaderInfo.ApplicationDomain.getDefinition(name) as Class ;
			}
			return tempClass ;
		}
	}
}