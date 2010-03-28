package socks {

    import asunit.asserts.*;

	public class ConnectionListenerTest {

        private var bucket:String;
		private var listener:ConnectionListener;
        private var wrapper:SharedObjectWrapper;

        [Before]
		public function setUp():void {
            bucket = "ListenerName";
			listener = new ConnectionListener(bucket);
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
        public function testConnect():void {
            listener.connect();
        }
	}
}
