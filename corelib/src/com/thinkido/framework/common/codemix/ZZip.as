package com.thinkido.framework.common.codemix
{
	import flash.utils.ByteArray;
	
	import nochump.util.zip.ZipEntry;
	import nochump.util.zip.ZipFile;

    public class ZZip extends Object
    {

        public function ZZip()
        {
            return;
        }

        public static function extractTextFiles($data:ByteArray, $decode:Function = null) : Array
        {
            var index:int = 0;
            var _zipEntry:ZipEntry = null;
			var result:Array = [];
			var _zipFile:ZipFile = new ZipFile($data);
            var len:int = _zipFile.entries.length;
            index = 0;
            while (index < len)
            {
                _zipEntry = _zipFile.entries[index];
                $data = _zipFile.getInput(_zipEntry);
                if ($decode != null)
                {
                    $data = $decode($data);
                }
                $data.position = 0;
                result.push([_zipEntry.name, $data.readUTFBytes($data.bytesAvailable)]);
                index++;
            }
            return result;
        }

        public static function extractFristTextFileContent($data:ByteArray, $decode:Function = null) : String
        {
            var arr:Array = extractTextFiles($data, $decode);
            if (arr && arr.length > 0)
            {
                return arr[0][1];
            }
            return "";
        }

    }
}
