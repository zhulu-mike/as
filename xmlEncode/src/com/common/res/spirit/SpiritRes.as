package game.common.res.spirit
{
	public class SpiritRes
	{
		/**
		 * 与服务端对应id 
		 */		
		public var sid:int =0;
		/**
		 *配置id 
		 */		
		public var id:int ;
		/**
		 * 名称
		 */
		public var name:String ;
		/**
		 *颜色 
		 */
		public var color:uint ;
		/**
		 *等级 
		 */
		public var lv:int ;
		/**
		 * 所属灵兽 
		 */
		public var type:int ;
		/**
		 * 所需兽元 
		 */
		public var cost:int ;
		/**
		 * 分解兽元 
		 */
		public var sell:int ;
		/**
		 * 攻击 
		 */
		public var att:int ;
		/**
		 * 防御 
		 */
		public var def:int ;
		/**
		 * 暴击 
		 */
		public var cru:int ;
		/**
		 * 抗暴
		 */
		public var dcru:int ;
		/**
		 * 必杀等级
		 */
		public var killLv:int ;
		/**
		 *生命 
		 */
		public var blood:int ;
		/**
		 * 图标 
		 */
		public var img:int ;
		/**
		 * 描述
		 */
		public var des:String ;
		
		public function SpiritRes()
		{
		}
	}
}