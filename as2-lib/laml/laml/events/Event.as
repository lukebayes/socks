
class laml.events.Event {
    public static var COMPLETE:String        = 'complete';
    public static var FAILURE:String         = 'failure';
    public static var SUCCESS:String         = 'success';

    public static var CHANGE:String          = "change";
    public static var CONNECTED:String       = "connected";
    public static var CLICK:String           = "click";
    public static var FORM_SUBMIT:String     = "formSubmit";
    public static var LOAD_COMPLETE:String   = "loadComplete";
    public static var MOUSE_DOWN:String      = "mouseDown";
    public static var MOUSE_OVER:String      = "mouseOver";
    public static var MOUSE_UP:String        = "mouseUp";
    public static var ROLL_OUT:String        = "onRollOut";
    public static var ROLL_OVER:String       = "onRollOver";
    public static var TERMINATED:String      = "terminated";
    public static var WIZARD_BACK:String     = "wizardBack";
    public static var WIZARD_NEXT:String     = "wizardNext";
    
	private var $type:String;
	private var $target:Object;
	private var $bubbles:Boolean = true;
	private var propagates:Boolean = true;
	public var payload:Object;

	public function Event(type:String) {
		if(type == undefined) {
			throw new Error("Event instantiated with invalid 'type' argument.");
		}
		$type = type;
	}
	
	public function get type():String {
		return $type;
	}
	
	// TODO: this is a divergence from AS3
	public function set target(obj:Object):Void {
		$target = obj;
	}

	public function get target():Object {
		return $target;
	}
	
	public function get bubbles():Boolean {
		return $bubbles;
	}

	public function set bubbles(bool:Boolean):Void {
		$bubbles = bool;
	}
		
	public function stopImmediatePropagation():Object {
		$bubbles = false;
		propagates = false;
		return null; // what else should I return?
	}

	public function stopPropagation():Object {
		$bubbles = false;
		return null; // what else should I return?
	}
	
	public function valueOf():String {
	    return "[laml.events.Event :: type:" + type + ", target: " + target + ", bubbles:" + bubbles + ", propagates:" + propagates + "]";
    }
}
