package socks {

    import asunit.asserts.*;

	public class SharedObjectWrapperTest {

		private var wrapper:SharedObjectWrapper;

        [Before]
		public function setUp():void {
			wrapper = new SharedObjectWrapper('so_wrapper');
		}

        [After]
		public function tearDown():void {
            wrapper.clear();
			wrapper = null;
		}

        [Test]
		public function canInstantiate():void {
			assertTrue("wrapper is SharedObjectWrapper", wrapper is SharedObjectWrapper);
		}

        [Test]
		public function canReadWriteAnonymousObject():void {
            var obj:Object = { name: 'hello' };
            wrapper.write('foo', obj);
            var result:Object = wrapper.read('foo');
            assertNotNull(result);
            assertEquals('hello', result.name);
		}

        [Test]
        public function canReadUnknownPropertyWithoutException():void {
            assertNull(wrapper.read('someUnknownProperty'));
        }

        [Test]
        public function canClear():void {
            canReadWriteAnonymousObject();
            wrapper.clear();
            assertNull(wrapper.read('foo'));
        }
	}
}

