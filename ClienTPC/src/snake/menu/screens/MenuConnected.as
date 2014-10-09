package snake.menu.screens 
{
	import feathers.controls.ButtonGroup;
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.controls.Screen;
	import feathers.data.ListCollection;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import snake.net.Connection
	import snake.net.Player;
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
		private var playerList:List;
		private var con:Connection;
		private var playerListCollection:ListCollection;
		
		private var menuConected:ListCollection ;
		
		private var UIupdaterTi:Timer;
		private var UIInitTi:Timer;
		
		public function MenuConnected() 
		{	
			con = Connection.GetInstance();
			
			if (con.playerSelf.isAdmin)
			{
				menuConected = new ListCollection([
			{ label: "Ping", triggered: OnButtonPing },
			{ label: "Start Game", triggered: OnButtonPlay },
			{ label: "Ready", triggered: OnButtonReady },
			{ label: "Disconnect", triggered: OnButtonDisconnect }
			]);
			}
			else {
				menuConected = new ListCollection([
				{ label: "Ping", triggered: OnButtonPing },
				{ label: "Ready", triggered: OnButtonReady },
				{ label: "Disconnect", triggered: OnButtonDisconnect }]);
			}
			
			UIInitTi = new Timer(150, 1);
			UIInitTi.addEventListener(TimerEvent.TIMER, UIinit, false, 0, true);
			UIupdaterTi = new Timer(200, 0);
			UIupdaterTi.addEventListener(TimerEvent.TIMER, UIupdater, false, 0, true);
			
			UIInitTi.start();
			UIupdaterTi.start();
		}
		
		private function UIupdater(e:TimerEvent):void 
		{
			var items:Array = [];
			var player:Player;
			var showingTxt:String;
			
			for(var i:int = 0; i < con.playerList.length; i++)
			{
				
				player = con.playerList[i];
				if (player.id == con.playerSelf.id) {
					player = con.playerSelf;
				}
				showingTxt = player.name;
				
				if (player.isReady){
					showingTxt += "(Ready)";
				}
				else {
					showingTxt += "(Not Ready)";
				}
				var item:Object = {text: showingTxt};
				items[i] = item;
				//items.push(item);
			}
		//	items.fixed = true;
			//trace(showingTxt);
			playerList.dataProvider = new ListCollection(items);
		}
		
		private function UIinit(e:TimerEvent):void 
		{

		}
		
		
		
		override protected function draw():void {

		}
		
		override protected function initialize():void {
			con = Connection.GetInstance();
			BuildPlayerList();
			
			
			startGroup = new ButtonGroup();
			addChild(startGroup);
			startGroup.dataProvider = menuConected;
			
			addEventListener(ScreenEvents.NEW_PLAYERLIST, newPlayerList);
		}
		
		private function BuildPlayerList():void {
			if (playerList != null) {
				removeChild(playerList);
			}
			playerList = new List();
			var items:Array = [];
			for(var i:int = 0; i < con.playerList.length; i++)
			{
				trace("---------"+con.playerList[i].name);
				var item:Object = {text: "n:"+con.playerList[i].name};
				items[i] = item;
			}
			items.fixed = true;
			
			playerList.dataProvider = new ListCollection(items);
			playerList.width = 250;
			playerList.x = 250;
			playerList.y = 50;
			playerList.height = 700;
			
			playerList.isSelectable = false;
			playerList.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				renderer.isQuickHitAreaEnabled = true;

				renderer.labelField = "text";
				return renderer;
			};
			addChild(playerList);
		}
		
		private function OnButtonPing(e:Event):void { 		dispatchEventWith( ScreenEvents.PING ) };
		
		private function newPlayerList(e:Event):void { 	
			BuildPlayerList();
		};
		private function OnButtonPlay(e:Event):void { 		dispatchEventWith( ScreenEvents.PLAY ) };
		private function OnButtonDisconnect(e:Event):void {	dispatchEventWith( ScreenEvents.DISCONNECT ) };
		private function OnButtonReady(e:Event):void {	
			con.PlayerReady(!con.playerSelf.isReady);
		}
	}

}