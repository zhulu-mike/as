package tools.common.bind
{
	import flash.events.EventDispatcher;

    public class Data extends EventDispatcher
    {
		/**
		 * @example
		 * <listing version="3.0"> 
				package
				{
					import game.utils.bind.Data;
				
					public class TestVO extends Data 
					{ 
						private var _name:String = "jack" ;
						
						public function TestVO()
						{
						}
						
						public function get name():String
						{
							return _name;
						}
				
						public function set name(value:String):void
						{
							valueChanged("name", "_name", value);
						}
						override protected function setProperty($name:String, $value) : void
						{
							this[$name] = $value;
							return;
						}
						
						override protected function getProperty($name:String)
						{
							return this[$name];
						}
					}
				}
		   </listing> 
		 */
        public function Data()
        {
            super(null);
            return;
        }

        protected function valueChanged($eventName:String, $propName:String, $value:*) : void
        {
            var _data:* = getProperty($propName);
            setProperty($propName, $value);
            if ($value != _data)
            {
                this.dispatchEvent(new DataChangeEvent($eventName, _data, $value));
            }
            return;
        }

        protected function getProperty($name:String):*
        {
            return this[$name];
        }

        protected function setProperty($name:String, $value:*) : void
        {
            this[$name] = $value;
            return;
        }

    }
}
