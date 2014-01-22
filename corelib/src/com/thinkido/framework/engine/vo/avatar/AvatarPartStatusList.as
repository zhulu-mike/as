package com.thinkido.framework.engine.vo.avatar
{
	import flash.utils.Dictionary;
	
	import org.osflash.thunderbolt.Logger;

	/**
	 * 状态列表,多个动作
	 * @author thinkido
	 * 对应<s k="attack" t="120" f="2">
	    <p a="0" f="0" sx="0" sy="182" w="129" h="123" tx="86" ty="84" ox="0" oy="0"/>
	    <p a="0" f="1" sx="0" sy="0" w="65" h="182" tx="41" ty="143" ox="0" oy="0"/>
	  </s>
	  <s k="death" t="110" f="2">
	    <p a="0" f="0" sx="0" sy="0" w="144" h="114" tx="94" ty="75" ox="0" oy="0"/>
	    <p a="0" f="1" sx="93" sy="114" w="73" h="76" tx="43" ty="61" ox="0" oy="0"/>
	  </s>
	  <s k="injured" t="100" f="2">
	    <p a="0" f="0" sx="293" sy="0" w="115" h="139" tx="74" ty="108" ox="0" oy="0"/>
	    <p a="0" f="1" sx="274" sy="274" w="140" h="112" tx="70" ty="81" ox="0" oy="0"/>
	  </s>  
	 */
    public class AvatarPartStatusList extends Object
    {
        private var _apds_dict:Dictionary;

        public function AvatarPartStatusList($className:String, classXml:XML)
        {
            var item:XML = null;
            var aps:AvatarPartStatus = null;
            this._apds_dict = new Dictionary();
            for each (item in classXml.children())
            {
                aps = new AvatarPartStatus($className, item);
                this._apds_dict[aps.type] = aps;
            }
            return;
        }

        public function getAvatarPardStatus(status:String) : AvatarPartStatus
        {
            if (this._apds_dict != null && this._apds_dict.hasOwnProperty(status))
            {
                return this._apds_dict[status] as AvatarPartStatus;
            }
            return null;
        }

    }
}
