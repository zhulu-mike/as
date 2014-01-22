package tools.handler.helper
{
	import flash.events.Event;

    public class HandlerHelper extends Object
    {

        public function HandlerHelper()
        {
            throw new Event("静态类");
        }

        public static function execute(fun:Function, params:Array = null):*
        {
            if (fun == null)
            {
                return null;
            }
            return fun.apply(null, params);
        }

    }
}
