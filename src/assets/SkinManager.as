package assets
{
	import mx.styles.IStyleManager2;
	
	public class SkinManager
	{
		/**
		 * Gets a named asset from the provided style manager.
		 * 
		 * @param styleManager The <code>IStyleManager2</code> to get the asset from.
		 * @param assetName The name of the asset.
		 * @return A <code>Class</code> representing the loaded asset.
		 */
		public static function getSkinAsset( styleManager:IStyleManager2, assetName:String ):*
		{
			return styleManager.getStyleDeclaration( ".skinDeclaration" ).getStyle( assetName );
		}
		
		/**
		 * Sets a named assets to the provided style manager.
		 * 
		 * @param styleManager The <code>IStyleManager2</code> to get the asset from.
		 * @param assetName The name of the asset.
		 * @param asset The value to set the style to.
		 */
		public static function setSkinAsset( styleManager:IStyleManager2, assetName:String, asset:* ):void
		{
			styleManager.getStyleDeclaration( ".skinDeclaration" ).setStyle( assetName, asset );
		}
		
		public function SkinManager()
		{
			
		}
	}
}