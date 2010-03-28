
import socks.SharedObjectWrapper;
import socks.Request;

class socks.ConnectionSender {

    private var bucketName:String;
    private var path:String;
    private var secure:Boolean;
    private var wrapper:SharedObjectWrapper;
    
    public function ConnectionSender(bucketName:String, path:String, secure:Boolean) {
        this.bucketName = bucketName;
        this.path       = path;
        this.secure     = secure;
        wrapper = new SharedObjectWrapper(bucketName, path, secure);
    } 

    public function clear():Void {
        wrapper.clear();
    }

    // Expects send(methodName:String, ...args:Array):void
    public function send():Void {
        var methodName:String = String(arguments.shift());
        trace(">>> sending request on: " + bucketName + " with method: " + methodName + " and args: " + arguments);

        var requests:Object = wrapper.read('requests') || [];
        var request:Request = new Request(methodName, arguments);
        requests.push(request);
        wrapper.write('requests', requests);
    }
}

