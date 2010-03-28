
import socks.EndPoint;

class AS2Client {

    private var context:MovieClip;
    private var connection:EndPoint;
    private var textField:TextField;

    private static var client:AS2Client;

    public static function main():Void {
        AS2Client.client = new AS2Client(_root);
    }

    public function AS2Client(context:MovieClip) {
        trace(">> AS2Client instantiated");
        this.context = context;
        context._lockroot = true;

        drawTextField();

        connection = new EndPoint("DemoConnection");
        connection.connect(this);
        puts(">> READY");
    }

    public function connectedHandler():Void {
        trace(">> connected handler!");
        puts(">> CONNECTED!!");
    }

    private function puts(message:String):Void {
        textField.text += message + "\n\n";
    }

    private function drawTextField():Void {
        trace(">> Drawing with: " + context);
        var initObject:Object = {
            background : true,
            border     : true,
            multiline  : true,
            selectable : true,
            type       : "dynamic",
            wordWrap   : true
        }
        context.createTextField('textField', 10, 5, 5, 200, 300, initObject);
        textField = context.textField;
        
        trace(">> textField: " + textField);
    }
}


