package socks {

    import asunit.asserts.*;
    import asunit.framework.IAsync;

    import flash.utils.setTimeout;

	public class ConnectionListenerTest {

        [Inject]
        public var async:IAsync;

        private var asyncHandler:Function;
        private var bucket:String;
        private var callbackCount:int;
		private var listener:ConnectionListener;
        private var wrapper:SharedObjectWrapper;

        [Before]
		public function setUp():void {
            callbackCount = 0;
            bucket = "ConnectionListenerTest";
			listener = new ConnectionListener(bucket, null, false);
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

            // write a request to the sharedobject so that the listener
            // can pick it up...
            var request:Request = new Request('delegatedMethod', [42]);
            wrapper.write('requests', [request]);
        }

        [Test]
        public function ignoresRequestsWithDuplicateId():void {

            // Ensure the outer handler was only called once.
            var innerHandler:Function = async.add(function():void {
                assertEquals(1, callbackCount);
            }, 500);

            asyncHandler = function():void {
                callbackCount++;
                // Trigger the async completion a little later to 
                // ensure that this doesn't get call AGAIN...
                setTimeout(function():void {
                    innerHandler();
                }, 100);
            }


            // Send three requests with the same id and 
            // ensure that the callback only gets called once.
            var a:Request = new Request('delegatedMethod');
            var b:Request = new Request('delegatedMethod');
            var c:Request = new Request('delegatedMethod');
            a.id = '1234-56';
            b.id = '1234-56';
            c.id = '1234-56';
            wrapper.write('requests', [a, b, c]);
        }

        public function delegatedMethod(arg:int=0):void {
            // Call the asyncHandler so that the tests can continue
            asyncHandler(arg);
        }
	}
}
