package socks {
    
    import asunit.asserts.*;

	public class ConnectionTest {
		private var connection:Connection;

        [Before]
		public function setUp():void {
			connection = new Connection();
		}

        [After]
		public function tearDown():void {
			connection = null;
		}

        [Test]
		public function canInstantiate():void {
			assertTrue("connection is Connection", connection is Connection);
		}

        [Test]
		public function ensureExecution():void {
			assertTrue("Failing test", true);
		}
	}
}
