package starling.interfaces
{
	public interface IAssetManagerHandler
	{
		/** Handles the 'start' event of the assetManager */
		function onLoadAssetsStarted():void;

		/** Handles the 'progress' event of the assetManager */
		function onLoadAssetsProgress( progress:Number ):void;

		/** Handles the 'error' event of the assetManager */
		function onLoadAssetsError( errorCode:int, error:String ):void;

		/** Handles the 'loaded' event of the assetManager */
		function onLoadAssetsComplete():void;
	}
}