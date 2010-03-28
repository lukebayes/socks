package socks {
	
	public class Request {

        public var name:String;
        public var _arguments:Array;
		
		public function Request(name:String=null, ...args:*) {
            this.name = name;
            this._arguments = args ||= [];
		} 

        public function get arguments():Array {
            var result:Array = [];
            var len:int = _arguments.length;
            for(var i:int; i < len; i++) {
                result.push(_arguments[i]);
            }
            return result;
        }
	}
}

