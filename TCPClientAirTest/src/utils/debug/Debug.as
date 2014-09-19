package utils.debug 
{
	import starling.display.Sprite;
	import starling.text.TextField;
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	public class Debug extends Sprite
	{
		//example
		
		/*Debug.test(function():void { 
			//draw stuff
			drawStuff();
			//print info
			trace("info");
		} , Debug.Server_1);*/
		
		public static const Server_1:String = "Server_1";
		public static const Server_2:String = "Server_2";
		private static const OFF:String = "off";
		//private static var USER:Vector.<String> = new <String>[Kit,ALL,Kit_Draw_Objects,Kit_bounce];
		private static var USER:Vector.<String> = new <String>[Server_2]; //enter all user u want to print for
		
		private var textFields:Vector.<TextField> = new Vector.<TextField>();
		
		public static function test(func:Function,user:String):Function 
		{
			for (var i:int = 0; i < USER.length; i++) 
			{
				if (USER[i]== user){
					return func();
					break;
				}
			}
			return null;
		}
		
		public function Debug() {
			
		}
		
		public function addText(text:String):void {
			//smove text
			for (var i:int = 0; i < textFields.length; i++) 
			{
				textFields[i].y -= 20;
			}
			
			//spawn new
			trace("-----------------"+stage.stageHeight);
			textFields[textFields.length] = new TextField(400, stage.stageHeight+200, text);
			//textFields[textFields.length - 1]);
			//textFields[textFields.length - 1].text = text;
			//textFields[textFields.length - 1].y = 600-20;
			addChild(textFields[textFields.length-1]);
		}
		
		public function print(string:String,user:String):Function 
		{
			for (var i:int = 0; i < USER.length; i++) 
			{
				if (USER[i]== user){
					trace(string);
					addText(string);
					break;
				}
			}
			return null;
		}
	}
}