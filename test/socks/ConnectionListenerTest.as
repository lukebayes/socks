package socks {

    import asunit.asserts.*;
    import asunit.framework.IAsync;

	public class ConnectionListenerTest {

        [Inject]
        public var async:IAsync;

        private var bucket:String;
		private var listener:ConnectionListener;
        private var wrapper:SharedObjectWrapper;

        [Before]
		public function setUp():void {
            bucket = "ConnectionListenerTest";
			listener = new ConnectionListener(bucket, 5);
            listener.delegate = this;

            wrapper = new SharedObjectWrapper(bucket);
		}

        [After]
		public function tearDown():void {
            wrapper.clear();
            wrapper = null;
            listener.close();
			listener = null;
            bucket = null;
		}

        [Test]
		public function canInstantiate():void {
			assertTrue("listener is ConnectionListener", listener is ConnectionListener);
		}

        [Test]
        public function canConnect():void {
            listener.connect();
        }

        [Test]
        public function canDelegate():void {
            listener.connect();
            async.add(null); // Make async wait - we'll clear it manually in a moment...

            var request:Request = new Request('delegatedMethod', 42);
            wrapper.write('requests', [request]);
        }

        public function delegatedMethod(arg:Number):void {
            trace(">> delegated method called!");
            async.cancelPending();
        }
	}
}
