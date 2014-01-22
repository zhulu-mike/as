package lm.mui.display.toolTip
{
    public class NormalTooltip extends BackgroundTooltip
    {
//        private var itemTooltip:ItemTooltip;
        private var labelToolTip:LabelToolTip;
//        private var equipmentTooltip:EquipmentTooltip;
//        private var petEquipTooltop:PetEquipTooltip;
//        private var skillTooltip:SkillToolTip;
//        private var separateTooltip:SeparateTooltip;
//        private var bournToolTip:BournTooltip;
//        private var repairCostTooltip:RepairCostTooltip;
//        private var wxSkillToolTip:WXSkillToolTip;
//        private var guildSkillToolTip:GuildSkillToolTip;
//        private var shortcutItemLabelToolTip:ShortItemToolTip;
//        private var mountsToolTip:MountsToolTip;
//        private var buffToolTip:BuffToolTip;
        public static const ToolTipRenderType_Text:String = "纯文本类型";
        public static const ToolTipRenderType_Equipment:String = "装备类型";
        public static const ToolTipRenderType_PetEquip:String = "宠物装备";
        public static const ToolTipRenderType_Item:String = "非装备物品类型";
        public static const ToolTipRenderType_Skill:String = "技能";
        public static const ToolTipRenderType_BUFF:String = "BUFF";
        public static const ToolTipRenderType_Separate:String = "分隔类型";
        public static const ToolTipRenderType_Bourn:String = "境界类型";
        public static const ToolTipRenderType_RepairCost:String = "全部修理费用";
        public static const ToolTipRenderType_WXSkill:String = "五行技能";
        public static const ToolTipRenderType_GuildSkill:String = "仙盟技能";
        public static const ToolTipRenderType_ShortcutItem:String = "快捷栏技能纯文本类型";
        public static const ToolTipRenderType_Mounts:String = "坐骑类型";
		/***/
		public static const ToolTipRenderType_AnimalStar:String = "星宿";
		/**输灵按钮*/
		public static const ToolTipRenderType_ShuLingBtn:String = "输灵按钮";
		/**一般按钮*/
		public static const ToolTipRenderType_generalBtn:String = "按钮";


        public function NormalTooltip()
        {
            return;
        }

        override public function set data(param1:Object) : void
        {
            var tipInfo:ToolTipInfo = null;
            if (contentContainer && this.contains(contentContainer))
            {
                this.removeChild(contentContainer);
            }
            if (param1 is String)
            {
                if (param1 != "")
                {
                    contentContainer = new LabelToolTip(param1 as String);
                    this.addChild(contentContainer);
                    super.data = param1;
                }
            }
            else if (param1 is ToolTipInfo)
            {
				tipInfo = param1 as ToolTipInfo;
                switch(param1.type)
                {
                    case ToolTipRenderType_Text:
                    {
                        if (!this.labelToolTip)
                        {
                            this.labelToolTip = new LabelToolTip(tipInfo.tooltipData as String);
                        }
                        else
                        {
                            this.labelToolTip.data = tipInfo.tooltipData as String;
                        }
                        contentContainer = this.labelToolTip;
                        break;
                    }
                    case ToolTipRenderType_Equipment:
                    {
						/* _loc_3 = getTimer();
                        if (!this.equipmentTooltip)
                        {
                            this.equipmentTooltip = new EquipmentTooltip(_loc_2.tooltipData);
                        }
                        else
                        {
                            this.equipmentTooltip.data = _loc_2.tooltipData;
                        }
                        contentContainer = this.equipmentTooltip;
                        Log.debug(String(getTimer() - _loc_3));*/
                        break;
                    }
                    case ToolTipRenderType_PetEquip:
                    {
                        /*if (!this.petEquipTooltop)
                        {
                            this.petEquipTooltop = new PetEquipTooltip(_loc_2.tooltipData);
                        }
                        else
                        {
                            this.petEquipTooltop.data = _loc_2.tooltipData;
                        }
                        contentContainer = this.petEquipTooltop;*/
                        break;
                    }
                    case ToolTipRenderType_Item:
                    {
                       /* if (!this.itemTooltip)
                        {
                            this.itemTooltip = new ItemTooltip(_loc_2.tooltipData);
                        }
                        else
                        {
                            this.itemTooltip.data = _loc_2.tooltipData;
                        }
                        contentContainer = this.itemTooltip;*/
                        break;
                    }
                    case ToolTipRenderType_Skill:
                    {
                        /*if (!this.skillTooltip)
                        {
                            this.skillTooltip = new SkillToolTip(_loc_2.tooltipData);
                        }
                        else
                        {
                            this.skillTooltip.data = _loc_2.tooltipData;
                        }
                        contentContainer = this.skillTooltip;*/
                        break;
                    }
                    case ToolTipRenderType_WXSkill:
                    {
                        /*if (!this.wxSkillToolTip)
                        {
                            this.wxSkillToolTip = new WXSkillToolTip(_loc_2.tooltipData);
                        }
                        else
                        {
                            this.wxSkillToolTip.data = _loc_2.tooltipData;
                        }
                        contentContainer = this.wxSkillToolTip;*/
                        break;
                    }
                    case ToolTipRenderType_GuildSkill:
                    {
                       /* if (!this.guildSkillToolTip)
                        {
                            this.guildSkillToolTip = new GuildSkillToolTip(_loc_2.tooltipData);
                        }
                        else
                        {
                            this.guildSkillToolTip.data = _loc_2.tooltipData;
                        }
                        contentContainer = this.guildSkillToolTip;*/
                        break;
                    }
                    case ToolTipRenderType_ShortcutItem:
                    {
                       /* if (!this.shortcutItemLabelToolTip)
                        {
                            this.shortcutItemLabelToolTip = new ShortItemToolTip(_loc_2.tooltipData);
                        }
                        else
                        {
                            this.shortcutItemLabelToolTip.data = _loc_2.tooltipData;
                        }
                        contentContainer = this.shortcutItemLabelToolTip;*/
                        break;
                    }
                    case ToolTipRenderType_Mounts:
                    {
                      /*  if (!this.mountsToolTip)
                        {
                            this.mountsToolTip = new MountsToolTip(_loc_2.tooltipData);
                        }
                        else
                        {
                            this.mountsToolTip.data = _loc_2.tooltipData;
                        }
                        contentContainer = this.mountsToolTip;*/
                        break;
                    }
                    case ToolTipRenderType_BUFF:
                    {
                        /*if (!this.buffToolTip)
                        {
                            this.buffToolTip = new BuffToolTip();
                        }
                        this.buffToolTip.data = _loc_2.tooltipData;
                        contentContainer = this.buffToolTip;*/
                        break;
                    }
                    case ToolTipRenderType_Separate:
                    {
                       /* if (!this.separateTooltip)
                        {
                            this.separateTooltip = new SeparateTooltip();
                        }
                        this.separateTooltip.data = _loc_2.tooltipData;
                        contentContainer = this.separateTooltip;*/
                        break;
                    }
                    case ToolTipRenderType_Bourn:
                    {
                       /* if (!this.bournToolTip)
                        {
                            this.bournToolTip = new BournTooltip();
                        }
                        this.bournToolTip.data = _loc_2.tooltipData;
                        contentContainer = this.bournToolTip;*/
                        break;
                    }
                    case ToolTipRenderType_RepairCost:
                    {
                       /* if (!this.repairCostTooltip)
                        {
                            this.repairCostTooltip = new RepairCostTooltip();
                        }
                        this.repairCostTooltip.data = _loc_2.tooltipData;
                        contentContainer = this.repairCostTooltip;*/
                        break;
                    }
					case ToolTipRenderType_ShuLingBtn:
					{
//						var str:String = _loc_2.tooltipData.type == 1 ? Language.getInstance().getKey("ptsltip") : Language.getInstance().getKey("gjsltip");
//						str = str.replace("XX", 1111);
//						if (!this.labelToolTip)
//						{
//							this.labelToolTip = new LabelToolTip(str);
//						}
//						else
//						{
//							this.labelToolTip.data = str;
//						}
						contentContainer = this.labelToolTip;
						break;
					}
					case ToolTipRenderType_generalBtn:
					{
						var str:String = tipInfo.tooltipData.text;
						if (!this.labelToolTip)
						{
							this.labelToolTip = new LabelToolTip(str);
						}
						else
						{
							this.labelToolTip.data = str;
						}
						contentContainer = this.labelToolTip;
						break;
					}
                    default:
                    {
                       /* if (!this.labelToolTip)
                        {
                            this.labelToolTip = new LabelToolTip(_loc_2.tooltipData);
                        }
                        else
                        {
                            this.labelToolTip.data = _loc_2.tooltipData;
                        }
                        contentContainer = this.labelToolTip;*/
                        break;
                        break;
                    }
                }
                this.addChild(contentContainer);
                this.updatePos();
                this.cacheAsBitmap = true;
            }
            return;
        }

        private function updatePos() : void
        {
            this.updatePosLater();
            return;
        }

        private function updatePosLater() : void
        {
            _width = contentContainer.width + paddingLeft + paddingRight;
            _height = contentContainer.height + paddingTop + paddingBottom;
            contentContainer.y = paddingTop;
            contentContainer.x = paddingLeft;
            super.updateSize(_width, _height);
            return;
        }

        public function dispose() : void
        {
            if (this.contains(contentContainer))
            {
                this.removeChild(contentContainer);
            }
            return;
        }

        override public function get height() : Number
        {
            return scaleBg.height;
        }

    }
}
