package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Graphics;
	import server.Connection;
	
	/**
	 * ...
	 * @author Tom Verkerk
	 */
	public class Main extends Sprite 
	{
		private var Player:Block = new Block();
		private var Player2:Block = new Block();
		
		private var connect:Connection;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			connect = new Connection();
			addChild(connect);
			Player.PosX = 5;
			Player.PosY = 50;
			Player.Update();
			addChild(Player);
			
			Player2.PosX = 200;
			Player2.PosY = 50;
			Player2.Update();
			addChild(Player2);
		}
	}
}