package socks {

    import flash.net.SharedObject;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
	
	public class ConnectionListener {

        public static const DEFAULT_POLLING_INTERVAL:int = 50;

        public var delegate:*;

        private var bucketName:String;
        private var wrapper:SharedObjectWrapper;

        private var interval:int;
        private var timer:Timer;

        public function ConnectionListener(bucketName:String, interval:int=DEFAULT_POLLING_INTERVAL) {
            this.bucketName = bucketName;
            this.interval = interval;
            timer = new Timer(interval);
        }

        public function connect():void {
            wrapper = new SharedObjectWrapper(bucketName);
            beginPolling();
        }

        /**
         * Close the connection (stop polling for requests)
         */
        public function close():void {
            timer.stop();
        }

        private function beginPolling():void {
            getRequests();

            timer.addEventListener(TimerEvent.TIMER, timerHandler);
            timer.start();
        }

        private function timerHandler(event:TimerEvent):void {
            trace(">> timer handler with: " + event.target);
            getRequests();
        }

        private function getRequests():void {
            handleRequests( wrapper.readAndClear('requests') );
        }

        private function handleRequests(requests:Array):void {
            if(requests == null) return;
            trace(">> handling requests with: " + requests.length);
            var len:int = requests.length;
            for(var i:int; i < len; i++) {
                handleRequest(requests[i]);
            }
        }

        private function handleRequest(request:Request):void {
            trace(">> handle request; " + request.name);
            validateRequest(request);
        }

        private function validateRequest(request:Request):void {
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
