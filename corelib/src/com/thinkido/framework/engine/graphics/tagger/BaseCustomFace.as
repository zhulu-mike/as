package com.thinkido.framework.engine.graphics.tagger
{
	import com.thinkido.framework.engine.Engine;
	
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * 
	 * @author wangjianglin
	 * 
	 */	
	public class BaseCustomFace
	{
		/**
		 * 自定义称号，存放在headface里面，而不是原来的customface
		 * 里面，因为原来的customface的坐标不好调。
		 */		
		public function BaseCustomFace()
		{
		}
		
		private static const FILTERS_UNLIGHT:Array = [new GlowFilter(3148544, 1, 2, 2, 15, BitmapFilterQuality.LOW)];
		public static const ONE_PIXEL_BLACK:GlowFilter = new GlowFilter(0x000000,1,2,2,50,1);
		
		private static const DEFAULTTEXTFORMAT:TextFormat = new TextFormat(Engine.font_HeadFace,12,0xffffff,null,null,null,null,null,"center");
		
		/**
		 * 深度，用于自定义称号排序,同一深度按添加顺序先后排
		 * depth越大，层级越高
		 */		
		public var depth:int = 0;
		
		/**
		 * 自定义称号的名字,用于区分其他的自定义称号
		 */		
		public var name:String = "";
		
		
		/**
		 * 自定义称号的内容，比如图片，自定义组件
		 */		
		public var content:DisplayObject;
		
		/**
		 * 设置称号的内容，如果content已经设置，则不需要设置text
		 * 设置text的目的在于提供简便的方式生产一个纯文字的称号
		 * 系统会自动帮你生成一个textfield并把text值赋值给它，然后把textfield作为content
		 * @param value 文字
		 * @param format 文字格式
		 */		
		public function setText(value:String, format:TextFormat=null, filters:Array=null):void
		{
			var container:TextField = new TextField();
			container.autoSize = TextFormatAlign.CENTER;//必须加这个，否则宽度不会自动适应
			content = container;
			container.mouseEnabled = false;
			container.defaultTextFormat = format != null ? format : DEFAULTTEXTFORMAT;
			if (filters)
				container.filters = filters;
			else
				container.filters = [ONE_PIXEL_BLACK];
			container.width = 0;
			container.x = 0;
			container.text = value;
		}
		
		
	}
}