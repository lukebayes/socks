package socks {

    import asunit.asserts.*;
    import asunit.framework.IAsync;

	public class ConnectionListenerTest {

        [Inject]
        public var async:IAsync;

        private var asyncHandler:Function;
        private var bucket:String;
		private var listener:ConnectionListener;
        private var wrapper:SharedObjectWrapper;

        [Before]
		public function setUp():void {
            bucket = "ConnectionListenerTest";
			listener = new ConnectionListener(bucket, 1);

            listener.connect(this);
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
        public function canDelegate():void {
            var handler:Function = function(arg:Number):void {
                assertEquals(42, arg);
            }

            asyncHandler = async.add(handler);

            // Write a request to the SharedObject so that the listener
            // can pick it up...
            var request:Request = new Request('delegatedMethod', [42]);
            wrapper.write('requests', [request]);
        }

        public function delegatedMethod(arg:Number):void {
            // Call the asyncHandler so that the tests can continue
            asyncHandler(arg);
        }
	}
}
