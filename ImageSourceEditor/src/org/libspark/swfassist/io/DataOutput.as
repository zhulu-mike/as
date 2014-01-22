/*
 * Copyright(c) 2007 the Spark project.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
 * either express or implied. See the License for the specific language
 * governing permissions and limitations under the License.
 */

package org.libspark.swfassist.io
{
	import flash.utils.ByteArray;
	
	public interface DataOutput
	{
		function get length():uint;
		
		function get position():uint;
		function set position(value:uint):void;
		
		function writeS8(value:int):void;
		function writeS16(value:int):void;
		function writeS32(value:int):void;
		function writeU8(value:uint):void;
		function writeU16(value:uint):void;
		function writeU32(value:uint):void;
		function writeFixed(value:Number):void;
		function writeFixed8(value:Number):void;
		function writeFloat16(value:Number):void;
		function writeFloat(value:Number):void;
		function writeDouble(value:Number):void;
		function writeEncodedU32(value:uint):void;
		function writeBit(value:Boolean):void;
		function writeUBits(numBits:uint, value:uint):void;
		function writeSBits(numBits:uint, value:int):void;
		function writeFBits(numBits:uint, value:Number):void;
		function resetBitCursor():void;
		function writeUTF(value:String, isNullTerminated:Boolean = true):void;
		function writeString(value:String, charset:String = 'iso-8859-1', isNullTerminated:Boolean = true):void;
		function writeBytes(source:ByteArray):void;
		function compress(offset:uint = 0, length:uint = 0):void;
	}
}