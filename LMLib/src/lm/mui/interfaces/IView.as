package lm.mui.interfaces
{
	import flash.events.IEventDispatcher;

    public interface IView extends IEventDispatcher
    {

        function update(param1:Object, ... args) : void;

        function hide() : void;

        function show(param1:int = 0, param2:int = 0) : void;

        function set layer(param1:ILayer) : void;

        function get layer() : ILayer;

        function get isHide() : Boolean;

        function get x() : Number;

        function get y() : Number;

        function get height() : Number;

        function get width() : Number;

        function dispose() : void;

    }
}
