package types 
{
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
		
		//server to client
		public static const PLAYER_LIST:int = 100;
		
	}
}