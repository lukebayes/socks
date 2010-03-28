
class laml.events.EventListener {
	public var type:String;
	public var handler:Function;
	public var context:Object;

	public function EventListener(type:String, handler:Function , context:Object) {
		this.type = type;
		this.handler = handler;
		this.context = context;
		if(type == null || handler == null || context == null) {
			var msg:String = "EventListener.constructor called with invalid arguments\n";
			if(context == null) {
				msg += "You left off the context argument in addEventListener call";
			}
			throw new Error(msg);
		}
	}
	
	public function equals(other:EventListener):Boolean {
		return (other.type === type && other.handler === handler && other.context === context);
	}
	
	public function toString():String {
		return "[EventListener type: " + type + " context: " + context + "]";
	}
}
