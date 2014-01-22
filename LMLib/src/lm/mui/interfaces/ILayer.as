package lm.mui.interfaces
{
	import flash.display.DisplayObject;

    public interface ILayer
    {

        function addPopUp(param1:DisplayObject, param2:Boolean = false) : void;

        function centerPopup(param1:DisplayObject) : void;

        function setPosition(param1:DisplayObject, param2:int, param3:int) : void;

        function isTop(param1:DisplayObject) : Boolean;

        function removePopup(param1:DisplayObject) : void;

        function isPopup(param1:DisplayObject) : Boolean;

        function setTop(param1:DisplayObject) : void;

        function get width() : Number;

        function get height() : Number;

    }
}
