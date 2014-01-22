package com.g6game.display
{
	import flash.events.Event;
	import flash.events.TextEvent;
	
	
	import spark.components.TextInput;

	/**
	 * @author solo 
	 * copyright 2011-12-26
	 */
	public class MyTextInput extends spark.components.TextInput
	{
		
		private var _maxValue:int;
		private var _minValue:int;
		private var maxFlag:Boolean = false;
		private var minFlag:Boolean = false;
		
		public function MyTextInput()
		{
			super();
			this.addEventListener(TextEvent.TEXT_INPUT,doTextInput);
		}
		
		public function set maxValue(value:int):void
		{
			if (_maxValue != value)
			{
				_maxValue = value;
				maxFlag = true;
				if (!hasEventListener(Event.CHANGE))
				{
					this.addEventListener(Event.CHANGE,doTextChange);
				}
			}
		}
		
		public function set minValue(value:int):void
		{
			if (_minValue != value)
			{
				_minValue = value;
				minFlag = true;
				if (!hasEventListener(Event.CHANGE))
				{
					this.addEventListener(Event.CHANGE,doTextChange);
				}
			}
		}
		
		private function doTextInput(evt:TextEvent):void
		{
			if (evt.text == "\n")
			{
				evt.preventDefault();
			}
		}
		
		private function doTextChange(evt:Event):void
		{
			if (maxFlag && minFlag)
			{
				if (int(text) < _minValue) text = String(_minValue);
				else if (int(text) > _maxValue) text = String(_maxValue);
			}else if (maxFlag && !minFlag)
			{
				if (int(text) > _maxValue) text = String(_maxValue);
			}else if (!maxFlag && minFlag)
			{
				if (int(text) < _minValue) text = String(_minValue);
			}
		}
		
		
	}
}