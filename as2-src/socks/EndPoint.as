
import socks.ConnectionListener;
import socks.ConnectionSender;
import socks.SharedObjectWrapper;

class socks.EndPoint {

    private var bucketName:String;
    private var connected:Boolean;
    private var interval:Number;
    private var listener:ConnectionListener;
    private var path:String;
    private var secure:Boolean;
    private var sender:ConnectionSender;
    private var wrapper:SharedObjectWrapper;
    
    public function EndPoint(bucketName:String, path:String, secure:Boolean, interval:Number) {
        if(bucketName == null) {
            throw new Error("EndPoint cannot be created without a valid bucketName");
        }
        this.bucketName = bucketName;
        this.interval   = interval || ConnectionListener.DEFAULT_POLLING_INTERVAL;
        this.path       = path;
        this.secure     = secure;
    } 

    public function connect(delegate:Object, asClient:Boolean):Void {
        var listenerBucket:String;
        var senderBucket:String;
        // If we're the first connection at this name,
        // we're the 'server', otherwise, we're a 'client'
        // set up your keys accordingly...
        if(asClient || connectionAlreadyEstablished()) {
            trace(">> Connecting as Client");
            listenerBucket = bucketName + "-client";
            senderBucket = bucketName + "-server";
        }
        else {
            trace(">> Connecting as Server");
            listenerBucket = bucketName + "-server";
            senderBucket = bucketName + "-client";
        }

        listener = new ConnectionListener(listenerBucket, path, secure, interval);
        sender = new ConnectionSender(senderBucket, path, secure);
        listener.connect(delegate);
        connected = true;
    }

    public function send():Void {
        sender.send.apply(sender, arguments);
    }

    public function close():Void {
        if(connected) {
            clear();
            listener.close();
        }
    }

    private function writeConnectionToken():Void {
        wrapper.write('socks-connection-token', true);
    }

    private function clear():Void {
        wrapper.clear();
        listener.clear();
        sender.clear();
    }

    private function connectionAlreadyEstablished():Boolean {
        wrapper = new SharedObjectWrapper(bucketName, path, secure);
        if(wrapper.read('socks-connection-token')) {
            return true;
        }

        writeConnectionToken();
        return false;
    }
}

