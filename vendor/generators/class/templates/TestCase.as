package <%= package_name %> {

    import asunit.asserts.*;

	public class <%= test_case_name  %> {
		private var <%= instance_name %>:<%= class_name %>;

        [Before]
		public function setUp():void {
			<%= instance_name %> = new <%= class_name %>();
		}

        [After]
		public function tearDown():void {
			<%= instance_name %> = null;
		}

        [Test]
		public function canInstantiate():void {
			assertTrue("<%= instance_name %> is <%= class_name %>", <%= instance_name %> is <%= class_name %>);
		}

        [Test]
		public function ensureExecution():void {
			assertTrue("Failing test", false);
		}
	}
}
