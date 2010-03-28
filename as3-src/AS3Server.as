
package {

    import fl.controls.Button;
    import fl.controls.ComboBox;
    import fl.controls.TextArea;
    import fl.controls.TextInput;
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import socks.EndPoint;

    public class AS3Server extends MovieClip {

        public var methodNamesCombo:ComboBox;
        public var output:TextArea;
        public var parameterInput:TextInput;
        public var sendButton:Button;

        private var connection:EndPoint;

        public function AS3Server() {
            initialize();
        }

        private function initialize():void {
            connection = new EndPoint("DemoConnection", initializePath(), false, 300);
            connection.connect(this, true);
            sendButton.addEventListener(MouseEvent.CLICK, sendButtonClickHandler);
        }

        private function initializePath():String {
            var path:String = loaderInfo.url;
            var parts:Array = path.split('/');
            parts.pop();
            path = parts.join('/');
            puts(path);
            return path;
        }

        public function sendButtonClickHandler(event:Event):void {
            var item:Object = methodNamesCombo.selectedItem;
            var argument:String = parameterInput.text;
            puts(">> Send button clicked with: " + item.label + " argument; " + argument);
            connection.send(item.label, argument);
        }

        public function randomMethod3(name:String):void {
            puts(">> randomMethod3 called with: " + name);
        }

        public function puts(message:String):void {
            output.text += message + "\n\n";
        }
    }
}

