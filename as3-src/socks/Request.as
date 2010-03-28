package socks {
	
	public class Request {

        public var name:String;
        public var arguments:Array;
		
		public function Request(name:String=null, args:Array=null) {
            this.name = name;
            this.arguments = args || [];
		} 
	}
}

