package socks {

    import asunit.asserts.*;

	public class ConnectionSenderTest {
		private var instance:ConnectionSender;

        [Before]
		public function setUp():void {
            var name:String = "SenderName";
			instance = new ConnectionSender(name);
		}

        [After]
		public function tearDown():void {
			instance = null;
		}

        [Test]
		public function canInstantiate():void {
			assertTrue("instance is ConnectionSender", instance is ConnectionSender);
		}
	}
}
