package server 
{
	import flash.display.Sprite;
	import  flash.net.Socket;
	import  flash.net.XMLSocket;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Jesse Stam
	 */
	public class Connection extends Sprite
	{
		private var connectionStatus:TextField;
		public function Connection() 
		{
			connectionStatus = new TextField();
			connectionStatus.text = "waiting to connect";
			addChild(connectionStatus);
		}
		
		private function StartConnection(ip:String, port:String):void 
		{
			
		}
		
		public function CloseConnection():void
		{
			
		}
	}
}