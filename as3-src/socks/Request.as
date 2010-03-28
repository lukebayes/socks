package socks {
	
	public class Request {

        public static var incr:Number = 0;

        public var name:String;
        public var arguments:Array;
        public var id:String;
		
		public function Request(name:String=null, args:Array=null) {
            this.name = name;
            this.arguments = args || [];
            this.id = generateId();
		} 

        private function generateId():String {
            var now:Date = new Date();
            var ts:Number = now.valueOf();
            return (ts + '-' + (incr++));
        }
	}
}

