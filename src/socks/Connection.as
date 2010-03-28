package socks {
	
	public class Connection {

        private var name:String;
        private var listener:ConnectionListener;
        private var sender:ConnectionSender;
		
		public function Connection(name:String) {
            this.name = name;
            initialize();
		} 

        private function initialize():void {
            listener = new ConnectionListener(name);
            sender = new ConnectionSender(name);
        }

        public function close():void {
            listener.close();
        }
	}
}
