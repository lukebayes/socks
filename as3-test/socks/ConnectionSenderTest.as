package socks {

    import asunit.asserts.*;
    import asunit.framework.IAsync;

	public class ConnectionSenderTest {

        [Inject]
        public var async:IAsync;

        private var asyncHandler:Function;
        private var listener:ConnectionListener;
		private var sender:ConnectionSender;

        [Before]
		public function setUp():void {
            var name:String = "ConnectionSenderTest";
            listener = new ConnectionListener(name, null, false, 1);
            listener.connect(this);
			sender = new ConnectionSender(name);
		}

        [After]
		public function tearDown():void {
            listener.close();
            listener = null;
			sender = null;
		}

        [Test]
		public function canInstantiate():void {
			assertTrue("sender is ConnectionSender", sender is ConnectionSender);
		}

        [Test]
        public function canSendARequest():void {
            asyncHandler = async.add(null);
            sender.send('doSomethingWith', 'a', 'b', 'c');
        }

        // Not a Test:
        public function doSomethingWith(aye:String=null, bee:String=null, cee:String=null):void {
            assertEquals('a', aye);
            assertEquals('b', bee);
            assertEquals('c', cee);
            asyncHandler();
        }
	}
}
