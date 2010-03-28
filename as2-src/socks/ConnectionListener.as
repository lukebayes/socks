
import socks.SharedObjectWrapper;

class socks.ConnectionListener {

    public static var DEFAULT_POLLING_INTERVAL:Number = 50;

    private var bucketName:String;
    private var connected:Boolean;
    private var delegate:Object;
    private var interval:Number;
    private var path:String;
    private var secure:Boolean;
    private var intervalId:Number;
    private var wrapper:SharedObjectWrapper;

    public function ConnectionListener(bucketName:String, path:String, secure:Boolean, interval:Number) {
        this.bucketName = bucketName;
        this.interval   = interval || DEFAULT_POLLING_INTERVAL;
        this.path       = path;
        this.secure     = secure;
    }

    public function connect(delegate:Object):Void {
        if(delegate == null) {
            throw new Error("ConnectionListener.connect requires a non-null delegate");
        }
        if(connected) {
            throw new Error("ConnectionListener.connect called twice without first closing the connection");
        }

        connected = true;

        this.delegate = delegate;
        wrapper = new SharedObjectWrapper(bucketName, path, secure);
        beginPolling();
    }

    /**
     * Close the connection (stop polling for requests)
     */
    public function close():Void {
        clear();
        clearInterval(intervalId);
        delegate = null;
        connected = false;
    }

    public function clear():Void {
        if(connected) {
            wrapper.clear();
        }
    }

    private function beginPolling():Void {
        getRequests();
        var self = this;
        clearInterval(intervalId);
        intervalId = setInterval(function() {
            self.getRequests();
        }, interval);
    }

    private function getRequests():Void {
        handleRequests( wrapper.readAndClear('requests') );
    }

    // The requests argument is actually returned as an Array,
    // but in ActionScript 2, we can't cast to Array, b/c 
    // calling Array(value) actually instantiates an Array
    // with a single item in it.
    private function handleRequests(requests:Object):Void {
        if(requests == null) return;
        var len:Number = requests.length;
        for(var i:Number = 0; i < len; i++) {
            handleRequest(requests[i]);
        }
    }

    private function handleRequest(request:Object):Void {
        validateRequest(request);
        trace(">> found requests to handle on: " + bucketName + " and: " + request.name);
        delegate[request.name].apply(delegate, request.arguments);
    }

    private function validateRequest(request:Object):Void {
        if(delegate == null) {
            trace("[ERROR] socks.ConnectionListener received request but has a null delegate!");
        }
        if(request.name == null) {
            trace("[ERROR] socks.ConnectionListener received a request with a null name");
        }
        if(delegate[request.name] == null) {
            trace("[ERROR] socks.ConnectionListener received a request with: " + request.name + ", but the provided delegate (" + delegate + ") does not have that method.");
        }
        if(!(delegate[request.name] instanceof Function)) {
            trace("[ERROR] socks.ConnectionListener received a request with: " + request.name + ", but the provided delegate (" + delegate + ") has a property instead of a method with that name.");
        }
    }
}

