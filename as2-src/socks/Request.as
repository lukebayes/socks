
class socks.Request {

    public static var incr:Number = 0;

    public var name:String;
    public var arguments:Array;
    public var id:String;
    
    public function Request(name:String, args:Array) {
        this.name = name;
        this.arguments = args || [];
    } 

    private function generateId():String {
        var now:Date = new Date();
        var ts:Number = now.valueOf();
        return (ts + '-' + (incr++));
    }
}

