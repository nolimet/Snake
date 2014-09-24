package  
{
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Label;
	import feathers.data.ListCollection;
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
	import types.NetEvent;
	import utils.debug.Debug;
	//import flash.system.System.sec
	//import aeon
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	
	public class Main extends Sprite 
	{
		protected var button:Button;
		private var startGroup:ButtonGroup;
		
		
		private var con:Conection;
		public static var debug:Debug;
		
		public function Main() {
			
			debug = new Debug(this);
			debug.touchable = false;
			
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage():void {
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStage);
			
			BuildMenu();
			con = Conection.GetInstance();
		}
		
		private function BuildMenu():void {
			new AeonDesktopTheme();
			startGroup = new ButtonGroup();
			this.addChild(startGroup);
			
			startGroup.dataProvider = new ListCollection(
			[
				{ label: "Connect", triggered: OnButtonConnect },
			]);
		}
		
		//{ button functions
		
		private function OnButtonConnect( event:starling.events.Event ):void
		{
			trace("button Connect Pressed");
			//con.Ping();
			
			con.Connect();
			con.socket.addEventListener(Event.CONNECT,OnConnect);
		}
		
		private function OnButtonPing( event:starling.events.Event ):void
		{
			trace("button Ping Pressed");
			con.Ping();
		}
		
		private function OnButtonPlay( event:starling.events.Event ):void
		{
			trace("StartGame");
		}
		
		private function OnButtonDisconnect( event:starling.events.Event ):void
		{
			con.DisConnect();
			trace("Disconnect");
		}
		//} button functions
		
		private function OnConnect(e:Event):void {
			con.socket.removeEventListener(Event.CONNECT,OnConnect);
			con.socket.addEventListener(Event.CLOSE, onClose);
			startGroup.dataProvider = new ListCollection(
			[
				{ label: "Ping", triggered: OnButtonPing },
				{ label: "Play", triggered: OnButtonPlay },
				{ label: "Disconnect", triggered: OnButtonDisconnect },
			]);
		}
		private function onClose(e:Event):void {
			con.socket.addEventListener(Event.CONNECT,OnConnect);
			con.socket.removeEventListener(Event.CLOSE, onClose);
			startGroup.dataProvider = new ListCollection(
			[
				{ label: "Connect", triggered: OnButtonConnect },
			]);
		}
		
	}

}