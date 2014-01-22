package com.thinkido.framework.utils
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import com.thinkido.framework.events.MouseRightEvent;
	import com.thinkido.framework.events.MouseRightEvent;
	
	/**
	 * flash 右键 
	 * @author thinkido
	 * 
	 */	
	public class RightClick
	{
	
		private static var mouseTarget:DisplayObject;	
		/**
		 * 屏蔽邮件的js 
		 */		
		private static const rightClickJS:XML =
			<script><![CDATA[
				function (){
				if(typeof RightClick == "undefined" || !RightClick)	RightClick = {};
				
				RightClick.findSwf=function() 
				{
					var objects = document.getElementsByTagName("object");
					for(var i = 0; i < objects.length; i++)
					{
						if(typeof objects[i] != "undefined")
						{			
							return objects[i];
						}
					}
				
					var embeds = document.getElementsByTagName("embed");
					
					for(var j = 0; j < embeds.length; j++)
					{
						if(typeof embeds[j] != "undefined")
						{
							return embeds[j];
						}
					}
				
					return null;
				};
				RightClick.init=function () {
					this.swf = RightClick.findSwf();
					//this.Cache = RightClick.swf.id;		
					if(window.addEventListener){
						window.addEventListener("mousedown", this.onGeckoMouse(), true);
					} else {
						RightClick.swf.onmouseup = function() { window.releaseCapture(); }
						document.oncontextmenu = function(){ if(window.event.srcElement.id == RightClick.swf.id) { return false; } else {  }}
						RightClick.swf.onmousedown = RightClick.onIEMouse;
					}
				};
				RightClick.UnInit=function () { 
					if(window.RemoveEventListener){
						//alert('Un init is called for GECKO' );			
						window.addEventListener("mousedown", null, true);
						window.RemoveEventListener("mousedown",this.onGeckoMouse(),true);
						//w//indow.releaseEvents("mousedown");
					} else {
						RightClick.swf.onmouseup = "" ;
						document.oncontextmenu = "";
						RightClick.swf.onmousedown = "";
					}
				};
				RightClick.killEvents=function(eventObject) {
					if(eventObject) {
						if (eventObject.stopPropagation) eventObject.stopPropagation();
						if (eventObject.preventDefault) eventObject.preventDefault();
						if (eventObject.preventCapture) eventObject.preventCapture();
						if (eventObject.preventBubble) eventObject.preventBubble();
					}
				};
				RightClick.onGeckoMouse=function(ev) {
					return function(ev) {
						if (ev.button != 0) {
							RightClick.killEvents(ev);
							if(ev.target.id == RightClick.swf.id ) {
								RightClick.call();
							}
				
						}
					}
				};
				RightClick.onIEMouse=function() {
					if (event.button > 1) {
						//alert(window.event.srcElement.id );	
						if(window.event.srcElement.id == RightClick.swf.id ) {
							
							window.event.cancelBubble = true;
							window.event.returnValue = false; 
							RightClick.call(); 
							window.setCapture();
						}
						if(window.event.srcElement.id)
						RightClick.Cache = window.event.srcElement.id;
					}
				};
				RightClick.call=function() {
					RightClick.swf.rightClickCIJ();
				}
			}
			]]></script>;
		
		public function RightClick() 
		{ 
			
		}
		/**
		 * 屏蔽右键 
		 * @param stage
		 * 
		 */		
		public static function init(stage:Stage):void{
			//ExternalInterface.call('eval',rightClick);
			if( ExternalInterface.available){
				ExternalInterface.call(rightClickJS);
				ExternalInterface.addCallback("rightClickCIJ", rightClickCIA);
				ExternalInterface.call("RightClick.init()");
				stage.addEventListener(MouseEvent.MOUSE_OVER,doMouseOver);
				trace("init success");
			}else{
				trace("init fault");
			}			
		}
		/**
		 * 取消屏蔽 
		 * @param stage
		 * 
		 */		
		public static function unInit(stage:Stage):void{
			if( ExternalInterface.available && stage.hasEventListener(MouseEvent.MOUSE_OVER)){
				stage.removeEventListener(MouseEvent.MOUSE_OVER,doMouseOver);
			}			
		}
		private static function doMouseOver(evt:MouseEvent):void{
			mouseTarget = DisplayObject(evt.target) ;			
		}
		/*private function checkSwfCIA():String{
			return swfId;
		} */
		private static function rightClickCIA():void {
			if(mouseTarget&& mouseTarget.willTrigger(MouseRightEvent.MOUSE_CLICK )){
				mouseTarget.dispatchEvent(new MouseRightEvent(MouseRightEvent.MOUSE_CLICK));
			}			
		}
		
	}
	
}