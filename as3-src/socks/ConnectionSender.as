package socks {

	public class ConnectionSender {

        private var bucketName:String;
        private var path:String;
        private var secure:Boolean;
        private var wrapper:SharedObjectWrapper;
		
		public function ConnectionSender(bucketName:String, path:String=null, secure:Boolean=false) {
            this.bucketName = bucketName;
            this.path       = path;
            this.secure     = secure;
            wrapper = new SharedObjectWrapper(bucketName, path, secure);
		} 

        public function clear():void {
            wrapper.clear();
        }

        public function send(methodName:String, ...args:Array):void {
            var requests:Array = wrapper.read('requests') || [];
            var request:Request = new Request(methodName, args);
            requests.push(request);
            wrapper.write('requests', requests);
        }
	}
}

