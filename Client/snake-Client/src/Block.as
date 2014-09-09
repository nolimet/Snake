package  
{
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	
	/**
	 * ...
	 * @author Tom Verkerk
	 */
	public class Block extends Sprite
	{
		private var square:Sprite = new Sprite();
		
		public var PosX:int;
		public var PosY:int;
		 
		public function Update():void 
		{
			square.graphics.beginFill(0x000000);
			square.graphics.drawRect(PosX,PosY,10,10);
			square.graphics.endFill();
			addChild(square);
		}
	}
}