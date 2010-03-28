package {
	import asunit.ui.TextRunnerUI;

    import socks.SharedObjectWrapperTest;
	
	public class SocksRunner extends TextRunnerUI {

		public function SocksRunner() {
			// run(clazz:Class, methodName:String);
			// NOTE: sending a particular class and method name will
			// execute setUp(), the method and NOT tearDown.
			// This allows you to get visual confirmation while developing
			// visual entities
			run(AllTests);
		}
	}
}
