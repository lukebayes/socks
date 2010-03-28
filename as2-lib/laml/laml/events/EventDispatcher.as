
import laml.events.Event;
import laml.events.EventListener;
import laml.events.IEventDispatcher;

class laml.events.EventDispatcher implements IEventDispatcher {
	private var listeners:Array;
	private var eventTarget:Object;
	
	public function EventDispatcher(eventTarget:Object) {
		listeners = new Array();
		this.eventTarget = (eventTarget == undefined) ? this : eventTarget;
	}
	
	public function hasEventListener(type:String, handler:Function, context:Object):Boolean {
		var ln:Number = listeners.length;
		if(handler == null && context == null) {
			for(var i:Number = 0; i < ln; i++) {
				if(listeners[i].type === type) {
					return true;
				}
			}
		}
		else {
			for(var i:Number = 0; i < ln; i++) {
				if(listeners[i].type === type && listeners[i].handler == handler && listeners[i].context == context) {
					return true;
				}
			}
		}
		return false;
	}
	
	public function addEventListener(type:String, handler:Function, context:Object):Object {
		removeEventListener(type, handler, context);
		var listener:EventListener = new EventListener(type, handler, context);
		listeners.push(listener);
		return listener;
	}
	
	public function removeEventListener(type:String, handler:Function, context:Object):Object {
		var listener:EventListener = new EventListener(type, handler, context);
		var ln:Number = listeners.length;
		for(var i:Number = 0; i < ln; i++) {
			if(listener.equals(listeners[i])) {
				return listeners.splice(i, 1)[0];
			}
		}
		return null;
	}
	
	public function dispatchEvent(event:Event):Boolean {
		if(event.target == null) {
			event["$target"] = eventTarget;
		}
		var type:String = event.type;
		var listener:EventListener;
		var ln:Number = listeners.length;
		for(var i:Number = 0; i < ln; i++) {
			if(!event["propagates"]) {
				return false;
			}
			listener = listeners[i];
			if(listener.type === type) {
//				try {
					listener.handler.call(listener.context, event);
//				}
//				catch(e:Error) {
//					// lb. Had to leave this in for test cases
//					// it's not adding much to the overall application size...
//					if(e instanceof AssertionFailedError || e instanceof AssertionPassedError) {
//						throw e;
//					}
//				}
			}
		}

		return true;
	}
}
