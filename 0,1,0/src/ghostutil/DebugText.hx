package ghostutil;

class DebugText extends flixel.group.FlxGroup.FlxTypedGroup<DebugTextObject> {
    var texts:Array<DebugTextObject> = [];
    public var font(default, set):String = flixel.system.FlxAssets.FONT_DEFAULT;

    public function debugPrint(text:String) {
        var text = new DebugTextObject(10, 0, flixel.FlxG.width, text, 16);
        text.font = font;
        add(text);

        texts.push(text);

        text.destroyCallback = () -> {
            texts.remove(text);
            updateOrder();

            return;
        }

        updateOrder();
    }

    private function updateOrder() {
        var i = texts.length;
        for (text in texts) {
            i--;
            if (text != null) text.y = (10 + (20 * i));
        }
    }

    private function set_font(newFont:String) {
        for (text in texts) {
            if (text != null) text.font = newFont;
        }

        return this.font = newFont; 
    }
}

private class DebugTextObject extends flixel.text.FlxText {
    public var destroyCallback:Void->Void = () -> return;
    override public function new(X:Float = 0, Y:Float = 0, FieldWidth:Float = 0, ?Text:String, Size:Int = 8, EmbeddedFont:Bool = true) {
        super(X, Y, FieldWidth, Text, Size, EmbeddedFont);
        color = 0xFFFF0000;

        new flixel.util.FlxTimer().start(3, (_) -> {
            flixel.tweens.FlxTween.tween(this, {alpha: 0}, 1, {ease: flixel.tweens.FlxEase.expoOut, onComplete: (_) -> {
                this.kill();
                destroyCallback();
            }});
        });
    } 
}