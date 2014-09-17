package utils.debug 
{
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	public class Debug
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
	}
}