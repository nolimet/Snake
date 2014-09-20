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
	//import flash.system.System.sec
	//import aeon
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	
	public class Main extends Sprite 
	{
		static public const port:int = 11100;
		//static public const address:String = "192.168.0.101";
		static public const address:String = "84.80.98.251";
		// create our client socket
		protected var socket:Socket;
		protected var button:Button;
		private var pingTime:Number;
		private var currentTime:Date = new Date();
		private var debug:Debug = new Debug();
		
		public function Main() {
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage():void {
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStage);
			//var textField:TextField = new TextField(400, 300, "Welcome to Starling!");
			//addChild(textField);
			new AeonDesktopTheme();
			this.button = new Button();
			this.button.label = "Click Me";
			debug.touchable = false;
			this.addChild(debug);
			this.addChild( button );
			this.button.addEventListener( starling.events.Event.TRIGGERED, button_triggeredHandler );
			
			createSocket();
		}
		
		private function button_triggeredHandler( event:starling.events.Event ):void
		{
			trace("buttonPressed");
			Ping();
		}

		protected function createSocket():void {   
			debug.print(("connectTo:"+address),Debug.Server_2);
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
			debug.print("[State]onClose",Debug.Server_2);
		}
		private function onDeactivate(e:Event):void {
			debug.print("[State]onDeactivate",Debug.Server_2);
		}
		private function onSecurityError(e:SecurityErrorEvent):void {
			debug.print("[State]onSecurityError",Debug.Server_2);
		}
		private function onIOError(e:IOErrorEvent):void {
			debug.print("[State]IOErrorEvent",Debug.Server_2);
		}
		
		protected function onConnected(e:Event):void {
			debug.print("client - socket connected",Debug.Server_2);
			
			Ping();
		}
		
		protected function onData(e:ProgressEvent):void{
		   debug.print(("-process packege-") , Debug.Server_2);
		   var bytes:ByteArray = new ByteArray;
		   bytes.endian = Endian.LITTLE_ENDIAN;
		   socket.readBytes(bytes);
		   var messgaeLength:int = bytes.readInt();
		   debug.print(("Length Message: " + messgaeLength) , Debug.Server_2);
		   var mesageType:int = bytes.readByte();
		   debug.print(("Message Type: " + mesageType) , Debug.Server_2);
		   switch(mesageType) {
			   case MessageType.PingBack:
				   currentTime = new Date();
					var thisPingTime:Number = pingTime-currentTime.time;
					debug.print(("Ping: " + thisPingTime) , Debug.Server_2);
				   break;
			   case MessageType.Hello:
					debug.print(("hello Message") , Debug.Server_1);
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