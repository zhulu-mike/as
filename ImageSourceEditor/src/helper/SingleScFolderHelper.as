package helper
{
	import com.leman.data.ActionType;
	
	import flash.filesystem.File;
	
	import mx.controls.Alert;

	public class SingleScFolderHelper
	{
		public function SingleScFolderHelper()
		{
		}
		
		public static function analyse(file:File):Array
		{
			if(file == null || file.isDirectory == false)
			{
				Alert.show('导入的文件夹不是一个sc动作文件夹');
				return [];
			}
			
			var infos:Array = [];
			var fileList:Array = file.getDirectoryListing();
			var num:int = fileList.length;
			var tempInfo:Object;
			for(var i:int = 0; i < num; i++)
			{
				if(isFileAvailable(fileList[i].name) == true)
				{
					tempInfo = parse(fileList[i]);
					infos.push(tempInfo);
				}
			}
			
			return infos;
		}
		
		/**
		 *	验证该 文件夹名是否是动作名
		 */		
		private static function isFileAvailable(fileName:String):Boolean
		{
			switch(fileName)
			{
				case ActionType.DEATH : 
				case ActionType.WALK : 
				case ActionType.SKILL : 
				case ActionType.ATTACK : 
				case ActionType.INJURED :
				case ActionType.SIT : 
				case ActionType.SOUL_SKILL : //战魂技
				case ActionType.STAND : 
					return true;
				default:
					return false;
					break;
			}
			return false;
		}
		
		
		
		/**
		 *	读取单个动作的文件夹，分析其中的动作帧数 
		 * @param file
		 * @return  {action:ActionType, frames:int};
		 * 
		 */		
		private static function readSingleActionFolders(file:File):void
		{
			if (file.isDirectory == true)
			{
				switch(file.name)
				{
					case ActionType.DEATH : 
					case ActionType.WALK : 
					case ActionType.SKILL : 
					case ActionType.ATTACK : 
					case ActionType.INJURED :
					case ActionType.SIT : 
					case ActionType.SOUL_SKILL : //战魂技
					case ActionType.STAND : 
						parse(file);
						break;
					default:
						break;
				}
			}
		}
	
		
		/**
		 *	读取单个动作的文件夹，分析其中的动作帧数 
		 * @param file
		 * @return  {action:ActionType, frames:int};
		 * 
		 */
		private static function parse(file:File):Object
		{
			var arr:Array = [0,0,0,0,0,0,0,0];		//保存七个方向上帧数
			var files:Array = file.getDirectoryListing();
			var num:int = files.length;
			var tempFile:File;
			var direction:int;
			for(var i:int = 0; i < num; i++)
			{
				tempFile = files[i] as File;
				if(tempFile.extension.toLowerCase() == 'png')
				{
					direction = int(tempFile.name.charAt(0));
					arr[direction]++;
				}
			}
			
			num = arr.length;
			for(i = 0; i < num; i++)
			{
				if(arr[i] != 0)
				{
					return {action:file.name, frames:arr[i]};
				}
			}
			return {action:file.name, frames:0};
		}
	}
}