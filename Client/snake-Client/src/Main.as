package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Graphics;
	import flash.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author Tom Verkerk
	 */
		
	[SWF(width = "792", height = "792", frameRate = "30")]
	 
	public class Main extends Sprite 
	{
		private var Player:Block = new Block();
		private var Player2:Block = new Block();
		
		private var pickUp:PickUp;
		
		private var timer:int;
		private var moveTime:int = 5;
		private var randomX:Number;
		private var randomY:Number;
		
		private var player1press:Boolean = false;
		private var player2press:Boolean = false;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			startGame();
		}
		
		private function startGame():void{
			Player.DrawSnake(0, 0, 8);
			addChild(Player);
			
			Player2.DrawSnake(0,55,5);
			addChild(Player2);
			
			addPickUp();
			
			stage.addEventListener(Event.ENTER_FRAME, Update);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, Control);
		}
		
		private function Update(e:Event):void {
			timer += 1;
			if (timer >= moveTime) {
				Player.moveSnake();
				Player2.moveSnake();
				player1press = false;
				player2press = false;
				checkColl();
				timer = 0;
			}
		}
		
		private function addPickUp():void {
			pickUp = new PickUp;
			addChild(pickUp);
			randomX = Math.floor(Math.random() * 72);
			randomX *= 11;
			randomY = Math.floor(Math.random() * 72);
			randomY *= 11;
			pickUp.addPickUp(randomX, randomY);
		}
		
		private function Control(e:KeyboardEvent):void {
			if(player1press == false){
				if (e.keyCode == 87 && Player.moveDir != 3) {//w
					Player.moveDir = 1;
				}
				if (e.keyCode == 68 && Player.moveDir != 4) {//d
					Player.moveDir = 2;
				}
				if (e.keyCode == 83 && Player.moveDir != 1) {//s
					Player.moveDir = 3;
				}
				if (e.keyCode == 65 && Player.moveDir != 2) {//a
					Player.moveDir = 4;
				}
				player1press = true;
			}
			
			if(player2press == false){
				if (e.keyCode == 38 && Player2.moveDir != 3) {//up
					Player2.moveDir = 1;
				}
				if (e.keyCode == 39 && Player2.moveDir != 4) {//right
					Player2.moveDir = 2;
				}
				if (e.keyCode == 40 && Player2.moveDir != 1) {//down
					Player2.moveDir = 3;
				}
				if (e.keyCode == 37 && Player2.moveDir != 2) {//left
					Player2.moveDir = 4;
				}
				player2press = true;
			}
		}
		
		private function checkColl():void {
			for (var i:int = 0; i < Player.squares.length; i++) {
				if (Player2.square.hitTestObject(Player.squares[i])) {
					trace("Player2hit");
				}
			}
			for (var j:int = 0; j < Player2.squares.length; j++) {
				if (Player.square.hitTestObject(Player2.squares[j])) {
					trace("Player1hit");
				}
			}
			if (Player.square.hitTestObject(pickUp)) {
				removeChild(pickUp);
				addPickUp();
				Player.addBlock();
			}
			else if (Player2.square.hitTestObject(pickUp)) {
				removeChild(pickUp);
				addPickUp();
				Player2.addBlock();
			}
		}
	}
}