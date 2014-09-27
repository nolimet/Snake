package snake.menu.screens 
{
	import feathers.controls.ButtonGroup;
	import feathers.controls.Screen;
	import feathers.controls.TextInput;
	import feathers.data.ListCollection;
	import snake.utils.debug.Debug;
	import starling.display.Sprite;
	import snake.Main;
	import starling.events.Event;
	import snake.menu.ScreenEvents;
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	public class MenuStart extends Screen
	{
		
		private var startGroup:ButtonGroup;
		private var menuStart:ListCollection = new ListCollection([
			{ label: "Connect", triggered: OnButtonConnect },
		]);
		
		private var namefield:TextInput;
		
		public function MenuStart() {}
		
		override protected function draw():void {}
		
		override protected function initialize():void {
			startGroup = new ButtonGroup();
			this.addChild(startGroup);
			startGroup.dataProvider = menuStart;
			
			namefield = new TextInput();
			addChild(namefield);
			namefield.x = 300;
		}
		
		private function OnButtonConnect(e:Event):void {
			if (namefield.text.length > 2) {
				var data:Object = new Object();
				data.name = namefield.text;
				dispatchEventWith( ScreenEvents.CONNECT,false,data );
			}else {
				Main.debug.print("[MenuStart]: please enter a name minimum length 3", Debug.Server_2);
			}
		}
		
	}

}