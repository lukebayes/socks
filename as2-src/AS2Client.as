
import socks.EndPoint;

class AS2Client {

    private var button:MovieClip;
    private var context:MovieClip;
    private var connection:EndPoint;
    private var textField:TextField;

    private static var client:AS2Client;

    public static function main():Void {
        AS2Client.client = new AS2Client(_root);
    }

    public function AS2Client(context:MovieClip) {
        this.context = context;
        context._lockroot = true;

        drawTextField();
        drawButton();
        Stage.scaleMode = 'noscale';
        Stage.align = 'TL';
        Stage.addListener(this);

        connection = new EndPoint("DemoConnection", initializePath(), false, 300);
        connection.connect(this, true); // true == asClient in AS2
        puts(">> ready to connect!");
    }

    private function initializePath():String {
        var path:String = context._url;
        var parts:Array = path.split('/');
        parts.pop();
        path = parts.join('/');
        puts(path);
        return path;
    }

    public function puts(message:String):Void {
        textField.text += message + "\n\n";
    }

    public function randomMethod2(name:String):Void {
        puts(">> randomMethod2 called with: " + name);
    }

    private function drawTextField():Void {
        context.createTextField('textField', 10, 5, 5, Stage.width - 10, Stage.height - 10);
        textField                 = context.textField;
        textField.background      = true;
        textField.backgroundColor = 0xFFFFFF;
        textField.border          = true;
        textField.borderColor     = 0x333333;
        textField.multiline       = true;
        textField.selectable      = true;
        textField.type            = "dynamic";
        textField.wordWrap        = true;
    }

    private function drawButton():Void {
        context.createEmptyMovieClip('button', 11);
        button = context.button;
        button.clear();
        button.beginFill(0x00ff00);
        button.lineTo(80, 0);
        button.lineTo(80, 20);
        button.lineTo(0, 20);
        button.lineTo(0, 0);
        button.endFill();

        button._y = 10;
        button._x = Stage.width - 100;

        var self = this;
        button.enabled = true;
        button.onRelease = function():Void {
            self.sendPuts();
        }
    }

    public function sendPuts():Void {
        connection.send('puts', "SOME MESSAGE");
    }

    private function onResize():Void {
        textField._x = 5;
        textField._y = 5;
        textField._width = Stage.width - 10;
        textField._height = Stage.height - 10;
    }
}

