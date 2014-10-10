package snake.game
{
	import starling.display.Sprite;
	import starling.display.Shape;
		
	/**
	 * ...
	 * @author Tom Verkerk
	 */
	public class PickUp extends Shape
	{
		public function addPickUp(PosX:int, posY:int):void
		{
			this.graphics.beginFill(0x000000);
			this.graphics.drawRect(PosX, posY, 10, 10);
			this.graphics.endFill();
		}
	}
}