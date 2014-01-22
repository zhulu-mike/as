package com.thinkido.framework.core.call
{
	import com.thinkido.framework.core.IDispose;
	

    public interface ICaller extends IDispose
    {

        function addCall(param1:Object, param2:Function) : void;

        function removeCall(param1:Object, param2:Function) : void;

        function removeCallByType(param1:Object) : void;

        function call(param1:Object, ... args) : Boolean;

    }
}
