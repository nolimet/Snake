package  
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
	//import flash.system.System.sec
	//import aeon
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	
	public class Main extends Sprite 
	{
		protected var button:Button;
		
		private var con:Conection;
		public static var debug:Debug;
		
		public function Main() {
			
			debug = new Debug();
			debug.touchable = false;
			
			con = Conection.GetInstance();
			
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage():void {
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStage);
			new AeonDesktopTheme();
			this.button = new Button();
			this.button.label = "Click Me";
			debug.touchable = false;
			this.addChild(debug);
			this.addChild( button );
			this.button.addEventListener( starling.events.Event.TRIGGERED, button_triggeredHandler );
			
			con.createSocket();
		}
		
		private function button_triggeredHandler( event:starling.events.Event ):void
		{
			trace("buttonPressed");
			con.Ping();
		}

		
	}

}