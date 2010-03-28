package socks {

    import flash.net.SharedObject;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
	
	public class ConnectionListener {

        public static const DEFAULT_POLLING_INTERVAL:int = 50;

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
            trace(">> get requests");
        }
	}
}
