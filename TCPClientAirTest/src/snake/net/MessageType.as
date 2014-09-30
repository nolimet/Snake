package snake.net {
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	public class MessageType 
	{
		public static const PING:int = 20;
		public static const PING_BACK:int = 21;
		public static const HELLO:int = 22;
		
		//client to server
		public static const PLAYER_SET_NAME:int = 30;
		public static const PLAYER_SET_NEW_DIRECTION:int = 31;
		public static const PLAYER_DISCONNECT:int = 32
		
		
		//server to client
		public static const PLAYER_LIST:int = 100;
		public static const PLAYER_DIRECTION_LIST:int = 101;
		
	}
}