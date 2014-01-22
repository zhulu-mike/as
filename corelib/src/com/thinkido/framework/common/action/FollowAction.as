package com.thinkido.framework.common.action
{
	import com.thinkido.framework.common.timer.vo.TimerData;
	import com.thinkido.framework.engine.SceneCharacter;
	import com.thinkido.framework.engine.config.SceneConfig;
	import com.thinkido.framework.manager.TimerManager;
	import com.thinkido.framework.utils.MathUtil;
	
	import flash.geom.Point;

	/**
	 * 跟随行为
	 * @author wangjianglin
	 * 
	 */	
	public class FollowAction implements IAction
	{
		
		private var _follower:SceneCharacter;
		private var _target:SceneCharacter;
		private var _dis:int;
		private var timer:TimerData = TimerManager.createTimer(100,100000000,follow);
		
		/**
		 * 
		 * @param follower 跟随者
		 * @param target 跟随的目标,比如A跟着B，那么这就是B，follower就是A
		 * @param dis 跟随的距离 默认1格
		 * 
		 */		
		public function FollowAction(follower:SceneCharacter, target:SceneCharacter, dis:int = 1)
		{
			_follower = follower;
			_target = target;
			_dis = dis;
		}
		
		/**
		 * 开启执行行为
		 * 
		 */		
		public function begin():void
		{
			timer.timer.reset();
			timer.timer.start();
		}
		
		
		/**
		 * 结束行为
		 * 
		 */		
		public function end():void
		{
			timer.timer.stop();
		}
		
		private function follow():void
		{
			if (_follower.id <= 0 || _follower.scene == null || _target.id <= 0 || _target.scene == null)
			{
				dispose();
				return;
			}
			var dis:Number = (_target.pixel_x - _follower.pixel_x) * (_target.pixel_x - _follower.pixel_x) + (_target.pixel_y - _follower.pixel_y) * (_target.pixel_y - _follower.pixel_y);
			if (dis <= _dis*SceneConfig.TILE_WIDTH*_dis*SceneConfig.TILE_WIDTH)
			{
				_follower.stopMove();
				return;
			}
			var data:Array = _target.moveData.walk_pathArr;
			if (data == null)
				data = [[_target.tile_x, _target.tile_y]];
			var len:int = data.length - 1;
			if (data.length <= 0)
				return;
			var to:Point = new Point(data[len][0], data[len][1]);
			var data2:Array = _follower.moveData.walk_pathArr;
			data2 = data2 == null ?  [] : data2;
			var len2:int = data2.length - 1;
			if (data2.length <= 0 || data2[len2][0] != to.x && data2[len2][1] != to.y) 
			{
				if (MathUtil.getDistance(_target.tile_x, _target.tile_y, to.x, to.y) < MathUtil.getDistance(_follower.tile_x, _follower.tile_y, to.x, to.y))
				{
					_follower.walk(to, _target.getSpeed(),  _dis*SceneConfig.TILE_WIDTH);
				}else{
					_follower.walk(new Point(_target.tile_x, _target.tile_y), _target.getSpeed(),  _dis*SceneConfig.TILE_WIDTH);
				}
			}
		}
		
		public function dispose():void
		{
			if (timer){
				end();
				TimerManager.deleteTimer(timer);
				timer = null;
			}
			_follower = null;
			_target = null;
		}
		
		public function get target():SceneCharacter
		{
			return _target;
		}
	}
}