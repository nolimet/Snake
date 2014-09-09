package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Graphics;
	
	/**
	 * ...
	 * @author Tom Verkerk
	 */
	public class Main extends Sprite 
	{
		private var Player:Block = new Block();
		private var Player2:Block = new Block();
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
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