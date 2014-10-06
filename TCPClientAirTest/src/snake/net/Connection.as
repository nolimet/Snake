
package snake.net 
{
	import flash.events.OutputProgressEvent;
	import snake.menu.ScreenEvents;
	import snake.utils.debug.Debug;
	import snake.Main;
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.themes.AeonDesktopTheme;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import snake.net.Conection;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.text.TextField;
	import flash.net.Socket;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import snake.net.MessageType;
	import snake.utils.debug.Debug;
	import snake.BitUtil;
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	public class Connection {
		
		static public const port:int = 11100;
		//static public const address:String = "192.168.0.101";
		//static public const address:String = "84.80.98.251";
		static public const address:String = "127.0.0.1";
		private var socket_:Socket;
		private var pingTime:Number;
		private var currentTime:Date;
		
		private var clientName:String;
		
		public var playerList:Vector.<Player>;
		
		public function get socket():Socket {
			return socket_;
		}
		
		private static var _instance:Conection = null;
		private static function CreateKey():void { }
		public function Conection(key:Function = null){
			if (key != CreateKey) {
				throw new Error("Creation of Conection without calling GetInstance is not valid");
			}
			createSocket();
		}
		public static function GetInstance():Conection {
			if (_instance == null) {
				_instance = new Conection(CreateKey);
			}
			return _instance;
		}
		
		public function Connect(name:String, ip:String = address):void {
			
			socket_.connect(ip, port);
			
			clientName = name;
			socket_.timeout = 2000;
			playerList = new Vector.<Player>();
			Main.debug.print(("[client Timeout]:"+socket_.timeout.toString()+"ms"),Debug.Server_2);
		}
		
		public function DisConnect():void {
			if(socket_.connected){
				socket_.close();
				socket_.dispatchEvent(new Event(Event.CLOSE));
				Main.debug.print(("[State]DisConnect"), Debug.Server_2);
			}else {
				Main.debug.print(("[State]Not Connected Cannot Disconnect"), Debug.Server_2);
			}
		}
		
		private function createSocket():void {   
			Main.debug.print(("[State]createSocket addres"), Debug.Server_2);
			//Main.debug.print(("[State]createSocket addres>" + address + "<"), Debug.Server_2);
			
			socket_ = new Socket();
			
			socket_.addEventListener(Event.CONNECT,onConnected);
			socket_.addEventListener(ProgressEvent.SOCKET_DATA, onData);
			socket_.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			socket_.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			socket_.addEventListener(Event.CLOSE, onClose);
			socket_.addEventListener(Event.DEACTIVATE, onDeactivate);
			socket_.addEventListener(Event.ACTIVATE, onActivate);
			socket_.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			socket_.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, onDataOut);
			
			
			/*
			if(socket.connected){
				Main.debug.print(("Connected"), Debug.Server_2);
			}else {
				Main.debug.print(("Not Connected"), Debug.Server_2);
			}
			*/
		}
		
		private function onDataOut(e:OutputProgressEvent):void {
			Main.debug.print("[State]onDataOut",Debug.Server_2);
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
			
			PlayerSetName(clientName);
		}
		
		private function onData(e:ProgressEvent):void {
			Main.debug.print(("-process packege-") , Debug.Server_2);
			var bytes:ByteArray = new ByteArray;
			bytes.endian = Endian.LITTLE_ENDIAN;
			socket_.readBytes(bytes);
			while(bytes.bytesAvailable>0){
				var messgaeLength:int = bytes.readInt();
				Main.debug.print(("Length Message: " + messgaeLength) , Debug.Server_2);
				var mesageType:int = bytes.readByte();
				Main.debug.print(("Message Type: " + mesageType) , Debug.Server_2);
				switch(mesageType) {
					case MessageType.PING_BACK:
						currentTime = new Date();
						var thisPingTime:Number = currentTime.time-pingTime;
						Main.debug.print(("Ping: " + thisPingTime + "ms") , Debug.Server_2);
						break;
						
					case MessageType.HELLO:
						Main.debug.print(("hello Message") , Debug.Server_2);
						break;
						
					case MessageType.PLAYER_LIST:
						PlayerList(bytes);
						break;
						
					case MessageType.PLAYER_SET_NEW_DIRECTION:
						SetNewPlayerDir(bytes)
						break;
			   }
			}
		}
		
		public function Ping():void {
			trace("connected:"+socket_.connected);
			trace("ping");
			var messageData:ByteArray = new ByteArray();
			messageData.endian = Endian.LITTLE_ENDIAN;
			var messageL:int = 5;
			messageData.writeInt(messageL);
			var messageType:int = MessageType.PING;
			messageData.writeByte(messageType);
			
			socket_.writeBytes(messageData);
			socket_.flush();
			currentTime = new Date();
			pingTime = currentTime.time;
			trace("pingTime------------------: "+pingTime);
		}
		
		private function PlayerSetName(name:String):void {
			trace("connected:"+socket_.connected);
			trace("PLAYER_SET_NAME");
			var messageData:ByteArray = new ByteArray();
			messageData.endian = Endian.LITTLE_ENDIAN;
			
			var playerName:String = name;
			
			var messageL:int = 5+playerName.length;
			messageData.writeInt(messageL);
			
			var messageType:int = MessageType.PLAYER_SET_NAME;
			messageData.writeByte(messageType);
			
			messageData.writeInt(playerName.length);
			
			BitUtil.stringToByteArray(playerName, messageData);
			
			socket_.writeBytes(messageData);
			socket_.flush();
		}
		
		private function PlayerList(_bytes:ByteArray) {
			
			var listLength:int = _bytes.readInt();
			playerList = new Vector.<Player>();
			Main.debug.print(("[Player List] Length:"+listLength) , Debug.Server_2);
			for (var j:int = 0; j < listLength; j++) 
			{
				//gettting name
				var name:String = new String();
				var nameL:int = _bytes.readInt();
				for (var i:int = 0; i < nameL; i++) 
				{
					var newLLetter:String = String.fromCharCode(_bytes.readUnsignedByte());
					name = name+newLLetter ;
				}
				//getting ID
				var id:int = 0;
				//getting Dir
				var dir:int = 0;
				playerList.push(new Player(name,dir,id));
				Main.debug.print(("-Player: " + name) , Debug.Server_2);
				Main.eventManager.dispatchEvent(new starling.events.Event( ScreenEvents.NEW_PLAYERLIST ));
			}
		}
		
		private function SetNewPlayerDir(_bytes:ByteArray) {
			
		}
	}
}