package snake {
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Label;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.data.ListCollection;
	import feathers.themes.AeonDesktopTheme;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import snake.menu.screens.*;
	import snake.net.Conection;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.text.TextField;
	import flash.net.Socket;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import snake.utils.debug.Debug;
	import snake.menu.ScreenID;
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
		
		private var navigator:ScreenNavigator;
		
		public function Main() {
			
			debug = new Debug(this);
			debug.touchable = false;
			
			navigator = new ScreenNavigator();
			addChild( navigator );
			navigator.addScreen( ScreenID.MAIN_MENU, new ScreenNavigatorItem( MenuConnected , {
				disconnectEvent:OnButtonDisconnect,
				playEvent:OnButtonPlay,
				pingEvent:OnButtonPing
			}));
			navigator.addScreen( ScreenID.GAME_SCREEN, new ScreenNavigatorItem( GameScreen , {
				back:ScreenID.MAIN_MENU
			}));
			navigator.addScreen( ScreenID.CONNECT_MENU, new ScreenNavigatorItem( MenuStart , {
				connectEvent: OnButtonConnect
			}));
			navigator.showScreen( ScreenID.CONNECT_MENU );
			
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage():void {
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStage);
			
			new AeonDesktopTheme();
			con = Conection.GetInstance();
		}
		
		//{ button functions
		
		private function OnButtonConnect( event:starling.events.Event ):void
		{
			trace("button Connect Pressed Name:"+event.data.name);
			//con.Ping();
			
			con.Connect(event.data.name);
			con.socket.addEventListener(Event.CONNECT,OnConnect);
		}
		
		private function OnButtonPing( event:starling.events.Event ):void
		{
			trace("button Ping Pressed");
			con.Ping();
		}
		
		private function OnButtonPlay( event:starling.events.Event ):void
		{
			trace("ToGameScreen");
			navigator.showScreen( ScreenID.GAME_SCREEN );
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
			navigator.showScreen( ScreenID.MAIN_MENU );
			
		}
		private function onClose(e:Event):void {
			con.socket.addEventListener(Event.CONNECT,OnConnect);
			con.socket.removeEventListener(Event.CLOSE, onClose);
			navigator.showScreen( ScreenID.CONNECT_MENU );
		}
		
	}

}