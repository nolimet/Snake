
package snake.net 
{
	import flash.accessibility.AccessibilityProperties;
	import flash.events.OutputProgressEvent;
	import snake.menu.ScreenEvents;
	import snake.utils.debug.Debug;
	import snake.Main;
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.themes.AeonDesktopTheme;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import snake.net.Connection;
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
			
			public var playerSelf:Player = new Player("", -1, -1);
			
			public var idAdmin:int = -1;
			
			public var GameStart:Boolean;
			
			public function get socket():Socket {
				return socket_;
			}
			
			private static var _instance:Connection = null;
			private static function CreateKey():void { }
			
			public function Connection(key:Function = null){
				if (key != CreateKey) {
					throw new Error("Creation of Conection without calling GetInstance is not valid");
				}
				createSocket();
			}
			
			public static function GetInstance():Connection {
				if (_instance == null) {
					_instance = new Connection(CreateKey);
				}
				return _instance;
			}
			
			public function WriteBytes(_bytes:ByteArray):void {
				socket_.writeBytes(_bytes);
				socket_.flush();
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
					var messageLength:int = bytes.readInt();
					Main.debug.print(("Length Message: " + messageLength) , Debug.Server_2);
					
					var messageType:int = bytes.readByte();
					Main.debug.print(("Message Type: " + messageType) , Debug.Server_2);
					
					switch(messageType) {
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
							
						case MessageType.PLAYER_DIRECTION_LIST:
							SetNewPlayerDir(bytes)
							break;
							
						case MessageType.PLAYER_IS_ADMIN:
							PlayerIsAdmin(bytes);
							break;
							
						case MessageType.PLAYER_SET_ID:
							playerSelf.id = bytes.readByte();
							break;
							
						case MessageType.PLAYER_LIST_UPDATE:
							PlayerListUpdate(bytes);
							break;
							
						case MessageType.GAME_START:
							GameStart = true;
							break;
							
						case MessageType.SERVER_ERROR:
							ServerError(bytes);
							break;
				   }
				}
			}
			
			//reading messages from the server
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
				playerSelf.name = name;
				
				var messageL:int = 5+playerName.length;
				messageData.writeInt(messageL);
				
				var messageType:int = MessageType.PLAYER_SET_NAME;
				messageData.writeByte(messageType);
				
				messageData.writeInt(playerName.length);
				
				BitUtil.stringToByteArray(playerName, messageData);
				
				socket_.writeBytes(messageData);
				socket_.flush();
			}
			
			private function PlayerList(_bytes:ByteArray):void {
				
				var listLength:int = _bytes.readInt();
				playerList = new Vector.<Player>();
				Main.debug.print(("[Player List] Length:" + listLength) , Debug.Server_2);
				
				var nameL:int;
				var id:int = 0;
				var dir:int = 0;
				for (var j:int = 0; j < listLength; j++) 
				{
					//gettting name
					var name:String = new String();
					id = _bytes.readByte(); // renable when bug is fixed
					nameL = _bytes.readInt();
					
					Main.debug.print("Name Length: " + nameL, Debug.Server_2);
					
					for (var i:int = 0; i < nameL; i++) 
					{
						var newLLetter:String = String.fromCharCode(_bytes.readUnsignedByte());
						name = name+newLLetter ;
					}
					
					playerList.push(new Player(name,dir,id));
					Main.debug.print(("-Player: " + name + " ID: " + id) , Debug.Server_2);
					Main.eventManager.dispatchEvent(new starling.events.Event( ScreenEvents.NEW_PLAYERLIST ));
				}
			}
			
			private function GetDirections(_bytes:ByteArray):void {
				var listLength:int = _bytes.readInt();
				var data:Vector.<Player> = new Vector.<Player>();
				
				var id:int;
				var dir:int;
				for (var i:int = 0; i < listLength; i++) 
				{
					id = _bytes.readByte();
					dir = _bytes.readByte();
					
					data.push(new Player("", dir, id));
				}
				
				for (var j:int = 0; j < playerList.length; j++) 
				{
					for (var k:int = 0; k < data.length; k++) 
					{
						if (playerList[j].id == data[k].id) {
							playerList[j].dir = data[k].dir;
							return;
						}
					}
				}
			}
			
			private function PlayerListUpdate(_bytes:ByteArray):void {
				var listLength:int = _bytes.readInt();
				var data:Vector.<Object> = new Vector.<Object>();
				
				var obj:Object;
				for (var i:int = 0; i < listLength; i++) 
				{
					obj = new Object();
					
					obj.id = _bytes.readByte();
					obj.ready = _bytes.readBoolean();
					
					data.push(obj);
				}
				
				for (var j:int = 0; j < data.length; j++) 
				{
					for (var k:int = 0; k < playerList.length; k++) 
					{
						if (data[j].id == playerList[k].id) {
							playerList[k].isReady = data[j].ready;
						}
					}
				}
			}
			
			private function PlayerIsAdmin(_bytes:ByteArray):void {
				idAdmin = _bytes.readByte();
				if (idAdmin == playerSelf.id){
					playerSelf.isAdmin = true;
				}
			}
			
			private function ServerError(_bytes:ByteArray):void {
				var stringlength:int = _bytes.readInt();
				var msg:String = new String();
				
				for (var i:int = 0; i < stringlength; i++) 
				{
					msg += String.fromCharCode(_bytes.readUnsignedByte);
				}
			}
			//sending to the server
			public function SetNewPlayerDir(_bytes:ByteArray):void {
				var dir:int = _bytes.readByte();
				
			}
			
			public function PlayerReady(value:Boolean = false):void {
				//send bool player ready to server
				
				playerSelf.isReady = value;
				
				var messageLength:int = 6;
				
				var bytes:ByteArray = new ByteArray();
				bytes.endian = Endian.LITTLE_ENDIAN;
				
				bytes.writeInt(messageLength);
				bytes.writeByte(MessageType.PLAYER_READY);
				
				if (value)
				{
					bytes.writeByte(1);
				}
				else
				{
					bytes.writeByte(0);
				}
				
				WriteBytes(bytes);
			}
			
			public function AdminStart(value:Boolean = false):void {
			var messageLength:int = 5;
			
			var bytes:ByteArray = new ByteArray();
			bytes.endian = Endian.LITTLE_ENDIAN;
			
			bytes.writeInt(messageLength);
			bytes.writeByte(MessageType.ADMIN_START);
			
			WriteBytes(bytes);
		}
	}
}