
import laml.events.Event;
import laml.events.EventDispatcher;

//import flash.events.NetStatusEvent;
//import flash.net.SharedObjectFlushStatus;

class socks.SharedObjectWrapper extends EventDispatcher {

    public static var COMPLETE:String      = 'sharedObjectWrapperComplete';
    public static var FAILURE:String       = 'sharedObjectWrapperFailure';
    public static var FLUSH_FAILURE:String = 'SharedObject.Flush.Failed';
    public static var FLUSH_SUCCESS:String = 'SharedObject.Flush.Success';
    public static var FLUSHED:String       = 'true';
    public static var PENDING:String       = 'pending';
    public static var SUCCESS:String       = 'sharedObjectWrapperSuccess';

    private var bucketName:String;
    private var path:String;
    private var secure:Boolean;

    public function SharedObjectWrapper(bucketName:String, path:String, secure:Boolean) {
        this.bucketName = bucketName;
        this.path       = path;
        this.secure     = secure;
    }

    private function createSharedObject():SharedObject {
        try {
            var so:SharedObject = SharedObject.getLocal(bucketName, path, secure);
            var self = this;
            so.onStatus = function(infoObject:Object):Void {
                self.netStatusHandler(infoObject);
            }
            return so;
        }
        catch(e:Error) {
            trace(">> There was a problem creating the SharedObject");
        }

        return null;
    }

    private function get sharedObject():SharedObject {
        return createSharedObject();
    }

    public function write(propertyName:String, value:Object):Void {
        sharedObject.data[propertyName] = value;
        handleWriteResult(String(sharedObject.flush()));
    }

    public function readAndClear(propertyName:String):Object {
        var result:Object = sharedObject.data[propertyName];
        sharedObject.clear();
        return result;
    }

    public function read(propertyName:String):Object {
        return sharedObject.data[propertyName];
    }
    
    public function clear():Void {
        sharedObject.clear();
    }

    private function handleWriteResult(result:String):Void {
        switch(result) {
            case FLUSHED :
                dispatchEvent(new Event(SUCCESS));
                dispatchEvent(new Event(COMPLETE));
                break;
            case PENDING :
                break;
        }
    }

    private function netStatusHandler(infoObject:Object):Void {
        switch(infoObject.code) {
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

