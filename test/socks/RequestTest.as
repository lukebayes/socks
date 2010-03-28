package socks {

    import asunit.asserts.*;

	public class RequestTest {

		private var request:Request;
        private var wrapper:SharedObjectWrapper;

        [Before]
		public function setUp():void {
			request = new Request();
            wrapper = new SharedObjectWrapper('testRequest');
            wrapper.clear();
		}

        [After]
		public function tearDown():void {
			request = null;
            wrapper.clear();
		}

        [Test]
		public function canInstantiate():void {
			assertTrue("request is Request", request is Request);
		}

        [Test]
		public function canAssignName():void {
            request = new Request('foo');
            assertEquals('foo', request.name);
		}

        [Test]
        public function canAssignSingleArgument():void {
            request = new Request('foo', 'a');
            assertEquals('a', request.arguments.shift());
        }

	    [Test]
        public function canAssignDoubleArgument():void {
            request = new Request('foo', 'a', 'b');
            var args:Array = request.arguments;
            assertEquals('a', args.shift());
            assertEquals('b', args.shift());

            assertEquals("Should not receive actual array by reference...", 2, request.arguments.length);
        }

        private function writeThenReadRequests():Array {
            var a:Request = new Request('aye');
            var b:Request = new Request('bee', 1, 'two', true);
            var c:Request = new Request('cee', {name:'foo'}, ['bar']);
            wrapper.write('requests', [a, b, c]);
            return wrapper.read('requests');
        }

        [Test]
        public function canSerializeRequestArray():void {
            var requests:Array = writeThenReadRequests();
            assertNotNull(requests);
            assertEquals(3, requests.length);
        }

        [Test]
        // Simple Request was serialized and returned:
        public function canSerializeSimpleRequest():void {
            var requests:Array = writeThenReadRequests();
            var a:Request = requests[0];
            assertEquals('aye', a.name);
        }

        [Test]
        // Request with primitive args was serialized and returned:
        public function canSerializeRequestWithArgs():void {
            var requests:Array = writeThenReadRequests();
            var b:Request = requests[1];
            assertEquals('bee', b.name);
            assertEquals(3, b.arguments.length);
            assertEquals(1, b.arguments[0]);
            assertEquals('two', b.arguments[1]);
            assertEquals(true, b.arguments[2]);
        }

        [Test]
        // Request with general complex types was serialized and returned:
        public function canSerializeRequestWithComplexArgs():void {
            var requests:Array = writeThenReadRequests();
            var c:Request = requests[2];
            var args:Array = c.arguments;
            assertEquals('cee', c.name);
            assertEquals(2, args.length);
            assertEquals('foo', args[0].name);
            assertEquals('bar', args[1][0]);
        }
	}
}

