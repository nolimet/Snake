package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Stage;
	import flash.display.Graphics;
	import flash.events.KeyboardEvent;
	import flash.display.StageScaleMode;
	
	/**
	 * ...
	 * @author Tom Verkerk
	 */
		
	[SWF(backgroundcolor = 0x000000, width = "792", height = "792", frameRate = "30")]
	 
	public class Main extends Sprite 
	{
		private var Player:Block;
		private var Player2:Block;
		
		private var pickUp:PickUp;
		
		private var timer:int;
		private var moveTime:int = 5;
		private var randomX:Number;
		private var randomY:Number;
		private var reset:Boolean = false;
		private var switchone:Boolean = true;
		private var index:int = 0;
		
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
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			startGame();
		}
		
		private function startGame():void {
			Player = new Block();
			Player.DrawSnake(11, 11, 8);
			addChild(Player);
			
			Player2 = new Block();
			Player2.DrawSnake(11,55,5);
			addChild(Player2);
			
			addPickUp();
			
			stage.addEventListener(Event.ENTER_FRAME, Update);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, Control);
		}
		
		private function Update(e:Event):void {
			timer += 1;
			if (timer >= moveTime){
				if (reset == false) {
					Player.moveSnake();
					Player2.moveSnake();
					player1press = false;
					player2press = false;
					checkColl();
					timer = 0;
				}
			}
		}
		
		public function Resett():void {
			removeChild(Player);
			removeChild(Player2);
			removeChild(pickUp);
			startGame();
		}
		
		private function addPickUp():void {
			pickUp = new PickUp;
			addChild(pickUp);
			randomX = Math.floor(Math.random() * 72);
			randomX *= 11;
			randomY = Math.floor(Math.random() * 72);
			randomY *= 11;
			if (randomX == 0 && randomY == 0 ||
				randomX == 792 && randomY == 0 ||
				randomX == 0 && randomY == 792 ||
				randomX == 792 && randomY == 792) {
				addPickUp();
			}
			else {
				pickUp.addPickUp(randomX, randomY);
			}
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
			for (var i:int = 0; i < Player.squares.length; i++) {
				if (Player2.square.hitTestObject(Player.squares[i])) {
					trace("Player2hit");
					Resett();
				}
				if (Player.square.hitTestObject(Player.squares[i]) && i < Player.squares.length - 2) {
					trace("Player1hitself");
					Resett();
				}
			}
			for (var j:int = 0; j < Player2.squares.length; j++) {
				if (Player.square.hitTestObject(Player2.squares[j])) {
					trace("Player1hit");
					Resett();
				}
				if (Player2.square.hitTestObject(Player2.squares[j]) && j < Player2.squares.length - 2) {
					trace("Player2hitself");
					Resett();
				}
			}
			if (Player.lastPos.x < 0 || Player.lastPos.x >= 792 ||
			    Player.lastPos.y < 0 || Player.lastPos.y > 792) {
				Resett();
			}
			if (Player2.lastPos.x < 0 || Player2.lastPos.x >= 792 ||
			    Player2.lastPos.y < 0 || Player2.lastPos.y > 792) {
				Resett();
			}
		}
	}
}