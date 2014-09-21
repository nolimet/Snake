package net 
{
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.themes.AeonDesktopTheme;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import net.Conection;
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
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	public class Conection {
		
		static public const port:int = 11100;
		//static public const address:String = "192.168.0.101";
		static public const address:String = "84.80.98.251";
		protected var socket:Socket;
		private var pingTime:Number;
		private var currentTime:Date;
		
		private static var _instance:Conection = null;
		private static function CreateKey():void { }
		public function Conection(key:Function = null){
			if (key != CreateKey) {
				throw new Error("Creation of Conection without calling GetInstance is not valid");
			}
		}
		public static function GetInstance():Conection {
			if (_instance == null) {
				_instance = new Conection(CreateKey);
			}
			return _instance;
		}
		
		public function createSocket():void {   
			Main.debug.print(("[State]Connecting >" + address + "<"), Debug.Server_2);
			
			socket = new Socket();
			
			socket.addEventListener(Event.CONNECT,onConnected);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onData);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			socket.addEventListener(Event.CLOSE, onClose);
			socket.addEventListener(Event.DEACTIVATE, onDeactivate);
			socket.addEventListener(Event.ACTIVATE, onActivate);
			socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			socket.connect(address, port);
			/*
			if(socket.connected){
				Main.debug.print(("Connected"), Debug.Server_2);
			}else {
				Main.debug.print(("Not Connected"), Debug.Server_2);
			}
			*/
		}
		
		private function onClose(e:Event):void {
			Main.debug.print("[State]onClose",Debug.Server_2);
		}
		private function onDeactivate(e:Event):void {
			Main.debug.print("[State]onDeactivate",Debug.Server_2);
		}
		private function onActivate(e:Event):void {
			Main.debug.print("[State]onActivate",Debug.Server_2);
		}
		private function onSecurityError(e:SecurityErrorEvent):void {
			Main.debug.print("[State]onSecurityError",Debug.Server_2);
		}
		private function onIOError(e:IOErrorEvent):void {
			Main.debug.print("[State]IOErrorEvent",Debug.Server_2);
		}
		
		private function onConnected(e:Event):void {
			Main.debug.print("client - socket connected",Debug.Server_2);
			
			Ping();
		}
		
		private function onData(e:ProgressEvent):void{
		   Main.debug.print(("-process packege-") , Debug.Server_2);
		   var bytes:ByteArray = new ByteArray;
		   bytes.endian = Endian.LITTLE_ENDIAN;
		   socket.readBytes(bytes);
		   var messgaeLength:int = bytes.readInt();
		   Main.debug.print(("Length Message: " + messgaeLength) , Debug.Server_2);
		   var mesageType:int = bytes.readByte();
		   Main.debug.print(("Message Type: " + mesageType) , Debug.Server_2);
		   switch(mesageType) {
			   case MessageType.PING_BACK:
				   currentTime = new Date();
					var thisPingTime:Number = pingTime-currentTime.time;
					Main.debug.print(("Ping: " + thisPingTime) , Debug.Server_2);
				   break;
			   case MessageType.HELLO:
					Main.debug.print(("hello Message") , Debug.Server_2);
				   break;
		   }
		   
		}
		
		public function Ping():void {
			trace("connected:"+socket.connected);
			trace("ping");
			var messageData:ByteArray = new ByteArray();
			messageData.endian = Endian.LITTLE_ENDIAN;
			var messageL:int = 5;
			messageData.writeInt(messageL);
			var messageType:int = MessageType.PING;
			messageData.writeByte(messageType);
			
			socket.writeBytes(messageData);
			socket.flush();
			currentTime = new Date();
			pingTime = currentTime.time;
			trace("pingTime------------------: "+pingTime);
		}
		
	}
}