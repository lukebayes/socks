package socks {

    import flash.utils.Timer;
    import flash.events.TimerEvent;
	
	public class ConnectionListener {

        public static const DEFAULT_POLLING_INTERVAL:int = 50;

        private var bucketName:String;
        private var connected:Boolean;
        private var delegate:*;
        private var interval:int;
        private var timer:Timer;
        private var wrapper:SharedObjectWrapper;

        public function ConnectionListener(bucketName:String, interval:int=DEFAULT_POLLING_INTERVAL) {
            this.bucketName = bucketName;
            this.interval = interval;
            timer = new Timer(interval);
        }

        public function connect(delegate:*):void {
            if(delegate == null) {
                throw new Error("ConnectionListener.connect requires a non-null delegate");
            }
            if(connected) {
                throw new Error("ConnectionListener.connect called twice without first closing the connection");
            }

            connected = true;

            this.delegate = delegate;
            wrapper = new SharedObjectWrapper(bucketName);
            beginPolling();
        }

        /**
         * Close the connection (stop polling for requests)
         */
        public function close():void {
            timer.stop();
            timer.removeEventListener(TimerEvent.TIMER, timerHandler);
            delegate = null;
            connected = false;
        }

        private function beginPolling():void {
            getRequests();
            timer.addEventListener(TimerEvent.TIMER, timerHandler);
            timer.start();
        }

        private function timerHandler(event:TimerEvent):void {
            getRequests();
        }

        private function getRequests():void {
            handleRequests( wrapper.readAndClear('requests') );
        }

        private function handleRequests(requests:Array):void {
            if(requests == null) return;
            var len:int = requests.length;
            for(var i:int; i < len; i++) {
                handleRequest(requests[i]);
            }
        }

        private function handleRequest(request:Object):void {
            validateRequest(request);
            delegate[request.name].apply(delegate, request.arguments);
        }

        private function validateRequest(request:Object):void {
            if(delegate == null) {
                trace("[ERROR] socks.ConnectionListener received request but has a null delegate!");
            }
            if(request.name == null) {
                trace("[ERROR] socks.ConnectionListener received a request with a null name");
            }
            if(delegate[request.name] == null) {
                trace("[ERROR] socks.ConnectionListener received a request with: " + request.name + ", but the provided delegate (" + delegate + ") does not have that method.");
            }
            if(!(delegate[request.name] is Function)) {
                trace("[ERROR] socks.ConnectionListener received a request with: " + request.name + ", but the provided delegate (" + delegate + ") has a property instead of a method with that name.");
            }
        }
	}
}
