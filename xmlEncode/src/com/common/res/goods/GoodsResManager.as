package game.common.res.goods
{

    public class GoodsResManager extends Object
    {
        private static var goodsResContainer:Object = new Object();

        public function GoodsResManager()
        {
            return;
        }

        public static function parseRes(xmlString:String) : void
        {
            var gr:GoodsRes = null;
            var item:XML = null;
            var _xml:XML = XML(xmlString);
            if (!_xml)
            {
                return;
            }
            for each (item in _xml.goodmodel)
            {
                
                gr = new GoodsRes();
                gr.id_kind = item.@id;
                gr.id_ico = item.@ico;
                gr.id_ico_big = item.@big_ico;
                gr.id_m = item.@avatarId;
                gr.id_bag = item.@drop_effect_id;
                gr.id_sound_goods_down = item.@sound;
                gr.id_sound_goods_pickUp = item.@sound;
                gr.id_sound_goods_use = item.@use_sound;
                gr.coolingtime = item.@coolingtime;
                gr.public_type = item.@common_cool_type;
                gr.public_time = item.@common_cool_time;
                gr.name = String(item.name).split("_")[0];
                gr.desc = item.desc;
                gr.use_desc = item.use_desc;
                gr.popsinger = item.@popsinger;
                gr.sound = item.@sound;
                gr.use_sound = item.@use_sound;
                gr.use_image = item.@use_image;
                gr.kind = item.@kind;
                gr.discard = item.@discard;
                gr.log = item.@log;
                gr.repeat = item.@repeat;
                gr.buy_price = item.@buyPrice;
                gr.sale_price = item.@salePrice;
                gr.attack = item.@attack;
                gr.attack_min = item.@attack_min;
                gr.attack_max = item.@attack_max;
                gr.crt = item.@crt;
                gr.dodge = item.@dodge;
                gr.atk_coldtime = item.@atkColdtime;
                gr.move_speed = item.@moveSpeed;
                gr.hp = item.@hp;
                gr.mp = item.@mp;
                gr.sp = item.@sp;
                gr.grade = item.@grade;
                gr.binding = item.@binding;
                gr.born_probability = item.@bornProbability;
                gr.bron_max = item.@bronMax;
                gr.defence_probability = item.@defenceProbability;
                gr.defence_min = item.@defenceMin;
                gr.defence_max = item.@defenceMax;
                gr.crt_probability = item.@crtProbability;
                gr.crt_min = item.@crtMin;
                gr.crt_max = item.@crtMax;
                gr.dodge_probability = item.@dodgeProbability;
                gr.dodge_min = item.@dodgeMin;
                gr.dodge_max = item.@dodgeMax;
                gr.atk_coldtime_probability = item.@atkColdtimeProbability;
                gr.atk_coldtime_min = item.@atkColdtimeMin;
                gr.atk_coldtime_max = item.@atkColdtimeMax;
                gr.move_speed_probability = item.@moveSpeedProbability;
                gr.move_speed_min = item.@moveSpeedMin;
                gr.hp_probability = item.@hpProbability;
                gr.move_speed_max = item.@moveSpeedMax;
                gr.hp_min = item.@hpMin;
                gr.hp_max = item.@hpMax;
                gr.mp_probability = item.@mpProbability;
                gr.mp_min = item.@mpMin;
                gr.mp_max = item.@mpMax;
                gr.sp_probability = item.@spProbability;
                gr.sp_min = item.@spMin;
                gr.sp_max = item.@spMax;
                gr.position = item.@position;
                gr.insert_limited = item.@insert_limited;
                gr.shape = item.@shape;
                gr.durability = item.@durability;
                gr.repair_money = item.@repairMoney;
                gr.limit_grade = item.@limitGrade;
                gr.attack_addpoint = item.@attackAddpoint;
                gr.flop_probability = item.@flopProbability;
                gr.light_addpoint = item.@lightAddpoint;
                gr.strong_addpoint = item.@strongAddpoint;
                gr.gems_type = item.@gemeType;
                gr.gems_value = item.@gemsValue;
                gr.skill = item.@skill;
                gr.task = item.@task;
                gr.drug_type = item.@drugType;
                gr.drug_buff_time = item.@drug_buff_time;
                gr.drug_value = item.@drug_value;
                gr.prestige_limit = item.@prestige_limit;
                gr.sendAnnouncement = item.@sendAnnouncement;
                gr.born_ico = item.@born_ico;
                gr.born_color_grade = item.@born_color_grade;
                gr.is_sale = item.@is_sale;
                gr.sale_is_ui = item.@sale_is_ui;
                gr.f_discard_is_ui = item.@discard_is_ui;
                goodsResContainer[gr.id_kind] = gr;
            }
            return;
        }

        public static function getGoodsRes(param1:int) : GoodsRes
        {
            return goodsResContainer[param1];
        }

    }
}
