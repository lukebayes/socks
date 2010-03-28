
import laml.events.Event;

interface laml.events.IEventDispatcher {
	public function hasEventListener(type:String, handler:Function, context:Object):Boolean;
	public function addEventListener(type:String, handler:Function, context:Object):Object;
	public function removeEventListener(type:String, handler:Function, context:Object):Object;
	public function dispatchEvent(event:Event):Boolean;
}
