package socks {

	public class EndPoint {

        private var bucketName:String;
        private var connected:Boolean;
        private var interval:int;
        private var listener:ConnectionListener;
        private var path:String;
        private var secure:Boolean;
        private var sender:ConnectionSender;
		
		public function EndPoint(bucketName:String, path:String=null, secure:Boolean=false, interval:int=50) {
            if(bucketName == null) {
                throw new Error("EndPoint cannot be created without a valid bucketName");
            }
            this.bucketName = bucketName;
            this.interval   = interval;
            this.path       = path;
            this.secure     = secure;
		} 

        public function connect(delegate:*, asServer:Boolean=false):void {
            var listenerBucket:String;
            var senderBucket:String;
            // If we're the first connection at this name,
            // we're the 'server', otherwise, we're a 'client'
            // set up your keys accordingly...
            if(asServer) {
                trace(">> Creating Server EndPoint now");
                listenerBucket = bucketName + "-server";
                senderBucket = bucketName + "-client";
            }
            else {
                trace(">> Creating Client EndPoint now");
                listenerBucket = bucketName + "-client";
                senderBucket = bucketName + "-server";
            }

            listener = new ConnectionListener(listenerBucket, path, secure, interval);
            sender = new ConnectionSender(senderBucket, path, secure);
            listener.connect(delegate);
            connected = true;
        }

        public function send(methodName:String, ...args:Array):void {
            args ||= [];
            args.unshift(methodName);
            sender.send.apply(sender, args);
        }

        public function close():void {
            if(connected) {
                clear();
                listener.close();
            }
        }

        private function clear():void {
            listener.clear();
            sender.clear();
        }
	}
}

