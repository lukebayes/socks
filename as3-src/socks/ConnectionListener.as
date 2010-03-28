package socks {

    import flash.display.Sprite;
    import flash.events.Event;
	
	public class ConnectionListener {

        private var bucketName:String;
        private var connected:Boolean;
        private var delegate:*;
        private var frameSource:Sprite;
        private var path:String;
        private var requests:Object;
        private var secure:Boolean;
        private var wrapper:SharedObjectWrapper;

        public function ConnectionListener(bucketName:String, path:String=null, secure:Boolean=false) {
            this.bucketName = bucketName;
            this.path       = path;
            this.secure     = secure;
            frameSource     = new Sprite();
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
            requests = {};
            wrapper = new SharedObjectWrapper(bucketName, path, secure);
            beginPolling();
        }

        /**
         * Close the connection (stop polling for requests)
         */
        public function close():void {
            clear();
            frameSource.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
            requests  = {};
            delegate  = null;
            connected = false;
        }

        public function clear():void {
            if(connected) {
                wrapper.clear();
            }
        }

        private function beginPolling():void {
            getRequests();
            frameSource.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
        }

        private function enterFrameHandler(event:Event):void {
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
            if(validateRequest(request)) {
                delegate[request.name].apply(delegate, request.arguments);
            }
        }

        private function validateRequest(request:Object):Boolean {
            if(delegate == null) {
                trace("[ERROR] socks.ConnectionListener received request but has a null delegate!");
                return false;
            }
            if(request == null) {
                trace("[ERROR] socks.ConnectionListener found an empty request object");
                return false;
            }
            if(request.name == null) {
                trace("[ERROR] socks.ConnectionListener received a request with a null name");
                return false;
            }
            if(delegate[request.name] == null) {
                trace("[ERROR] socks.ConnectionListener received a request with: " + request.name + ", but the provided delegate (" + delegate + ") does not have that method.");
                return false;
            }
            if(!(delegate[request.name] is Function)) {
                trace("[ERROR] socks.ConnectionListener received a request with: " + request.name + ", but the provided delegate (" + delegate + ") has a property instead of a method with that name.");
                return false;
            }
            if(requests[request.id]) {
                // request has already been handled...
                return false;
            }
            else {
                // store the id to avoid running this request again...
                requests[request.id] = true;
            }

            return true;
        }
	}
}
