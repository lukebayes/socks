package socks {

    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.NetStatusEvent;
    import flash.net.SharedObject;
    import flash.net.SharedObjectFlushStatus;

    public class SharedObjectWrapper extends EventDispatcher {

        public static const COMPLETE:String = 'sharedObjectWrapperComplete';
        public static const FAILURE:String  = 'sharedObjectWrapperFailure';
        public static const SUCCESS:String  = 'sharedObjectWrapperSuccess';

        public static const FLUSH_SUCCESS:String = 'SharedObject.Flush.Success';
        public static const FLUSH_FAILURE:String = 'SharedObject.Flush.Failed';

        private var bucketName:String;
        private var path:String;
        private var secure:Boolean;
        private var sharedObject:SharedObject;

        public function SharedObjectWrapper(bucketName:String, path:String=null, secure:Boolean=false) {
            this.bucketName = bucketName;
            this.path = path;
            this.secure = secure;
            initialize();
        }

        private function initialize():void {
            sharedObject = getLocal();
            sharedObject.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
        }

        public function write(propertyName:String, value:*):void {
            sharedObject.setProperty(propertyName, value);
            handleWriteResult(sharedObject.flush());
        }

        public function readAndClear(propertyName:String):* {
            var result:* = sharedObject.data[propertyName];
            sharedObject.data[propertyName] = null;
            sharedObject.flush();
            return result;
        }

        public function read(propertyName:String):* {
            return sharedObject.data[propertyName];
        }
        
        public function clear():void {
            sharedObject.clear();
        }

        private function getLocal():SharedObject {
            return SharedObject.getLocal(bucketName, path, secure);
        }

        private function handleWriteResult(result:String):void {
            switch(result) {
                case SharedObjectFlushStatus.FLUSHED :
                    dispatchEvent(new Event(SUCCESS));
                    dispatchEvent(new Event(COMPLETE));
                    break;
                case SharedObjectFlushStatus.PENDING :
                    break;
            }
        }

        private function netStatusHandler(event:NetStatusEvent):void {
            switch(event.info.code) {
            case FLUSH_SUCCESS :
                dispatchEvent(new Event(SUCCESS));
                break;
            case FLUSH_FAILURE :
                dispatchEvent(new Event(FAILURE));
                break;
            }
            dispatchEvent(new Event(COMPLETE));
        }
    }
}

