package lm.mui.display.toolTip
{
	import flash.display.Sprite;
	
	import lm.mui.manager.IToolTip;

    public class Tooltip extends Sprite implements IToolTip
    {
        public var tooTip1:NormalTooltip;
        public var tooTip2:NormalTooltip;
        public static const ToolTipRenderType_Text:String = NormalTooltip.ToolTipRenderType_Text;
        public static const ToolTipRenderType_Equipment:String = NormalTooltip.ToolTipRenderType_Equipment;
        public static const ToolTipRenderType_Item:String = NormalTooltip.ToolTipRenderType_Item;
        public static const ToolTipRenderType_Skill:String = NormalTooltip.ToolTipRenderType_Skill;
        public static const ToolTipRenderType_ShortcutItem:String = NormalTooltip.ToolTipRenderType_ShortcutItem;
        public static const ToolTipRenderType_Mounts:String = NormalTooltip.ToolTipRenderType_Mounts;
        public static const ToolTipRenderType_WXSkill:String = NormalTooltip.ToolTipRenderType_WXSkill;
        public static const ToolTipRenderType_GuildSkill:String = NormalTooltip.ToolTipRenderType_GuildSkill;
		public static const ToolTipRenderType_AnimalStar:String = NormalTooltip.ToolTipRenderType_AnimalStar;
		public static const ToolTipRenderType_ShuLingBtn:String = NormalTooltip.ToolTipRenderType_ShuLingBtn;
		public static const ToolTipRenderType_generalBtn:String = NormalTooltip.ToolTipRenderType_generalBtn;
		
        public function Tooltip()
        {
            this.init();
            return;
        }

        private function init() : void
        {
            this.tooTip1 = new NormalTooltip();
            this.tooTip2 = new NormalTooltip();
            return;
        }

        public function set data(param1:Object) : void
        {
            var obj_1:Object;
            var obj2:Object;
            var tipInfo:ToolTipInfo = null;
//            var _loc_5:EquipmentToolTipData = null;
//            var _loc_6:ItemData = null;
//            var _loc_7:EquipmentToolTipData = null;
            this.clear();
            if (param1 is ToolTipInfo && param1.type == NormalTooltip.ToolTipRenderType_Equipment)
            {
				tipInfo = param1 as ToolTipInfo;
//                _loc_5 = _loc_4.tooltipData as EquipmentToolTipData;
                /*if (_loc_5.isContrast)
                {
                    _loc_6 = _loc_5.getSameDressingOn();
                    if (_loc_6)
                    {
                        _loc_7 = new EquipmentToolTipData(_loc_6, _loc_5.equipmentsOnPlayer);
                        _loc_7.isContrast = false;
                        _loc_7.isShowEquipped = true;
                        _loc_8 = new ToolTipInfo(NormalTooltip.ToolTipRenderType_Equipment, _loc_7);
                        _loc_2 = _loc_8;
                        _loc_3 = param1;
                    }
                    else
                    {
                        _loc_5.isContrast = false;
                        _loc_2 = param1;
                    }
                }*/
//                else
                {
					obj_1 = param1;
                }
            }
            else
            {
				obj_1 = param1;
            }
            if (obj_1)
            {
                this.tooTip1.data = obj_1;
                this.addChild(this.tooTip1);
            }
            if (obj2)
            {
                this.tooTip2.data = obj2;
                this.addChild(this.tooTip2);
                this.tooTip1.x = this.tooTip2.x + this.tooTip2.width + 5;
                this.tooTip1.y = this.tooTip2.y;
            }
            else
            {
                this.tooTip1.x = 0;
                this.tooTip1.y = 0;
            }
            return;
        }

        private function clear() : void
        {
            if (this.tooTip1.parent)
            {
                this.tooTip1.parent.removeChild(this.tooTip1);
            }
            if (this.tooTip2.parent)
            {
                this.tooTip2.parent.removeChild(this.tooTip2);
            }
            return;
        }

        private function updatePos() : void
        {
            return;
        }

        public function dispose() : void
        {
            this.tooTip1.dispose();
            this.tooTip2.dispose();
            return;
        }

        override public function get width() : Number
        {
            var tempWidth:Number = 0;
            if (this.tooTip1 && this.tooTip1.parent)
            {
				tempWidth = tempWidth + this.tooTip1.width;
            }
            if (this.tooTip2 && this.tooTip2.parent)
            {
				tempWidth = tempWidth + this.tooTip2.width;
            }
            if (tempWidth == 0)
            {
				tempWidth = super.width;
            }
            return tempWidth;
        }

        override public function get height() : Number
        {
            if (this.tooTip1.parent && !this.tooTip2.parent)
            {
                return this.tooTip1.height;
            }
            if (!this.tooTip1.parent && this.tooTip2.parent)
            {
                return this.tooTip2.height;
            }
            if (this.tooTip1.parent && this.tooTip2.parent)
            {
                return Math.max(this.tooTip1.height, this.tooTip2.height);
            }
            return 0;
        }

    }
}
