package com.thinkido.framework.engine.staticdata
{
	/**
	 * AvatarPart对应的类型,用于管理切换场景时，不需要删除部分判断
	 * @author thinkido
	 */
    public class AvatarPartID extends Object
    {
		/**
		 *无表情的 
		 */
        public static const BLANK:String = "BLANK";
		/**
		 *阴影 
		 */
        public static const SHADOW:String = "SHADOW";
		/**
		 * 选中 
		 */        
		public static const SELECTED:String = "SELECTED";
		/**
		 * 鼠标 
		 */        
		public static const MOUSE:String = "MOUSE";

        public function AvatarPartID()
        {
            return;
        }
		/**
		 * 是否是有效id  
		 * @param $id
		 * @return 
		 * 有修改
		 */
        public static function isValidID($id:String) : Boolean
        {
            if ($id == null || $id == "" || isDefaultKey($id))
            {
                return false;
            }
            return true;
        }
		/**
		 * 是否默认id 
		 * @param $id
		 * @return 
		 * 
		 */
        public static function isDefaultKey($id:String) : Boolean
        {
            if ($id == BLANK || $id == SHADOW || $id == SELECTED || $id == MOUSE)
            {
                return true;
            }
            return false;
        }

    }
}
