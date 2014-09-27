package snake.menu.screens 
{
	import feathers.controls.ButtonGroup;
	import feathers.controls.Screen;
	import feathers.data.ListCollection;
	import starling.display.Sprite;
	import starling.events.Event;
	import snake.menu.ScreenEvents;
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	public class MenuConnected extends Screen
	{
		private var startGroup:ButtonGroup;
		private var menuConected:ListCollection = new ListCollection([
			{ label: "Ping", triggered: OnButtonPing },
			{ label: "Play", triggered: OnButtonPlay },
			{ label: "Disconnect", triggered: OnButtonDisconnect },
		]);
		public function MenuConnected() 
		{
			
		}
		
		override protected function draw():void {}
		
		override protected function initialize():void {
			startGroup = new ButtonGroup();
			this.addChild(startGroup);
			startGroup.dataProvider = menuConected;
		}
		
		private function OnButtonPing(e:Event):void { 		dispatchEventWith( ScreenEvents.PING ) };
		private function OnButtonPlay(e:Event):void { 		dispatchEventWith( ScreenEvents.PLAY ) };
		private function OnButtonDisconnect(e:Event):void {	dispatchEventWith( ScreenEvents.DISCONNECT ) };
	}

}