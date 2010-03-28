
class socks.Request {

    public var name:String;
    public var arguments:Array;
    
    public function Request(name:String, args:Array) {
        this.name = name;
        this.arguments = args || [];
    } 
}

