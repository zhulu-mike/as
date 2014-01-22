package helper
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import org.libspark.swfassist.io.ByteArrayOutputStream;
	import org.libspark.swfassist.swf.io.SWFWriter;
	import org.libspark.swfassist.swf.io.WritingContext;
	import org.libspark.swfassist.swf.structures.Asset;
	import org.libspark.swfassist.swf.structures.RGB;
	import org.libspark.swfassist.swf.structures.Rect;
	import org.libspark.swfassist.swf.structures.SWF;
	import org.libspark.swfassist.swf.structures.SceneData;
	import org.libspark.swfassist.swf.tags.ABCNameSpaceConstants;
	import org.libspark.swfassist.swf.tags.DefineBitsJPEG3;
	import org.libspark.swfassist.swf.tags.DefineBitsLossless2;
	import org.libspark.swfassist.swf.tags.DefineSceneAndFrameLabelData;
	import org.libspark.swfassist.swf.tags.DoABC;
	import org.libspark.swfassist.swf.tags.Metadata;
	import org.libspark.swfassist.swf.tags.MultinameConstants;
	import org.libspark.swfassist.swf.tags.SetBackgroundColor;
	import org.libspark.swfassist.swf.tags.ShowFrame;
	import org.libspark.swfassist.swf.tags.SymbolClass;
	
	import vo.ActionVO;

	public class SWFHelper
	{
		public function SWFHelper()
		{
		}
		
		public static function makeSWFByteArray(imgs:Array,className:String,xmlStr:String):ByteArray
		{
			var swf:SWF = new SWF();
			swf.header.frameRate = 24;
			swf.header.isCompressed = true;
			swf.header.numFrames = 1;
			swf.header.version = 10;
			var rect:Rect = new Rect();
			rect.xMin = 0;
			rect.xMax = 550;
			rect.yMin = 0;
			rect.yMax = 400;
			swf.header.frameSize = rect;
			swf.fileAttributes.hasMetadata = true;
			swf.fileAttributes.isActionScript3 = true;
			swf.fileAttributes.useNetwork = false;
			var meta:Metadata = new Metadata();
			meta.metadata = '<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"> <rdf:Description xmlns:xmp="http://ns.adobe.com/xap/1.0/" rdf:about=""> <xmp:CreatorTool>Adobe Flash Professional CS5</xmp:CreatorTool> <xmp:CreateDate>2012-03-27T00:56:48+08:00</xmp:CreateDate> <xmp:MetadataDate>2012-03-27T00:57+08:00</xmp:MetadataDate> <xmp:ModifyDate>2012-03-27T00:57+08:00</xmp:ModifyDate> </rdf:Description> <rdf:Description xmlns:dc="http://purl.org/dc/elements/1.1/" rdf:about=""> <dc:format>application/x-shockwave-flash</dc:format> </rdf:Description> <rdf:Description xmlns:xmpMM="http://ns.adobe.com/xap/1.0/mm/" xmlns:stRef="http://ns.adobe.com/xap/1.0/sType/ResourceRef#" rdf:about=""> <xmpMM:InstanceID>xmp.iid:4DD945AD6477E1119F3F93ED3A9A825E</xmpMM:InstanceID> <xmpMM:DocumentID>xmp.did:4DD945AD6477E1119F3F93ED3A9A825E</xmpMM:DocumentID> <xmpMM:OriginalDocumentID>xmp.did:4CD945AD6477E1119F3F93ED3A9A825E</xmpMM:OriginalDocumentID> <xmpMM:DerivedFrom rdf:parseType="Resource"> <stRef:instanceID>xmp.iid:4CD945AD6477E1119F3F93ED3A9A825E</stRef:instanceID> <stRef:documentID>xmp.did:4CD945AD6477E1119F3F93ED3A9A825E</stRef:documentID> <stRef:originalDocumentID>xmp.did:4CD945AD6477E1119F3F93ED3A9A825E</stRef:originalDocumentID> </xmpMM:DerivedFrom> </rdf:Description> </rdf:RDF>';
			
			swf.tags.addTag(meta);
			var background:SetBackgroundColor = new SetBackgroundColor();
			var rgb:RGB = new RGB();
			rgb.blue = 255;
			rgb.green = 255;
			rgb.red = 255;
			background.backgroundColor = rgb;
			swf.tags.addTag(background);
			var frameLabel:DefineSceneAndFrameLabelData = new DefineSceneAndFrameLabelData();
			var sceneData:SceneData = new SceneData();
			sceneData.frameOffset = 0;
			sceneData.name = "场景 1";
			frameLabel.scenes.push(sceneData);
			swf.tags.addTag(frameLabel);
			var actionLen:int = imgs.length, loop:int = 0;
			for (loop;loop<actionLen;loop++)
			{
//				var bitLoss:DefineBitsLossless2 = new DefineBitsLossless2();
//				bitLoss.characterId = actionLen-loop;
//				bitLoss.bitmapFormat = 5;
//				bitLoss.bitmapWidth = imgs[loop].width;
//				bitLoss.bitmapHeight = imgs[loop].height;
//				bitLoss.data = imgs[loop].bitmapByte;
//				swf.tags.addTag(bitLoss);
				var bitLoss:DefineBitsJPEG3 = new DefineBitsJPEG3();
				bitLoss.characterId = actionLen-loop;
				bitLoss.jpegData = imgs[loop].bitmapByte;
				bitLoss.bitmapAlphaData = imgs[loop].bitAlphaByte;
				swf.tags.addTag(bitLoss);
			}
			var abc:DoABC = new DoABC();
			abc.isLazyInitialize = true;
			var abcByte:ByteArray = new ByteArray();
			abcByte.endian = Endian.LITTLE_ENDIAN;
			var out:ByteArrayOutputStream = new ByteArrayOutputStream(abcByte);
			out.writeU16(16);
			out.writeU16(46);
			out.writeU30(13);
			loop = 0;
			for (loop;loop<actionLen;loop++)
			{
				out.writeU30(imgs[loop].width);
				out.writeU30(imgs[loop].height);
			}
			out.writeU30(1);//units
			out.writeU30(1);//doubles
			out.writeU30(37);//strings
			var classStr:String = className+":attack";
			out.writeU30(0);
			out.writeU30(3);
			out.writeUTFString("int");
			out.writeU30(className.length);
			out.writeUTFString(className);
			out.writeU30(6);
			out.writeUTFString("attack");
			out.writeU30(13);
			out.writeUTFString("flash.display");
			out.writeU30(10);
			out.writeUTFString("BitmapData");
			
			out.writeU30(classStr.length);
			out.writeUTFString(classStr);
			out.writeU30(5);
			out.writeUTFString("death");
			classStr = className+":death";
			out.writeU30(classStr.length);
			out.writeUTFString(classStr);
			out.writeU30(7);
			out.writeUTFString("injured");
			classStr = className+":injured";
			out.writeU30(classStr.length);
			out.writeUTFString(classStr);
			out.writeU30(5);
			out.writeUTFString("skill");
			classStr = className+":skill";
			out.writeU30(classStr.length);
			out.writeUTFString(classStr);
			out.writeU30(5);
			out.writeUTFString("stand");
			classStr = className+":stand";
			out.writeU30(classStr.length);
			out.writeUTFString(classStr);
			out.writeU30(4);
			out.writeUTFString("walk");
			classStr = className+":walk";
			out.writeU30(classStr.length);
			out.writeUTFString(classStr);
			
			out.writeU30(9);
			out.writeUTFString("MovieClip");
			out.writeU30(6);
			out.writeUTFString("frame1");
			out.writeU30(5);
			out.writeUTFString("X_M_L");
			out.writeU30(3);
			out.writeUTFString("XML");
			out.writeU30(6);
			out.writeUTFString("Object");
			out.writeU30(xmlStr.length);
			out.writeUTFString(xmlStr);
			out.writeU30(14);
			out.writeUTFString("addFrameScript");
			out.writeU30(12);
			out.writeUTFString("flash.system");
			out.writeU30(8);
			out.writeUTFString("Security");
			out.writeU30(1);
			out.writeUTFString("*");
			out.writeU30(11);
			out.writeUTFString("allowDomain");
			out.writeU30(5);
			out.writeUTFString("Error");
			out.writeU30(1);
			out.writeUTFString("e");
			out.writeU30(12);
			out.writeUTFString("flash.events");
			out.writeU30(15);
			out.writeUTFString("EventDispatcher");
			out.writeU30(13);
			out.writeUTFString("DisplayObject");
			out.writeU30(17);
			out.writeUTFString("InteractiveObject");
			out.writeU30(22);
			out.writeUTFString("DisplayObjectContainer");
			out.writeU30(6);
			out.writeUTFString("Sprite");   
			
			out.writeU30(14);//namespaces
			
			out.writeU8(ABCNameSpaceConstants.CONSTANT_PACKAGE_NAEMSPACE);
			out.writeU30(1);
			out.writeU8(ABCNameSpaceConstants.CONSTANT_PACKAGE_NAEMSPACE);
			out.writeU30(3);
			out.writeU8(ABCNameSpaceConstants.CONSTANT_PACKAGE_NAEMSPACE);
			out.writeU30(5);
			
			out.writeU8(ABCNameSpaceConstants.CONSTANT_PROTECTED_NAEMSPACE);
			out.writeU30(7);
			out.writeU8(ABCNameSpaceConstants.CONSTANT_PROTECTED_NAEMSPACE);
			out.writeU30(9);
			out.writeU8(ABCNameSpaceConstants.CONSTANT_PROTECTED_NAEMSPACE);
			out.writeU30(11);
			out.writeU8(ABCNameSpaceConstants.CONSTANT_PROTECTED_NAEMSPACE);
			out.writeU30(13);
			out.writeU8(ABCNameSpaceConstants.CONSTANT_PROTECTED_NAEMSPACE);
			out.writeU30(15);
			out.writeU8(ABCNameSpaceConstants.CONSTANT_PROTECTED_NAEMSPACE);
			out.writeU30(17);
			out.writeU8(ABCNameSpaceConstants.CONSTANT_PROTECTED_NAEMSPACE);
			out.writeU30(3);
			
			out.writeU8(ABCNameSpaceConstants.CONSTANT_PACKAGE_INTERNALNS);
			out.writeU30(1);
			out.writeU8(ABCNameSpaceConstants.CONSTANT_PACKAGE_NAEMSPACE);
			out.writeU30(25);
			out.writeU8(ABCNameSpaceConstants.CONSTANT_PACKAGE_NAEMSPACE);
			out.writeU30(31);
			
			out.writeU30(0);//namespaceSets
			out.writeU30(25);//multinames
			
			out.writeU8(MultinameConstants.QNAME);
			out.writeU30(1);
			out.writeU30(2);
			out.writeU8(MultinameConstants.QNAME);
			out.writeU30(2);
			out.writeU30(4);
			out.writeU8(MultinameConstants.QNAME);
			out.writeU30(3);
			out.writeU30(6);
			out.writeU8(MultinameConstants.QNAME);
			out.writeU30(2);
			out.writeU30(8);
			out.writeU8(MultinameConstants.QNAME);
			out.writeU30(2);
			out.writeU30(10);
			out.writeU8(MultinameConstants.QNAME);
			out.writeU30(2);
			out.writeU30(12);
			out.writeU8(MultinameConstants.QNAME);
			out.writeU30(2);
			out.writeU30(14);
			out.writeU8(MultinameConstants.QNAME);
			out.writeU30(2);
			out.writeU30(16);
			out.writeU8(MultinameConstants.QNAME);
			out.writeU30(1);
			out.writeU30(3);
			out.writeU8(MultinameConstants.QNAME);
			out.writeU30(3);
			out.writeU30(18);
			out.writeU8(MultinameConstants.QNAME);
			out.writeU30(11);
			out.writeU30(19);
			
			out.writeU8(MultinameConstants.QNAME);
			out.writeU30(1);
			out.writeU30(20);
			out.writeU8(MultinameConstants.QNAME);
			out.writeU30(1);
			out.writeU30(21);
			out.writeU8(MultinameConstants.QNAME);
			out.writeU30(1);
			out.writeU30(22);
			out.writeU8(MultinameConstants.QNAME);
			out.writeU30(1);
			out.writeU30(24);
			out.writeU8(MultinameConstants.QNAME);
			out.writeU30(12);
			out.writeU30(26);
			
			out.writeU8(MultinameConstants.QNAME);
			out.writeU30(1);
			out.writeU30(28);
			out.writeU8(MultinameConstants.QNAME);
			out.writeU30(1);
			out.writeU30(29);
			out.writeU8(MultinameConstants.QNAME);
			out.writeU30(1);
			out.writeU30(30);
			out.writeU8(MultinameConstants.QNAME);
			out.writeU30(13);
			out.writeU30(32);
			out.writeU8(MultinameConstants.QNAME);
			out.writeU30(3);
			out.writeU30(33);
			out.writeU8(MultinameConstants.QNAME);
			out.writeU30(3);
			out.writeU30(34);
			out.writeU8(MultinameConstants.QNAME);
			out.writeU30(3);
			out.writeU30(35);
			out.writeU8(MultinameConstants.QNAME);
			out.writeU30(3);
			out.writeU30(36);
			
			//methods
			out.writeU30(22);
			
			out.writeU30(0);
			out.writeU30(0);
			out.writeU30(0);
			out.writeU8(0);
			
			//第一个动作的图片的构造函数
			out.writeU30(2);
			out.writeU30(0);
			out.writeU30(1);
			out.writeU30(1);
			out.writeU30(0);
			out.writeU8(0x08);//flag
			out.writeU30(2);//option count
			out.writeU30(1);
			out.writeU8(0x03);
			out.writeU30(2);
			out.writeU8(0x03);
			
			
			out.writeU30(0);
			out.writeU30(0);
			out.writeU30(0);
			out.writeU8(0);
			
			out.writeU30(0);
			out.writeU30(0);
			out.writeU30(0);
			out.writeU8(0);
			//第二个动作的图片的构造函数
			out.writeU30(2);
			out.writeU30(0);
			out.writeU30(1);
			out.writeU30(1);
			out.writeU30(0);
			out.writeU8(0x08);//flag
			out.writeU30(2);//option count
			out.writeU30(3);
			out.writeU8(0x03);
			out.writeU30(4);
			out.writeU8(0x03);
			
			
			out.writeU30(0);
			out.writeU30(0);
			out.writeU30(0);
			out.writeU8(0);
			
			out.writeU30(0);
			out.writeU30(0);
			out.writeU30(0);
			out.writeU8(0);
			
			//第三个动作的图片的构造函数
			out.writeU30(2);
			out.writeU30(0);
			out.writeU30(1);
			out.writeU30(1);
			out.writeU30(0);
			out.writeU8(0x08);//flag
			out.writeU30(2);//option count
			out.writeU30(5);
			out.writeU8(0x03);
			out.writeU30(6);
			out.writeU8(0x03);
			
			out.writeU30(0);
			out.writeU30(0);
			out.writeU30(0);
			out.writeU8(0);
			
			out.writeU30(0);
			out.writeU30(0);
			out.writeU30(0);
			out.writeU8(0);
			
			//第四个动作的图片的构造函数
			out.writeU30(2);
			out.writeU30(0);
			out.writeU30(1);
			out.writeU30(1);
			out.writeU30(0);
			out.writeU8(0x08);//flag
			out.writeU30(2);//option count
			out.writeU30(7);
			out.writeU8(0x03);
			out.writeU30(8);
			out.writeU8(0x03);
			
			out.writeU30(0);
			out.writeU30(0);
			out.writeU30(0);
			out.writeU8(0);
			
			out.writeU30(0);
			out.writeU30(0);
			out.writeU30(0);
			out.writeU8(0);
			
			//第五个动作的图片的构造函数
			out.writeU30(2);
			out.writeU30(0);
			out.writeU30(1);
			out.writeU30(1);
			out.writeU30(0);
			out.writeU8(0x08);//flag
			out.writeU30(2);//option count
			out.writeU30(9);
			out.writeU8(0x03);
			out.writeU30(10);
			out.writeU8(0x03);
			
			out.writeU30(0);
			out.writeU30(0);
			out.writeU30(0);
			out.writeU8(0);
			
			out.writeU30(0);
			out.writeU30(0);
			out.writeU30(0);
			out.writeU8(0);
			
			//第六个动作的图片的构造函数
			out.writeU30(2);
			out.writeU30(0);
			out.writeU30(1);
			out.writeU30(1);
			out.writeU30(0);
			out.writeU8(0x08);//flag
			out.writeU30(2);//option count
			out.writeU30(11);
			out.writeU8(0x03);
			out.writeU30(12);
			out.writeU8(0x03);
			
			out.writeU30(0);
			out.writeU30(0);
			out.writeU30(0);
			out.writeU8(0);
			
			out.writeU30(0);
			out.writeU30(0);
			out.writeU30(0);
			out.writeU8(0);
			
			out.writeU30(0);
			out.writeU30(0);
			out.writeU30(0);
			out.writeU8(0);
			
			
			out.writeU30(0);
			out.writeU30(0);
			out.writeU30(0);
			out.writeU8(0x02);
			
			out.writeU30(0);
			out.writeU30(0);
			out.writeU30(0);
			out.writeU8(0);

			
			out.writeU30(0);//metadata count
			
			out.writeU30(7);//instance and class count
			
			out.writeU30(2);//name
			out.writeU30(3);//super
			out.writeU8(0x08);//flags
			out.writeU30(4);//protectedns
			out.writeU30(0);//intrf count
			out.writeU30(1);//iinit
			out.writeU30(0);//trait count
			
			out.writeU30(4);//name
			out.writeU30(3);//super
			out.writeU8(0x08);//flags
			out.writeU30(5);//protectedns
			out.writeU30(0);//intrf count
			out.writeU30(4);//iinit
			out.writeU30(0);//trait count
			
			out.writeU30(5);//name
			out.writeU30(3);//super
			out.writeU8(0x08);//flags
			out.writeU30(6);//protectedns
			out.writeU30(0);//intrf count
			out.writeU30(7);//iinit
			out.writeU30(0);//trait count
			
			out.writeU30(6);//name
			out.writeU30(3);//super
			out.writeU8(0x08);//flags
			out.writeU30(7);//protectedns
			out.writeU30(0);//intrf count
			out.writeU30(10);//iinit
			out.writeU30(0);//trait count
			
			out.writeU30(7);//name
			out.writeU30(3);//super
			out.writeU8(0x08);//flags
			out.writeU30(8);//protectedns
			out.writeU30(0);//intrf count
			out.writeU30(13);//iinit
			out.writeU30(0);//trait count
			
			out.writeU30(8);//name
			out.writeU30(3);//super
			out.writeU8(0x08);//flags
			out.writeU30(9);//protectedns
			out.writeU30(0);//intrf count
			out.writeU30(16);//iinit
			out.writeU30(0);//trait count
			
			
			
			
			
			out.writeU30(9);//name
			out.writeU30(10);//super
			out.writeU8(0x09);//flags
			out.writeU30(10);//protectedns
			out.writeU30(0);//intrf count
			out.writeU30(19);//iinit
			out.writeU30(1);//trait count
			
			out.writeU30(11);//trait name
			out.writeU8(0x01);//kind
			out.writeU30(0);//mthod trait disp_id
			out.writeU30(20);//method trait method index
			
			out.writeU30(0);//class cinit
			out.writeU30(0);// class trait count
			
			out.writeU30(3);//class cinit
			out.writeU30(0);// class trait count
			
			out.writeU30(6);//class cinit
			out.writeU30(0);// class trait count
			
			out.writeU30(9);//class cinit
			out.writeU30(0);// class trait count
			
			out.writeU30(12);//class cinit
			out.writeU30(0);// class trait count
			
			out.writeU30(15);//class cinit
			out.writeU30(0);// class trait count
			
			out.writeU30(18);//class cinit
			out.writeU30(1);// class trait count
			
			out.writeU30(12);//trait name
			out.writeU8(0x06);//kind
			out.writeU30(1);//const trait slot id
			out.writeU30(13);//const trait typeindex id
			out.writeU30(0);//const trait vindex id
			
			//scripts
			out.writeU30(7);//script count
			
			out.writeU30(2);//init index
			out.writeU30(1);// trait count
			
			out.writeU30(2);//trait name
			out.writeU8(0x04);//kind-class
			out.writeU30(1);//class trait slotid
			out.writeU30(0);//const trait classi
			
			out.writeU30(5);//init index
			out.writeU30(1);// trait count
			out.writeU30(4);//trait name
			out.writeU8(0x04);//kind-class
			out.writeU30(1);//class trait slotid
			out.writeU30(1);//const trait classi
			
			out.writeU30(8);//init index
			out.writeU30(1);// trait count
			out.writeU30(5);//trait name
			out.writeU8(0x04);//kind-class
			out.writeU30(1);//class trait slotid
			out.writeU30(2);//const trait classi
			
			out.writeU30(11);//init index
			out.writeU30(1);// trait count
			out.writeU30(6);//trait name
			out.writeU8(0x04);//kind-class
			out.writeU30(1);//class trait slotid
			out.writeU30(3);//const trait classi
			
			out.writeU30(14);//init index
			out.writeU30(1);// trait count
			out.writeU30(7);//trait name
			out.writeU8(0x04);//kind-class
			out.writeU30(1);//class trait slotid
			out.writeU30(4);//const trait classi
			
			out.writeU30(17);//init index
			out.writeU30(1);// trait count
			out.writeU30(8);//trait name
			out.writeU8(0x04);//kind-class
			out.writeU30(1);//class trait slotid
			out.writeU30(5);//const trait classi
			
			out.writeU30(21);//init index
			out.writeU30(1);// trait count
			out.writeU30(9);//trait name
			out.writeU8(0x04);//kind-class
			out.writeU30(1);//class trait slotid
			out.writeU30(6);//const trait classi
			
			//methodBodies
			out.writeU30(22);//mehodbodies count
			
			out.writeU30(0);//method index
			out.writeU30(1);//max stack
			out.writeU30(1);//local_count = maxregister
			out.writeU30(4);//init scope
			out.writeU30(5);//max scope
			out.writeU30(3);//code length,所有的code的字节码的个数
			out.writeU8(InstructorType.OpGetLocal0);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPRETURNVOID);
			out.writeU30(0);//exception_count
			out.writeU30(0); //trait_count
			
			
			out.writeU30(1);//method index
			out.writeU30(3);//max stack
			out.writeU30(3);//local_count = maxregister
			out.writeU30(5);//init scope
			out.writeU30(6);//max scope
			out.writeU30(8);//code length
			out.writeU8(InstructorType.OpGetLocal0);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OpGetLocal0);
			out.writeU8(InstructorType.OpGetLocal1);
			out.writeU8(InstructorType.OpGetLocal2);
			out.writeU8(InstructorType.OPConstructSuper);
			out.writeU30(2);//agc
			out.writeU8(InstructorType.OPRETURNVOID);
			out.writeU30(0);
			out.writeU30(0);
			
			
			out.writeU30(2);//method index
			out.writeU30(2);//max stack
			out.writeU30(1);//local_count = maxregister
			out.writeU30(1);//init scope
			out.writeU30(4);//max scope
			out.writeU30(19);//code length
			out.writeU8(InstructorType.OpGetLocal0);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPGetscopeobject);
			out.writeS8(0);//scopeIndex
			out.writeU8(InstructorType.OPGetLex);
			out.writeU30(14);//name
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPGetLex);
			out.writeU30(3);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPGetLex);
			out.writeU30(3);
			out.writeU8(InstructorType.OPNewClass);
			out.writeU30(0);//classIndex
			out.writeU8(InstructorType.OPPopScope);
			out.writeU8(InstructorType.OPPopScope);
			out.writeU8(InstructorType.OPInitProperty);
			out.writeU30(2);//name
			out.writeU8(InstructorType.OPRETURNVOID);
			out.writeU30(0);
			out.writeU30(0);
			
			out.writeU30(3);//method index
			out.writeU30(1);//max stack
			out.writeU30(1);//local_count = maxregister
			out.writeU30(4);//init scope
			out.writeU30(5);//max scope
			out.writeU30(3);//code length,所有的code的字节码的个数
			out.writeU8(InstructorType.OpGetLocal0);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPRETURNVOID);
			out.writeU30(0);//exception_count
			out.writeU30(0); //trait_count
			
			out.writeU30(4);//method index
			out.writeU30(3);//max stack
			out.writeU30(3);//local_count = maxregister
			out.writeU30(5);//init scope
			out.writeU30(6);//max scope
			out.writeU30(8);//code length
			out.writeU8(InstructorType.OpGetLocal0);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OpGetLocal0);
			out.writeU8(InstructorType.OpGetLocal1);
			out.writeU8(InstructorType.OpGetLocal2);
			out.writeU8(InstructorType.OPConstructSuper);
			out.writeU30(2);//agc
			out.writeU8(InstructorType.OPRETURNVOID);
			out.writeU30(0);
			out.writeU30(0);
			
			out.writeU30(5);//method index
			out.writeU30(2);//max stack
			out.writeU30(1);//local_count = maxregister
			out.writeU30(1);//init scope
			out.writeU30(4);//max scope
			out.writeU30(19);//code length
			out.writeU8(InstructorType.OpGetLocal0);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPGetscopeobject);
			out.writeS8(0);//scopeIndex
			out.writeU8(InstructorType.OPGetLex);
			out.writeU30(14);//name
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPGetLex);
			out.writeU30(3);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPGetLex);
			out.writeU30(3);
			out.writeU8(InstructorType.OPNewClass);
			out.writeU30(1);//classIndex
			out.writeU8(InstructorType.OPPopScope);
			out.writeU8(InstructorType.OPPopScope);
			out.writeU8(InstructorType.OPInitProperty);
			out.writeU30(4);//name
			out.writeU8(InstructorType.OPRETURNVOID);
			out.writeU30(0);
			out.writeU30(0);
			
			out.writeU30(6);//method index
			out.writeU30(1);//max stack
			out.writeU30(1);//local_count = maxregister
			out.writeU30(4);//init scope
			out.writeU30(5);//max scope
			out.writeU30(3);//code length,所有的code的字节码的个数
			out.writeU8(InstructorType.OpGetLocal0);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPRETURNVOID);
			out.writeU30(0);//exception_count
			out.writeU30(0); //trait_count
			
			out.writeU30(7);//method index
			out.writeU30(3);//max stack
			out.writeU30(3);//local_count = maxregister
			out.writeU30(5);//init scope
			out.writeU30(6);//max scope
			out.writeU30(8);//code length
			out.writeU8(InstructorType.OpGetLocal0);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OpGetLocal0);
			out.writeU8(InstructorType.OpGetLocal1);
			out.writeU8(InstructorType.OpGetLocal2);
			out.writeU8(InstructorType.OPConstructSuper);
			out.writeU30(2);//agc
			out.writeU8(InstructorType.OPRETURNVOID);
			out.writeU30(0);
			out.writeU30(0);
			
			out.writeU30(8);//method index
			out.writeU30(2);//max stack
			out.writeU30(1);//local_count = maxregister
			out.writeU30(1);//init scope
			out.writeU30(4);//max scope
			out.writeU30(19);//code length
			out.writeU8(InstructorType.OpGetLocal0);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPGetscopeobject);
			out.writeS8(0);//scopeIndex
			out.writeU8(InstructorType.OPGetLex);
			out.writeU30(14);//name
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPGetLex);
			out.writeU30(3);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPGetLex);
			out.writeU30(3);
			out.writeU8(InstructorType.OPNewClass);
			out.writeU30(2);//classIndex
			out.writeU8(InstructorType.OPPopScope);
			out.writeU8(InstructorType.OPPopScope);
			out.writeU8(InstructorType.OPInitProperty);
			out.writeU30(5);//name
			out.writeU8(InstructorType.OPRETURNVOID);
			out.writeU30(0);
			out.writeU30(0);
			
			out.writeU30(9);//method index
			out.writeU30(1);//max stack
			out.writeU30(1);//local_count = maxregister
			out.writeU30(4);//init scope
			out.writeU30(5);//max scope
			out.writeU30(3);//code length,所有的code的字节码的个数
			out.writeU8(InstructorType.OpGetLocal0);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPRETURNVOID);
			out.writeU30(0);//exception_count
			out.writeU30(0); //trait_count
			
			out.writeU30(10);//method index
			out.writeU30(3);//max stack
			out.writeU30(3);//local_count = maxregister
			out.writeU30(5);//init scope
			out.writeU30(6);//max scope
			out.writeU30(8);//code length
			out.writeU8(InstructorType.OpGetLocal0);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OpGetLocal0);
			out.writeU8(InstructorType.OpGetLocal1);
			out.writeU8(InstructorType.OpGetLocal2);
			out.writeU8(InstructorType.OPConstructSuper);
			out.writeU30(2);//agc
			out.writeU8(InstructorType.OPRETURNVOID);
			out.writeU30(0);
			out.writeU30(0);
			
			out.writeU30(11);//method index
			out.writeU30(2);//max stack
			out.writeU30(1);//local_count = maxregister
			out.writeU30(1);//init scope
			out.writeU30(4);//max scope
			out.writeU30(19);//code length
			out.writeU8(InstructorType.OpGetLocal0);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPGetscopeobject);
			out.writeS8(0);//scopeIndex
			out.writeU8(InstructorType.OPGetLex);
			out.writeU30(14);//name
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPGetLex);
			out.writeU30(3);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPGetLex);
			out.writeU30(3);
			out.writeU8(InstructorType.OPNewClass);
			out.writeU30(3);//classIndex
			out.writeU8(InstructorType.OPPopScope);
			out.writeU8(InstructorType.OPPopScope);
			out.writeU8(InstructorType.OPInitProperty);
			out.writeU30(6);//name
			out.writeU8(InstructorType.OPRETURNVOID);
			out.writeU30(0);
			out.writeU30(0);
			
			out.writeU30(12);//method index
			out.writeU30(1);//max stack
			out.writeU30(1);//local_count = maxregister
			out.writeU30(4);//init scope
			out.writeU30(5);//max scope
			out.writeU30(3);//code length,所有的code的字节码的个数
			out.writeU8(InstructorType.OpGetLocal0);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPRETURNVOID);
			out.writeU30(0);//exception_count
			out.writeU30(0); //trait_count
			
			out.writeU30(13);//method index
			out.writeU30(3);//max stack
			out.writeU30(3);//local_count = maxregister
			out.writeU30(5);//init scope
			out.writeU30(6);//max scope
			out.writeU30(8);//code length
			out.writeU8(InstructorType.OpGetLocal0);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OpGetLocal0);
			out.writeU8(InstructorType.OpGetLocal1);
			out.writeU8(InstructorType.OpGetLocal2);
			out.writeU8(InstructorType.OPConstructSuper);
			out.writeU30(2);//agc
			out.writeU8(InstructorType.OPRETURNVOID);
			out.writeU30(0);
			out.writeU30(0);
			
			out.writeU30(14);//method index
			out.writeU30(2);//max stack
			out.writeU30(1);//local_count = maxregister
			out.writeU30(1);//init scope
			out.writeU30(4);//max scope
			out.writeU30(19);//code length
			out.writeU8(InstructorType.OpGetLocal0);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPGetscopeobject);
			out.writeS8(0);//scopeIndex
			out.writeU8(InstructorType.OPGetLex);
			out.writeU30(14);//name
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPGetLex);
			out.writeU30(3);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPGetLex);
			out.writeU30(3);
			out.writeU8(InstructorType.OPNewClass);
			out.writeU30(4);//classIndex
			out.writeU8(InstructorType.OPPopScope);
			out.writeU8(InstructorType.OPPopScope);
			out.writeU8(InstructorType.OPInitProperty);
			out.writeU30(7);//name
			out.writeU8(InstructorType.OPRETURNVOID);
			out.writeU30(0);
			out.writeU30(0);
			
			out.writeU30(15);//method index
			out.writeU30(1);//max stack
			out.writeU30(1);//local_count = maxregister
			out.writeU30(4);//init scope
			out.writeU30(5);//max scope
			out.writeU30(3);//code length,所有的code的字节码的个数
			out.writeU8(InstructorType.OpGetLocal0);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPRETURNVOID);
			out.writeU30(0);//exception_count
			out.writeU30(0); //trait_count
			
			out.writeU30(16);//method index
			out.writeU30(3);//max stack
			out.writeU30(3);//local_count = maxregister
			out.writeU30(5);//init scope
			out.writeU30(6);//max scope
			out.writeU30(8);//code length
			out.writeU8(InstructorType.OpGetLocal0);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OpGetLocal0);
			out.writeU8(InstructorType.OpGetLocal1);
			out.writeU8(InstructorType.OpGetLocal2);
			out.writeU8(InstructorType.OPConstructSuper);
			out.writeU30(2);//agc
			out.writeU8(InstructorType.OPRETURNVOID);
			out.writeU30(0);
			out.writeU30(0);
			
			out.writeU30(17);//method index
			out.writeU30(2);//max stack
			out.writeU30(1);//local_count = maxregister
			out.writeU30(1);//init scope
			out.writeU30(4);//max scope
			out.writeU30(19);//code length
			out.writeU8(InstructorType.OpGetLocal0);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPGetscopeobject);
			out.writeS8(0);//scopeIndex
			out.writeU8(InstructorType.OPGetLex);
			out.writeU30(14);//name
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPGetLex);
			out.writeU30(3);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPGetLex);
			out.writeU30(3);
			out.writeU8(InstructorType.OPNewClass);
			out.writeU30(5);//classIndex
			out.writeU8(InstructorType.OPPopScope);
			out.writeU8(InstructorType.OPPopScope);
			out.writeU8(InstructorType.OPInitProperty);
			out.writeU30(8);//name
			out.writeU8(InstructorType.OPRETURNVOID);
			out.writeU30(0);
			out.writeU30(0);
			
			
			
			out.writeU30(18);//method index
			out.writeU30(3);//max stack
			out.writeU30(1);//local_count = maxregister
			out.writeU30(9);//init scope
			out.writeU30(10);//max scope
			out.writeU30(13);//code length
			out.writeU8(InstructorType.OpGetLocal0);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPFindProperty);
			out.writeU30(12);//name
			out.writeU8(InstructorType.OPGetLex);//getlex
			out.writeU30(13);//name
			out.writeU8(InstructorType.OpPushString);//pushstring
			out.writeU30(23);//index
			out.writeU8(InstructorType.OpConstruct);//construct
			out.writeU30(1);//argc
			out.writeU8(InstructorType.OPInitProperty);//initproperty
			out.writeU30(12);
			out.writeU8(InstructorType.OPRETURNVOID);//returnvoid
			out.writeU30(0);
			out.writeU30(0);
			
			out.writeU30(19);//method index
			out.writeU30(3);//max stack
			out.writeU30(1);//local_count = maxregister
			out.writeU30(10);//init scope
			out.writeU30(11);//max scope
			out.writeU30(16);//code length
			out.writeU8(InstructorType.OpGetLocal0);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OpGetLocal0);
			out.writeU8(InstructorType.OPConstructSuper);//constructsuper
			out.writeU30(0);//argc
			out.writeU8(InstructorType.OPFindProperty);//findproperty
			out.writeU30(15);//name
			out.writeU8(InstructorType.OpPushByte);//push byte
			out.writeS8(0);//unsigned byte
			out.writeU8(InstructorType.OpGetLocal0);
			out.writeU8(InstructorType.OpGetproperty);//get property
			out.writeU30(11);
			out.writeU8(InstructorType.OpCallPropVoid);//callpropvoid
			out.writeU30(15);//name
			out.writeU30(2);//argc
			out.writeU8(InstructorType.OPRETURNVOID);
			out.writeU30(0);
			out.writeU30(0);
			
			out.writeU30(20);//method index
			out.writeU30(3);//max stack
			out.writeU30(3);//local_count = maxregister
			out.writeU30(11);//init scope
			out.writeU30(16);//max scope
			out.writeU30(34);//code length
			out.writeU8(InstructorType.OpGetLocal0);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OpNewActivation);//OpNewActivation
			out.writeU8(InstructorType.OpDup);//OpDup
			out.writeU8(InstructorType.OpSetLocal1);//OpSetLocal1
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPGetLex);//getlex
			out.writeU30(16);
			out.writeU8(InstructorType.OpPushString);//pushstring
			out.writeU30(27);
			out.writeU8(InstructorType.OpCallPropVoid);//callpropvoid
			out.writeU30(17);
			out.writeU30(1);
			out.writeU8(InstructorType.OpJump);//jump
			out.writeS24(16);//s24,target
			out.writeU8(InstructorType.OpGetLocal0);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OpGetLocal1);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OpNewCatch);//OpNewCatch
			out.writeU30(0);
			out.writeU8(InstructorType.OpDup);//OpDup
			out.writeU8(InstructorType.OpSetLocal2);//setlocal2
			out.writeU8(InstructorType.OpDup);//OpDup
			out.writeU8(InstructorType.OPPUSHSCOPE);//pushscope
			out.writeU8(InstructorType.OpSwap);//swap
			out.writeU8(InstructorType.OpSetSlot);//setslot
			out.writeU30(1);
			out.writeU8(InstructorType.OPPopScope);//popscope
			out.writeU8(InstructorType.OpKill);//kill
			out.writeU30(2);
			out.writeU8(InstructorType.OPRETURNVOID);
			out.writeU30(1);
			out.writeU30(6);
			out.writeU30(13);
			out.writeU30(17);
			out.writeU30(18);
			out.writeU30(19);
			out.writeU30(0);
			
			out.writeU30(21);//method index
			out.writeU30(2);//max stack
			out.writeU30(1);//local_count = maxregister
			out.writeU30(1);//init scope
			out.writeU30(9);//max scope
			out.writeU30(39);//code length
			out.writeU8(InstructorType.OpGetLocal0);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPGetscopeobject);//getscopeobject
			out.writeS8(0);
			out.writeU8(InstructorType.OPGetLex);//getlex
			out.writeU30(14);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPGetLex);//getlex
			out.writeU30(20);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPGetLex);//getlex
			out.writeU30(21);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPGetLex);//getlex
			out.writeU30(22);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPGetLex);//getlex
			out.writeU30(23);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPGetLex);//getlex
			out.writeU30(24);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPGetLex);//getlex
			out.writeU30(10);
			out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPGetLex);//getlex
			out.writeU30(10);
			//out.writeU8(InstructorType.OPPUSHSCOPE);
			out.writeU8(InstructorType.OPNewClass);//newclass
			out.writeU30(6);
			out.writeU8(InstructorType.OPPopScope);//popscope
			out.writeU8(InstructorType.OPPopScope);//popscope
			out.writeU8(InstructorType.OPPopScope);//popscope
			out.writeU8(InstructorType.OPPopScope);//popscope
			out.writeU8(InstructorType.OPPopScope);//popscope
			out.writeU8(InstructorType.OPPopScope);//popscope
			out.writeU8(InstructorType.OPPopScope);//popscope
			out.writeU8(InstructorType.OPInitProperty);//initproperty
			out.writeU30(9);
			out.writeU8(InstructorType.OPRETURNVOID);
			out.writeU30(0);
			out.writeU30(0);
			
			abc.abcData = abcByte;
			swf.tags.addTag(abc);
			
			var symbols:SymbolClass = new SymbolClass();
			var asset:Asset = new Asset();
			asset.characterId = 0;
			asset.name = className;
			symbols.symbols.push(asset);
			loop = 0;
			for (loop;loop<actionLen;loop++)
			{
				asset = new Asset();
				asset.characterId = actionLen-loop;
				asset.name = className+"."+imgs[loop].name;
				symbols.symbols.push(asset);
			}
			swf.tags.addTag(symbols);
			var showFrame:ShowFrame = new ShowFrame();
			swf.tags.addTag(showFrame);
			
			//var end:End = new End();
			//swf.tags.addTag(end);
			
			var output2:ByteArrayOutputStream = new ByteArrayOutputStream();
			var writecontext:WritingContext = new WritingContext();
			
			var swfwriter:SWFWriter = new SWFWriter();
			swfwriter.writeSWF(output2, writecontext, swf);
			return output2.byteArray;
		}
	}
}