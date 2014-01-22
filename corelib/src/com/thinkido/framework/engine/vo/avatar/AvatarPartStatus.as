package com.thinkido.framework.engine.vo.avatar
{
	import flash.utils.Dictionary;
	/**
	 * 状态 
	 * @author thinkido
	 * 对应<s k="attack" t="120" f="2">
	    <p a="0" f="0" sx="0" sy="182" w="129" h="123" tx="86" ty="84" ox="0" oy="0"/>
	    <p a="0" f="1" sx="0" sy="0" w="65" h="182" tx="41" ty="143" ox="0" oy="0"/>
	  </s>
	 */
    public class AvatarPartStatus extends Object
    {
        public var type:String;
        public var frame:int;
		/**
		 * 每帧播放时间 
		 */		
        public var time:int;
        public var classNamePrefix:String;
        public var isOldWay:Boolean;
        public var width:int;
        public var height:int;
        public var widthMax:int;
        public var heightMax:int;
        public var tx:int;
        public var ty:int;
        private var _apd_dict:Dictionary;
		
		
		/**
		 *  
		 * @param $Prefix 类名前缀
		 * @param $data 关联xml 数据
		 * 
			<s k='death' t='200' f='13'>
				<p a='0' f='0' sx='0' sy='0' w='66' h='129' tx='34' ty='110' ox='0' oy='0'/>
				<p a='0' f='1' sx='144' sy='0' w='83' h='118' tx='50' ty='126' ox='0' oy='0'/>
				<p a='0' f='2' sx='288' sy='0' w='88' h='108' tx='52' ty='106' ox='0' oy='0'/>
				<p a='0' f='3' sx='432' sy='0' w='85' h='104' tx='51' ty='107' ox='0' oy='0'/>
			</s>
		 */
        public function AvatarPartStatus($Prefix:String, $data:XML)
        {
            var index:int = 0;
            var currentFrame:int = 0;
            var tempFrame:int = 0;
            var tempIndex:int = 0;
            var tempTx:int = 0;
            var apdXml:XML = null;
            var apd:AvatarPartData = null;
            var tempAngle:int = 0;
            var apd1:AvatarPartData = null;
            this.classNamePrefix = $Prefix + ".";
            if ($data.name() == "status")
            {
                this.isOldWay = true;
                this.type = $data.@type;
                this.frame = $data.@frame;
                this.time = $data.@time;
                this.width = $data.@width;
                this.height = $data.@height;
                this.tx = $data.@tx;
                this.ty = $data.@ty;
                this._apd_dict = new Dictionary();
                index = 0;
                while (index <= 7)
                {
                    currentFrame = 0;
                    while (currentFrame < this.frame)
                    {
                        if (index == 0 || index >= 4)
                        {
                            tempFrame = currentFrame;
                            if (index == 0 || index == 4)
                            {
                                tempIndex = index;
                            }
                            else if (index == 7)
                            {
                                tempIndex = 1;
                            }
                            else if (index == 6)
                            {
                                tempIndex = 2;
                            }
                            else if (index == 5)
                            {
                                tempIndex = 3;
                            }
                            tempTx = this.tx;
                        }
                        else
                        {
                            tempFrame = this.frame - currentFrame - 1;
                            tempIndex = index - 1;
                            tempTx = this.width - this.tx;
                        }
                        apdXml = new XML("<p a=\"" + index + "\" f=\"" + currentFrame + "\" sx=\"" + tempFrame * this.width + "\" sy=\"" + tempIndex * this.height + "\" w=\"" + this.width + "\" h=\"" + this.height + "\" tx=\"" + tempTx + "\" ty=\"" + this.ty + "\" ox=\"0\" oy=\"0\"/>");
                        apd = new AvatarPartData(apdXml);
                        this._apd_dict[apd.angle + "_" + apd.frame] = apd;
                        currentFrame++;
						widthMax = Math.max(width,widthMax);
						heightMax = Math.max(height,heightMax);
                    }
                    index++;
                }
            }
            else
            {
                this.isOldWay = false;
                this.type = $data.@k;
                this.frame = $data.@f;
                this.time = $data.@t;
                this._apd_dict = new Dictionary();
                for each (apdXml in $data.children())
                {
                    
                    apd = new AvatarPartData(apdXml);
                    this._apd_dict[apd.angle + "_" + apd.frame] = apd;
                }
                index = 1;				
                while (index <= 3)
                {
                    
                    tempAngle = index;
                    if (index == 1)
                    {
                        tempAngle = 7;
                    }
                    else if (index == 2)
                    {
                        tempAngle = 6;
                    }
                    else if (index == 3)
                    {
                        tempAngle = 5;
                    }
                    currentFrame = 0;
                    while (currentFrame < this.frame)
                    {
                        apd1 = this.getAvatarPartData(tempAngle, currentFrame);
                        if (apd1 != null)
                        {
                            apdXml = new XML("<p a=\"" + index + "\" f=\"" + currentFrame + "\" sx=\"0\" sy=\"0\" w=\"" + apd1.width + "\" h=\"" + apd1.height + "\" tx=\"" + (apd1.width - apd1.tx) + "\" ty=\"" + apd1.ty + "\" ox=\"0\" oy=\"0\"/>");
                            apd = new AvatarPartData(apdXml);
                            this._apd_dict[apd.angle + "_" + apd.frame] = apd;
							widthMax = Math.max(apd1.width,widthMax);
							heightMax = Math.max(apd1.height,heightMax);
                        }
                        currentFrame++;
                    }
                    index++;
                }
            }
            return;
        }

		
		/**
		 * 获取某个方向的某一帧的图片数据
		 * @param $angle
		 * @param $frame
		 * @return 
		 * 
		 */		
        public function getAvatarPartData($angle:int, $frame:int) : AvatarPartData
        {
            var key:String = $angle + "_" + $frame;
            if (this._apd_dict != null && this._apd_dict.hasOwnProperty(key))
            {
                return this._apd_dict[key] as AvatarPartData;
            }
            return null;
        }

    }
}
