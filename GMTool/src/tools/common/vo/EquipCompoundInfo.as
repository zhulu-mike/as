package tools.common.vo
{
	public class EquipCompoundInfo
	{
		public function EquipCompoundInfo()
		{
		}
		
		/**
		 * 可合成的装备
		 */		
		public var id:int = 0;
		
		/**
		 * 需要的材料
		 */		
		public var cailiao:Array;
		
		/**
		 * 需要的装备
		 */		
		public var needequip:int = 0;
		
		/**需要的合成卷轴*/
		public var scroll:int = 0;
	}
}