package  
{
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.themes.AeonDesktopTheme;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.text.TextField;
	import flash.net.Socket;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import types.MessageType;
	import utils.debug.Debug;
	//import aeon
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	
	public class Main extends Sprite 
	{
		static public const port:int = 60000;
		static public const address:String = "127.0.0.1";
		// create our client socket
		protected var socket:Socket;
		protected var button:Button;
		private var pingTime:Number;
		private var currentTime:Date = new Date();
		
		public function Main() {
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage():void {
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStage);
			var textField:TextField = new TextField(400, 300, "Welcome to Starling!");
			addChild(textField);
			new AeonDesktopTheme();
			this.button = new Button();
			this.button.label = "Click Me";
			this.addChild( button );
			this.button.addEventListener( starling.events.Event.TRIGGERED, button_triggeredHandler );
			createSocket();
		}
		
		private function button_triggeredHandler( event:starling.events.Event ):void
		{
			trace("buttonPressed");
			Ping();
		}

		protected function createSocket():void{             
			// connect
			socket = new Socket(address, port);
			// get notified when the socket connects
			socket.addEventListener(Event.CONNECT,onConnected);
			// get notified when there's data
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onData);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			socket.addEventListener(Event.CLOSE, onClose);
			socket.addEventListener(Event.DEACTIVATE, onDeactivate);
			socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		
		private function onClose(e:Event):void {
			trace("[State]onClose");
		}
		private function onDeactivate(e:Event):void {
			trace("[State]onDeactivate");
		}
		private function onSecurityError(e:SecurityErrorEvent):void {
			trace("[State]onSecurityError");
		}
		private function onIOError(e:IOErrorEvent):void {
			trace("[State]IOErrorEvent");
		}
		
		protected function onConnected(e:Event):void {
			trace("client - socket connected");
			
			Ping();
		}
		
		protected function onData(e:ProgressEvent):void{
		   Debug.test(function():void {trace("-process packege-") } , Debug.Server_2);
		   var bytes:ByteArray = new ByteArray;
		   bytes.endian = Endian.LITTLE_ENDIAN;
		   socket.readBytes(bytes);
		   var messgaeLength:int = bytes.readInt();
		   Debug.test(function():void {trace("Length Message: " + messgaeLength)} , Debug.Server_2);
		   var mesageType:int = bytes.readByte();
		   Debug.test(function():void {trace("Message Type: " + mesageType)} , Debug.Server_2);
		   switch(mesageType) {
			   case MessageType.PingBack:
				   currentTime = new Date();
					var thisPingTime:Number = pingTime-currentTime.time;
					Debug.test(function():void {trace("Ping: " + thisPingTime)} , Debug.Server_2);
				   break;
			   case MessageType.Hello:
					Debug.test(function():void {trace("hello Message")} , Debug.Server_1);
				   break;
		   }
		   
		}
		
		private function Ping():void {
			trace("connected:"+socket.connected);
			trace("ping");
			var messageData:ByteArray = new ByteArray();
			messageData.endian = Endian.LITTLE_ENDIAN;
			var messageL:int = 5;
			messageData.writeInt(messageL);
			var messageType:int = MessageType.Ping;
			messageData.writeByte(messageType);
			
			socket.writeBytes(messageData);
			socket.flush();
			currentTime = new Date();
			pingTime = currentTime.time;
			trace("pingTime------------------: "+pingTime);
			
		}
	}

}