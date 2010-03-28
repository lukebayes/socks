package socks {
    
    import asunit.asserts.*;

	public class ConnectionTest {

		private var connection:Connection;
        private var name:String;

        [Before]
		public function setUp():void {
            name = "TestConnection";
			connection = new Connection(name);
		}

        [After]
		public function tearDown():void {
            connection.close();
			connection = null;
		}

        [Test]
		public function canInstantiate():void {
			assertTrue("connection is Connection", connection is Connection);
		}

	}
}
