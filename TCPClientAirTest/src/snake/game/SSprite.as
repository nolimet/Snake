package snake.game 
{
	import flash.display.Shape;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	public class SSprite extends Shape
	{
		
		public function SSprite() 
		{
			
		}
		
		public function hitTestObject(sprite:SSprite):Boolean {
			this.getBounds(this.parent).intersects(sprite.getBounds(sprite.parent))
		}
	}

}