package snake {
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	public class BitUtil 
	{
		static var rByteArray:ByteArray;
		
		static public function ByteArrayToInt(byteArray:ByteArray):int{
			if (byteArray.length != 4) {
				throw new Error("[BitUtil][ByteArrayToInt]Byte array does not contain 4 bytes");
			}
			return byteArray[0] +(byteArray[1] << 8) + (byteArray[2] << 16) + (byteArray[3] << 24);
		}
		
		static public function IntToByteArray(Integer:int):ByteArray{
			rByteArray = new ByteArray();
			rByteArray[0] = (Integer >> 0) & 0xFF;
			rByteArray[1] = (Integer >> 8) & 0xFF;
			rByteArray[2] = (Integer >> 16) & 0xFF;
			rByteArray[3] = (Integer >>> 24);
			return rByteArray;
		}
	}

}