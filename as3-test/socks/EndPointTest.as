package socks {

    import asunit.asserts.*;
    import asunit.framework.IAsync;

	public class EndPointTest {
        
        [Inject]
        public var async:IAsync;

		private var server:EndPoint;
		private var client:EndPoint;

        private var serverHandler:Function;
        private var clientHandler:Function;

        [Before]
		public function setUp():void {
			server = new EndPoint("EndPointTest");
            client = new EndPoint("EndPointTest");
		}

        [After]
		public function tearDown():void {
            server.close();
            client.close();

			server = null;
            client = null
		}

        [Test]
		public function canConnectTwoWay():void {
            // Set up two async handlers:
            serverHandler = async.add(null, 200);
            clientHandler = async.add(null, 200);

            // Connect to both endpoints:
            server.connect(this, true);
            client.connect(this);

            // Send a message across both endpoints:
            client.send('clientMethod');
            server.send('serverMethod');
		}

        public function serverMethod():void {
            serverHandler();
        }

        public function clientMethod():void {
            clientHandler();
        }
	}
}

