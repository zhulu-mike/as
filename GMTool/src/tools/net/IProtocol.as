package tools.net
{
    import flash.utils.*;

    public interface IProtocol
    {


        function get body() : ByteArray;

//        function get header() : IProtocolHeader;

        function get length() : uint;

        function get type() : *;

		function get data():* ;
		
		/**
		 * 打印信息，以便开发 
		 * @return 
		 * 
		 */		
		function get content():String ;
    }
}
