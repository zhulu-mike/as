package tools.observer
{

    public class ObserverThread extends Object
    {
        private var _observerMap:Object;

        public function ObserverThread()
        {
            this._observerMap = {};
            return;
        }

        public function clear() : void
        {
            this._observerMap = {};
            return;
        }

        public function registerObserver($name:*, $observer:Observer) : void
        {
            if (this._observerMap[$name] != null)
            {
				var index:int = 0;
				var _arr:Array = this._observerMap[$name] as Array;
				index = 0;
				while (index < _arr.length)
				{
					if ((_arr[index] as Observer).compareNotifyContext($observer.notifyContext))
					{
						return ;
					}
					index++;
				}
				_arr.push($observer);
            }
            else
            {
                this._observerMap[$name] = [$observer];
            }
            return;
        }

        public function removeObserver($name:*, $context:*) : void
        {
            var index:int = 0;
            var _arr:Array = this._observerMap[$name] as Array;
            index = 0;
            while (index < _arr.length)
            {
                
                if ((_arr[index] as Observer).compareNotifyContext($context))
                {
                    _arr.splice(index, 1);
                    break;
                }
                index++;
            }
            if (_arr.length == 0)
            {
                delete this._observerMap[$name];
            }
            return;
        }

        public function notifyObservers($notification:Notification) : void
        {
            var _temp:Array = null;
            var _observer:Observer = null;
            var index:int = 0;
            var observerArr:Array = this._observerMap[$notification.name] as Array;
            if (observerArr != null)
            {
                _temp = new Array();
                index = 0;
                while (index < observerArr.length)
                {
                    
                    _observer = observerArr[index];
                    _temp.push(_observer);
                    index++;
                }
                index = 0;
                while (index < _temp.length)
                {
                    
                    _observer = _temp[index] as Observer;
                    _observer.notifyObserver($notification);
                    index++;
                }
            }
            return;
        }

    }
}
