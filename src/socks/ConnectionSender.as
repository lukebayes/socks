package socks {

	public class ConnectionSender {

        private var bucketName:String;
        private var wrapper:SharedObjectWrapper;
		
		public function ConnectionSender(bucketName:String) {
            this.bucketName = bucketName;
            wrapper = new SharedObjectWrapper(bucketName);
		} 

        public function send(methodName:String, ...args:Array):void {
            var requests:Array = wrapper.read('requests') || [];
            var request:Request = new Request(methodName, args);
            requests.push(request);
            wrapper.write('requests', requests);
        }
	}
}

