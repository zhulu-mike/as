package game.common.res.anqi
{
    import game.common.GameInstance;
    import game.common.res.*;
    import game.common.res.goods.*;
    import game.common.res.lan.*;
    import game.common.res.skill.*;
    import game.manager.LanResManager;
    import game.manager.ResPathManager;
    import game.common.vo.item.*;

    public class AnQiRes extends Object
    {
        public var id:int;
        public var name:String;
        public var grade:int;
        public var xiu_grade:int;
        public var mastery:int;
        public var hidden_weaponscol:int;
        public var attackDis:int;
        public var attackTargets:int;
        public var tribLv:int;
        public var tribRealValue:int;
        public var spcialType:String;
        public var spcialDesc:String;
        public var upgradeNeedCopper:int;
        public var upgradeNeedZhenqi:int;
        public var upgradeNeedGoods:String;
        public var upgradeTribLv:int;
        public var upgradeTribRealLv:int;
        public var upgradeMinCnt:int;
        public var upgradeMaxCnt:int;
        public var method:String;
        public var skillID:int;

        public function AnQiRes()
        {
            return;
        }

        public function getUpgradeGoodInfo() : String
        {
            var _loc_3:int = 0;
            if (this.upgradeNeedGoods == "")
            {
                return "";
            }
            var _loc_1:String = "";
            var _loc_2:* = this.getUpgradeGood();
            var _loc_4:* = _loc_2.length;
            var _loc_5:* = GoodsResManager.getGoodsRes(_loc_2[_loc_3][0]);
            _loc_3 = 0;
            while (_loc_3 < _loc_4)
            {
                
                _loc_1 = _loc_1 + (_loc_5.name + _loc_2[_loc_3][1] + LanResManager.getLanCommonTextWords(Language.getKey("2508")));
                _loc_3++;
            }
            return _loc_1;
        }

        public function getUpgradeGood() : Array
        {
            var _loc_3:String = null;
            var _loc_4:Array = null;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_8:int = 0;
            var _loc_1:Array = [];
            var _loc_2:* = this.upgradeNeedGoods.split(";");
            var _loc_7:* = _loc_2.length;
            _loc_5 = 0;
            while (_loc_5 < _loc_7)
            {
                
                _loc_3 = _loc_2[_loc_5];
                _loc_4 = _loc_3.split(",");
                _loc_1.push([Number(_loc_4[0]), Number(_loc_4[1])]);
                _loc_5++;
            }
            return _loc_1;
        }

        public function hasGood() : Boolean
        {
            var _loc_2:int = 0;
            var _loc_4:Goods = null;
            var _loc_1:* = this.getUpgradeGood();
            var _loc_3:* = _loc_1.length;
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                _loc_4 = GameInstance.mainCharData.goodsInfo.getFaceGoodsByID(_loc_1[_loc_2][0], true);
                if (_loc_4.count == 0)
                {
                    return false;
                }
                _loc_2++;
            }
            return true;
        }

        public function getBigICOPath() : String
        {
            var _loc_1:* = SkillResManager.getSkillRes(this.skillID);
            return ResPathManager.getBigICOPath(_loc_1.id_ico_big);
        }

        public function getBigICOName() : String
        {
            var _loc_1:* = SkillResManager.getSkillRes(this.skillID);
            return _loc_1.id_ico_big.toString();
        }

    }
}
