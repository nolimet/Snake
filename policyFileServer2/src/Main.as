package {
	import flash.display.Sprite;
	import flash.net.ServerSocket;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.Socket;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	public class Main extends Sprite {
		private var sock:ServerSocket;
		private var texts:Vector.<TextField> = new Vector.<TextField>();
		private var date:Date = new Date();
		
		public function Main():void {
			sock = new ServerSocket();
			sock.addEventListener(ServerSocketConnectEvent.CONNECT, OnConnect);
			sock.bind(843);
			sock.listen();
			
			if (!sock.listening || !sock.bound){
				Print("Cannot start");
			}else {
				Print("started");
			}
		}
		
		private function UpdatePrintList():void {
			for (var i:int = texts.length-1; i > -1; i--) {
				trace(i);
				texts[i].y -= 20;
				if (texts[i].y < 0) {
					removeChild(texts[i]);
					texts.splice(i, 1);
				}
			}
		}
		
		private function Print(text:String):void {
			date = new Date();
			
			var nexText:TextField = new TextField();
			nexText.textColor = 0xffffff;
			nexText.text = "["+date.toLocaleTimeString()+":"+date.getMilliseconds()+"]"+text;
			nexText.y = stage.stageHeight;
			nexText.width = stage.stageWidth;
			addChild(nexText);
			texts.push(nexText);
			UpdatePrintList();
		}
		
		private function OnConnect(e:ServerSocketConnectEvent):void {
			Print("new connect");
			e.socket.writeUTFBytes('<cross-domain-policy><allow-access-from domain="*" to-ports="11100" /></cross-domain-policy>');
			e.socket.writeByte(0);
			e.socket.flush();
			e.socket.close();
		}
	}
}