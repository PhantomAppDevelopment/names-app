package
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	public class FavoritesManager
	{
		
		/**  
		 * Adds an item to the Favorites file.
		 *  
		 * @param item An Object containing a name and count values. 
		 */		
		public static function addToFavorites(item:Object):void
		{
			var favoritesArray:Array = new Array();	
			var file:File = File.applicationStorageDirectory.resolvePath("favorites.data");
			var fileStream:FileStream;
			
			//First, we check if the favorites.data file exists, if not we create it and immediatelly add the name.
			
			if(file.exists)
			{
				fileStream = new FileStream();
				fileStream.open(file, FileMode.READ);
				favoritesArray = fileStream.readObject();
				fileStream.close();
				
				//If the file exists but it's empty we immediatelly add the name.
				
				if(file.size == 0){
										
					favoritesArray.push(item);
					
					fileStream = new FileStream();
					fileStream.open(file, FileMode.WRITE);
					fileStream.writeObject(favoritesArray);
					fileStream.close();					
				} else {
					
					if(checkIfFavoriteExists(item.name, favoritesArray)){
						//Do nothing if name is already bookmarked
					} else {
						favoritesArray.push(item);
						
						fileStream = new FileStream();
						fileStream.open(file, FileMode.WRITE);
						fileStream.writeObject(favoritesArray);
						fileStream.close();					
					}	
				}										
			} else {
				favoritesArray.push(item);
				
				fileStream = new FileStream();
				fileStream.open(file, FileMode.WRITE);
				fileStream.writeObject(favoritesArray);
				fileStream.close();
			}
		}
		
		private static function checkIfFavoriteExists(currentName:String, arr:Array):Boolean
		{
			var result:Boolean;

			for each(var item:Object in arr)
			{
				if(item.name == currentName){
					result = true;
					return result;

				} else {
					result = false;
				}
			}			
			
			return result;
		}
		
		/**  
		 * Removes an item from the Favorites file.
		 *  
		 * @param item An Object containing an index and a data object containing a name and count values. 
		 */	
		public static function deleteFromFavorites(item:Object):void
		{
			var tempArray:Array = new Array();
			var file:File = File.applicationStorageDirectory.resolvePath("favorites.data");
			var fileStream:FileStream;
			
			fileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			tempArray = fileStream.readObject();
			fileStream.close();
			
			tempArray.removeAt(item.index);
			
			fileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeObject(tempArray);
			fileStream.close();
		}
		
	}
}