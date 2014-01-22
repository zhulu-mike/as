package lm.mui.manager
{
	import flash.events.IEventDispatcher;

    public interface IDragDrop extends IEventDispatcher
    {

        function get dragSource() : Object;

        function set dragSource(param1:Object) : void;

        function get isDragAble() : Boolean;

        function get isDropAble() : Boolean;

        function get isThrowAble() : Boolean;

        function canDrop(param1:IDragDrop, param2:IDragDrop) : Boolean;

    }
}
