package starling.assets
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import interfaces.IDisposable;

	import mx.core.ClassFactory;

	import objects.FLVByteArray;
	import objects.FLVByteArrayTag;

	import starling.interfaces.IAssetManagerHandler;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	import utils.DebugHelper;

	/**
	 * Provides a centralized class to manage:
	 * <ul>
	 * <li>Loadding TextureAlases, Textures and Sounds from URL sources.</li>
	 * <li>Converting embedded assets to TextureAtlases, Textures and Sounds.</li>
	 * <li>Properly disposing of TextureAtlases, Textures and Sounds to recover resources.</li>
	 * </ul>
	 */
	public class AssetManager implements IDisposable
	{
		public static const ASSET_TYPE_ATLAS:String = "Atlas";
		public static const ASSET_TYPE_TEXTURE:String = "Texture";
		public static const ASSET_TYPE_SOUND:String = "Sound";
		public static const ASSET_TYPE_FLV:String = "FLV";
		public static const ASSET_TYPE_SWF:String = "SWF";
		public static const ASSET_TYPE_PS:String = "PS";

		// Logging
		private static const logger:DebugHelper = new DebugHelper( AssetManager );

		private var _assetBasePath:String;
		private var _assets:Array;
		private var _flvAnimations:Dictionary;
		private var _swfAnimations:Dictionary;
		private var _atlases:Dictionary;
		private var _textures:Dictionary;
		private var _sounds:Dictionary;
		private var _particles:Dictionary;
		private var _handler:IAssetManagerHandler;
		private var _currentAssetType:String;
		private var _currentIndex:int = 0;

		private var _loader:Loader;
		private var _xml:XML;
		private var _xmlLoader:URLLoader;
		private var _sndLoader:Sound;
		private var _flvLoader:URLLoader;
		private var _swfLoader:URLLoader;

		/**
		 * Constructs a new AtlasManager.
		 *
		 * @param assetBasePath The base URL to be used when loading assets.
		 * @param handler The handler that provides callback methods for when assets are finished loading.
		 */
		public function AssetManager( assetBasePath:String, handler:IAssetManagerHandler )
		{
			// Log Activity
			logger.pushContext( "constructor", arguments );

			_assetBasePath = assetBasePath;
			_handler = handler;

			_assets = [];
			_flvAnimations = new Dictionary();
			_swfAnimations = new Dictionary();
			_atlases = new Dictionary();
			_textures = new Dictionary();
			_sounds = new Dictionary();
			_particles = new Dictionary();

			// Clear Context
			logger.popContext();
		}

		/**
		 * Adds information about an asset to be loaded from a URL.
		 *
		 * @param The type of asset.
		 * @param The name of the asset to be loaded. This will be used to identify the asset later when retrieving it,
		 * as well as when consturcting the URL to load the asset from. You only need to supply the base name, not the path
		 * or extension.
		 */
		public function addAssetToLoad( assetType:String, assetName:String ):void
		{
			_assets.push( { type: assetType, name: assetName, bmp: null, xml: null, atlas: null, texture: null, snd: null, flv: null, swf: null, loaded: false } );
		}

		/**
		 * Adds an atlas to the assetManager that is built off of embedded assets.
		 *
		 * @param atlasName The name of the atlas.
		 * @param bitmapClass The class which holds the embedded PNG.
		 * @param xmlClass The class which holds the embedded XML.
		 */
		public function addLocalAtlas( atlasName:String, bitmapClass:Class, xmlClass:Class ):void
		{
			_atlases[atlasName] = new TextureAtlas( Texture.fromBitmap( new bitmapClass() ), new XML( xmlClass ) );
		}

		/**
		 * Adds a texture to the assetManager that is built off of embedded assets.
		 *
		 * @param textureName The name of the texture.
		 * @param bitmapClass The class which holds the embedded PNG.
		 */
		public function addLocalTexture( textureName:String, bitmapClass:Class ):void
		{
			_textures[textureName] = Texture.fromBitmap( new bitmapClass() );
		}

		/**
		 * Adds a sound to the assetManager that is built off of embedded assets.
		 *
		 * @param soundName The name of the sound.
		 * @param soundClass The class which holds the embedded MP3.
		 */
		public function addLocalSound( soundName:String, soundClass:Class ):void
		{
			_sounds[soundName] = new soundClass() as Sound;
		}

		/**
		 * Adds an FLV to the assetManager that is built off of embedded assets.
		 *
		 * @param flvName The name of the FLV.
		 * @param bytes The bytes which holds the embedded FLV.
		 */
		public function addLocalFLV( flvName:String, bytes:ByteArray ):void
		{
			_flvAnimations[flvName] = new FLVByteArray( bytes );
		}

		/**
		 * Adds a SWF to the assetManager that is built off of embedded assets.
		 *
		 * @param swfName The name of the SWF.
		 * @param bytes The bytes which holds the embedded SWF.
		 */
		public function addLocalSWF( swfName:String, bytes:ByteArray ):void
		{
			_swfAnimations[swfName] = bytes;
		}

		/**
		 * Adds a render texture to the assetManager.
		 *
		 * @param textureName The name of the texture.
		 * @param renderTexture The render texture instance.
		 */
		public function addRenderTexture( textureName:String, renderTexture:RenderTexture ):void
		{
			_textures[textureName] = renderTexture;
		}

		/**
		 * Loads any queued assets and builds the corresponding TextureAtlas, Texture or Sound once they're loaded.
		 */
		public function loadAssets():void
		{
			// Log Activity
			logger.pushContext( "loadAssets", arguments );
			_handler.onLoadAssetsStarted();

			loadAssetByIndex( 0 );

			// Clear Context
			logger.popContext();
		}

		/**
		 * Fetches a queued asset request from the queue and loads it.
		 */
		private function loadAssetByIndex( index:int ):void
		{
			// Log Activity
			logger.pushContext( "loadAssetByIndex", arguments );

			_currentIndex = index;

			if( _currentIndex >= _assets.length )
			{
				_handler.onLoadAssetsComplete();

				// Clear Context
				logger.popContext();
				return;
			}
			else
			{
				var assetType:String = _assets[_currentIndex].type;
				var assetName:String = _assets[_currentIndex].name;

				if( assetType == ASSET_TYPE_ATLAS || assetType == ASSET_TYPE_TEXTURE )
				{
					_loader = new Loader();
					_loader.uncaughtErrorEvents.addEventListener( UncaughtErrorEvent.UNCAUGHT_ERROR, onLoaderError );
					_loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onLoaderProgress );
					_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoaderComplete );
					_loader.load( new URLRequest( _assetBasePath + ( assetType == ASSET_TYPE_ATLAS ? "atlases/" : "images/" ) + assetName + ".png" ) );

					if( assetType == ASSET_TYPE_ATLAS )
					{
						_xmlLoader = new URLLoader();
						_xmlLoader.addEventListener( IOErrorEvent.IO_ERROR, onXMLLoaderIOError );
						_xmlLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onXMLLoaderSecurityError );
						_xmlLoader.addEventListener( ProgressEvent.PROGRESS, onXMLLoaderProgress );
						_xmlLoader.addEventListener( Event.COMPLETE, onXMLLoaderComplete );
						_xmlLoader.load( new URLRequest( _assetBasePath + "atlases/" + assetName + ".xml" ) );
					}
				}
				else if( assetType == ASSET_TYPE_PS )
				{
					_loader = new Loader();
					_loader.uncaughtErrorEvents.addEventListener( UncaughtErrorEvent.UNCAUGHT_ERROR, onLoaderError );
					_loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onLoaderProgress );
					_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoaderComplete );
					_loader.load( new URLRequest( _assetBasePath + "particles/" + assetName + ".png" ) );

					_xmlLoader = new URLLoader();
					_xmlLoader.addEventListener( IOErrorEvent.IO_ERROR, onXMLLoaderIOError );
					_xmlLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onXMLLoaderSecurityError );
					_xmlLoader.addEventListener( ProgressEvent.PROGRESS, onXMLLoaderProgress );
					_xmlLoader.addEventListener( Event.COMPLETE, onXMLLoaderComplete );
					_xmlLoader.load( new URLRequest( _assetBasePath + "particles/" + assetName + ".xml" ) );
				}
				else if( assetType == ASSET_TYPE_FLV )
				{
					_flvLoader = new URLLoader();
					_flvLoader.dataFormat = URLLoaderDataFormat.BINARY;
					_flvLoader.addEventListener( IOErrorEvent.IO_ERROR, onFLVLoaderIOError );
					_flvLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onFLVLoaderSecurityError );
					_flvLoader.addEventListener( ProgressEvent.PROGRESS, onFLVLoaderProgress );
					_flvLoader.addEventListener( Event.COMPLETE, onFLVLoaderComplete );
					_flvLoader.load( new URLRequest( _assetBasePath + "animations/" + assetName + ".flv" ) );
				}
				else if( assetType == ASSET_TYPE_SWF )
				{
					_swfLoader = new URLLoader();
					_swfLoader.dataFormat = URLLoaderDataFormat.BINARY;
					_swfLoader.addEventListener( IOErrorEvent.IO_ERROR, onSWFLoaderIOError );
					_swfLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSWFLoaderSecurityError );
					_swfLoader.addEventListener( ProgressEvent.PROGRESS, onSWFLoaderProgress );
					_swfLoader.addEventListener( Event.COMPLETE, onSWFLoaderComplete );
					_swfLoader.load( new URLRequest( _assetBasePath + "animations/" + assetName + ".swf" ) );
				}
				else if( assetType == ASSET_TYPE_SOUND )
				{
					_sndLoader = new Sound();
					_sndLoader.addEventListener( IOErrorEvent.IO_ERROR, onSndLoaderIOError );
					_sndLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSndLoaderSecurityError );
					_sndLoader.addEventListener( ProgressEvent.PROGRESS, onSndLoaderProgress );
					_sndLoader.addEventListener( Event.COMPLETE, onSndLoaderComplete );
					_sndLoader.load( new URLRequest( _assetBasePath + "sounds/" + assetName + ".mp3" ) ) ;
				}
			}

			// Clear Context
			logger.popContext();
		}

		/**
		 * Handles any error events from the <code>_loader</code> object.
		 */
		private function onLoaderError( event:UncaughtErrorEvent ):void
		{
			// Log Activity
			logger.pushContext( "onLoaderError" ).error.apply( null, arguments );
			cleanupLoader();

			if( event.error is Error )
			{
				var err:Error = event.error as Error;
				_handler.onLoadAssetsError( err.errorID, err.message );
			}
			else if( event.error is ErrorEvent )
			{
				var errEv:ErrorEvent = event.error as ErrorEvent;
				_handler.onLoadAssetsError( errEv.errorID, errEv.text );
			}
			else
			{
				_handler.onLoadAssetsError( 0, "Unknown Error" );
			}

			// Clear Context
			logger.popContext();
		}

		/**
		 * Handles any progress events from the <code>_loader</code> object.
		 */
		private function onLoaderProgress( event:ProgressEvent ):void
		{

		}

		/**
		 * Handles the complete event from the <code>_loader</code> object.
		 */
		private function onLoaderComplete( event:Event ):void
		{
			// Log Activity
			logger.pushContext( "onLoaderComplete", arguments );
			var assetType:String = _assets[_currentIndex].type;

			_assets[_currentIndex].bmp = LoaderInfo( event.currentTarget ).loader.content;

			cleanupLoader();
			checkLoadingComplete();

			// Clear Context
			logger.popContext();
		}

		/**
		 * Cleans up and removes any event listeners from the <code>_loader</code> object.
		 */
		private function cleanupLoader():void
		{
			// Log Activity
			logger.pushContext( "cleanupLoader", arguments );
			if( _loader )
			{
				_loader.uncaughtErrorEvents.removeEventListener( UncaughtErrorEvent.UNCAUGHT_ERROR, onLoaderError );
				_loader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, onLoaderProgress );
				_loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onLoaderComplete );
				_loader = null;
			}

			// Clear Context
			logger.popContext();
		}

		/**
		 * Handles any IOError events from the <code>_xmlLoader</code> object.
		 */
		private function onXMLLoaderIOError( event:IOErrorEvent ):void
		{
			// Log Activity
			logger.pushContext( "onXMLLoaderIOError" ).error.apply( null, arguments );
			cleanupXMLLoader();

			_handler.onLoadAssetsError( event.errorID, event.text );

			// Clear Context
			logger.popContext();
		}

		/**
		 * Handles any Security Error events from the <code>_xmlLoader</code> object.
		 */
		private function onXMLLoaderSecurityError( event:SecurityErrorEvent ):void
		{
			// Log Activity
			logger.pushContext( "onXMLLoaderSecurityError" ).error.apply( null, arguments );
			cleanupXMLLoader();

			_handler.onLoadAssetsError( event.errorID, event.text );

			// Clear Context
			logger.popContext();
		}

		/**
		 * Handles any progress events from the <code>_xmlLoader</code> object.
		 */
		private function onXMLLoaderProgress( event:ProgressEvent ):void
		{

		}

		/**
		 * Handles the complete event from the <code>_xmlLoader</code> object.
		 */
		private function onXMLLoaderComplete( event:Event ):void
		{
			// Log Activity
			logger.pushContext( "onXMLLoaderSecurityError", arguments );
			_assets[_currentIndex].xml = new XML( URLLoader( event.target ).data );

			cleanupXMLLoader();
			checkLoadingComplete();

			// Clear Context
			logger.popContext();
		}

		/**
		 * Cleans up and removes any event listeners from the <code>_xmlLoader</code> object.
		 */
		private function cleanupXMLLoader():void
		{
			// Log Activity
			logger.pushContext( "cleanupXmlLoader", arguments );
			if( _xmlLoader )
			{
				_xmlLoader.removeEventListener( IOErrorEvent.IO_ERROR, onXMLLoaderIOError );
				_xmlLoader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onXMLLoaderSecurityError );
				_xmlLoader.removeEventListener( ProgressEvent.PROGRESS, onXMLLoaderProgress );
				_xmlLoader.removeEventListener( Event.COMPLETE, onXMLLoaderComplete );
				_xmlLoader = null;
			}

			// Clear Context
			logger.popContext();
		}

		/**
		 * Handles any IOError events from the <code>_flvLoader</code> object.
		 */
		private function onFLVLoaderIOError( event:IOErrorEvent ):void
		{
			cleanupFLVLoader();
			_handler.onLoadAssetsError( event.errorID, event.text );
		}

		/**
		 * Handles any Security Error events from the <code>_flvLaoder</code> object.
		 */
		private function onFLVLoaderSecurityError( event:SecurityErrorEvent ):void
		{
			cleanupFLVLoader();
			_handler.onLoadAssetsError( event.errorID, event.text );
		}

		/**
		 * Handles any progress events from the <code>_flvLoader</code> object.
		 */
		private function onFLVLoaderProgress( event:ProgressEvent ):void
		{

		}

		/**
		 * Handles the complete event from the <code>_flvLoader</code> object.
		 */
		private function onFLVLoaderComplete( event:Event ):void
		{
			_assets[_currentIndex].flv = new FLVByteArray( URLLoader( event.target ).data );

			cleanupFLVLoader();
			checkLoadingComplete();
		}

		/**
		 * Cleans up and removes any event listeners from the <code>_flvLoader</code> object.
		 */
		private function cleanupFLVLoader():void
		{
			if( _flvLoader )
			{
				_flvLoader.removeEventListener( IOErrorEvent.IO_ERROR, onFLVLoaderIOError );
				_flvLoader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onFLVLoaderSecurityError );
				_flvLoader.removeEventListener( ProgressEvent.PROGRESS, onFLVLoaderProgress );
				_flvLoader.removeEventListener( Event.COMPLETE, onFLVLoaderComplete );
				_flvLoader = null;
			}
		}

		/**
		 * Handles any IOError events from the <code>_swfLoader</code> object.
		 */
		private function onSWFLoaderIOError( event:IOErrorEvent ):void
		{
			cleanupSWFLoader();
			_handler.onLoadAssetsError( event.errorID, event.text );
		}

		/**
		 * Handles any Security Error events from the <code>_swfLoader</code> object.
		 */
		private function onSWFLoaderSecurityError( event:SecurityErrorEvent ):void
		{
			cleanupSWFLoader();
			_handler.onLoadAssetsError( event.errorID, event.text );
		}

		/**
		 * Handles any progress events from the <code>_swfLoader</code> object.
		 */
		private function onSWFLoaderProgress( event:ProgressEvent ):void
		{

		}

		/**
		 * Handles the complete event from the <code>_swfLoader</code> object.
		 */
		private function onSWFLoaderComplete( event:Event ):void
		{
			_assets[_currentIndex].swf = URLLoader( event.target ).data;


			cleanupSWFLoader();
			checkLoadingComplete();
		}

		/**
		 * Cleans up and removes any event listeners from the <code>_swfLoader</code> object.
		 */
		private function cleanupSWFLoader():void
		{
			if( _swfLoader )
			{
				_swfLoader.removeEventListener( IOErrorEvent.IO_ERROR, onSWFLoaderIOError );
				_swfLoader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onSWFLoaderSecurityError );
				_swfLoader.removeEventListener( ProgressEvent.PROGRESS, onSWFLoaderProgress );
				_swfLoader.removeEventListener( Event.COMPLETE, onSWFLoaderComplete );
				_swfLoader = null;
			}
		}

		/**
		 * Handles any IOError events from the <code>_sndLoader</code> object.
		 */
		private function onSndLoaderIOError( event:IOErrorEvent ):void
		{
			// Log Activity
			logger.pushContext( "onSndLoaderIOError" ).error.apply( null, arguments );
			cleanupSndLoader();
			_handler.onLoadAssetsError( event.errorID, event.text );

			// Clear Context
			logger.popContext();
		}


		/**
		 * Handles any Security Error events from the <code>_sndLoader</code> object.
		 */
		private function onSndLoaderSecurityError( event:SecurityErrorEvent ):void
		{
			// Log Activity
			logger.pushContext( "onSndLoaderSecurityError" ).error.apply( null, arguments );
			cleanupSndLoader();
			_handler.onLoadAssetsError( event.errorID, event.text );

			// Clear Context
			logger.popContext();
		}

		/**
		 * Handles any progress events from the <code>_sndLoader</code> object.
		 */
		private function onSndLoaderProgress( event:ProgressEvent ):void
		{

		}

		/**
		 * Handles the complete event from the <code>_sndLoader</code> object.
		 */
		private function onSndLoaderComplete( event:Event ):void
		{
			// Log Activity
			logger.pushContext( "onSndLoaderComplete", arguments );
			_assets[_currentIndex].snd = Sound( event.currentTarget );

			cleanupSndLoader();
			checkLoadingComplete();

			// Clear Context
			logger.popContext();
		}

		/**
		 * Cleans up and removes any event listeners from the <code>_sndLoader</code> object.
		 */
		private function cleanupSndLoader():void
		{
			// Log Activity
			logger.pushContext( "cleanupSndLoader", arguments );
			if( _sndLoader )
			{
				_sndLoader.removeEventListener( IOErrorEvent.IO_ERROR, onSndLoaderIOError );
				_sndLoader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onSndLoaderSecurityError );
				_sndLoader.removeEventListener( ProgressEvent.PROGRESS, onSndLoaderProgress );
				_sndLoader.removeEventListener( Event.COMPLETE, onSndLoaderComplete );
				_sndLoader = null;
			}

			// Clear Context
			logger.popContext();
		}

		/**
		 * Converts the loaded asset into a TextureAtlas, Texture or Sounds and loads the next asset.
		 */
		private function checkLoadingComplete():void
		{
			// Log Activity
			logger.pushContext( "checkLoadingComplete", arguments );
			_handler.onLoadAssetsProgress( Math.floor( ( _currentIndex / ( _assets.length - 1 ) ) * 100 ) );

			var assetType:String = _assets[_currentIndex].type;
			var assetName:String = _assets[_currentIndex].name;

			if( assetType == ASSET_TYPE_ATLAS )
			{
				if( _assets[_currentIndex].bmp != null && _assets[_currentIndex].xml != null )
				{
					_atlases[assetName] = new TextureAtlas( Texture.fromBitmap( _assets[_currentIndex].bmp ), _assets[_currentIndex].xml );
					loadAssetByIndex( ++_currentIndex );
				}
			}
			else if( assetType == ASSET_TYPE_PS )
			{
				if( _assets[_currentIndex].bmp != null && _assets[_currentIndex].xml != null )
				{
					_particles[assetName] = { tex: Texture.fromBitmap( _assets[_currentIndex].bmp ), pex: _assets[_currentIndex].xml };
					loadAssetByIndex( ++_currentIndex );
				}
			}
			else if( assetType == ASSET_TYPE_TEXTURE )
			{
				_textures[assetName] = Texture.fromBitmap( _assets[_currentIndex].bmp );
				loadAssetByIndex( ++_currentIndex );
			}
			else if( assetType == ASSET_TYPE_FLV )
			{
				_flvAnimations[assetName] = _assets[_currentIndex].flv;
				loadAssetByIndex( ++_currentIndex );
			}
			else if( assetType == ASSET_TYPE_SWF )
			{
				_swfAnimations[assetName] = _assets[_currentIndex].swf;
				loadAssetByIndex( ++_currentIndex );
			}
			else if( assetType == ASSET_TYPE_SOUND )
			{
				_sounds[assetName] = _assets[_currentIndex].snd;
				loadAssetByIndex( ++_currentIndex );
			}

			// Clear Context
			logger.popContext();
		}

		/**
		 * Retrieves a Texture Atlas by name.
		 *
		 * @param Name the name of the Texture Atlas to retrieve.
		 */
		public function getAtlas( name:String ):TextureAtlas
		{
			return _atlases[name];
		}

		/**
		 * Retrieves a Texture by name.
		 * If you pass in an atlasName, it will return a texture from that atlas.
		 * If you omit altasName, this will first try to find a standalone texture by name.
		 * If none is found, it will iterate over each atlas and return the first texture inside
		 * an atlas that matches the name.
		 * If no textures by the given name or atlases with subtextures by the given name are found,
		 * this will return null.
		 *
		 * @param name the name of the texture to retrieve.
		 * @param atlasName the name of the atlas to find the texture. Null if the texture is standalone
		 * or you which to search all atlases for the texture.
		 */
		public function getTexture( name:String, atlasName:String = null ):Texture
		{
			var texture:Texture = null;

			if( atlasName )
			{
				texture = getAtlas( atlasName ).getTexture( name );
			}
			else if( _textures[name] )
			{
				texture = _textures[name];
			}
			else
			{
				for( var atlas:String in _atlases )
				{
					texture = getAtlas( atlas ).getTexture( name );
					if( texture ) { break; }
				}
			}

			return texture;
		}

		/**
		 * Retrieves all Textures that start with a certain string, sorted alphabetically.
		 * If you pass in an atlasName, it will return textures from that atlas.
		 * If you omit altasName, it will iterate over each atlas and return all textures from the first matching atlas.
		 * If no textures by the given name or atlases with subtextures by the given name are found,
		 * this will return null.
		 *
		 * @param prefix the name prefix of the textures to retrieve.
		 * @param atlasName the name of the atlas to find the textures. Null if you which to search all atlases for the textures.
		 */
		public function getTextures( prefix:String, atlasName:String = null ):Vector.<Texture>
		{
			var textureNames:Array;
			var textures:Vector.<Texture> = null;

			if( atlasName )
			{
				textures = getAtlas( atlasName ).getTextures( prefix );
			}
			else
			{
				for( var texture:String in _textures )
				{
					if( texture.match( "^" + prefix ) )
					{
						if( !textures ){ textures = new Vector.<Texture>(); textureNames = []; }
						textureNames.push( texture );
						textures.push( _textures[texture] );
					}
				}

				if( textures )
				{
					function comp( a:Texture, b:Texture ):int {
						return textureNames[textures.indexOf( a )] - textureNames[textures.indexOf( b )];
					};

					textures.sort(comp);
				}
				else
				{
					for( var atlas:String in _atlases )
					{
						textures = getAtlas( atlas ).getTextures( prefix );
						if( textures && textures.length > 0 ){ break; }
					}
				}
			}

			return textures;
		}

		/**
		 * Retrieve an FLV by name.
		 *
		 * @param name the name of the FLV to retrieve.
		 */
		public function getFLV( name:String ):FLVByteArray
		{
			return _flvAnimations[name];
		}

		/**
		 * Retrieve a SWF by name.
		 *
		 * @param name the name of the SWF to retrieve.
		 */
		public function getSWF( name:String ):ByteArray
		{
			return _swfAnimations[name];
		}

		/**
		 * Retrieve a Particle System by name.
		 *
		 * @param name the name of the system to retrieve.
		 */
		public function getParticleSystem( name:String ):Object
		{
			return _particles[name];
		}

		/**
		 * Retrieves a Sound by name.
		 *
		 * @param name the name of the Sound to retrieve.
		 */
		public function getSound( name:String ):Sound
		{
			return _sounds[name];
		}

		/**
		 * Retrieves a RenderTexture by name.
		 *
		 * @param name the name of the Texture to retrieve.
		 */
		public function getRenderTexture( name:String ):RenderTexture
		{
			return _textures[name] as RenderTexture;
		}

		/**
		 * Disposes of all the TextureAtlases, Textures and Sounds.
		 */
		public function dispose():void
		{
			// Log Activity
			logger.pushContext( "dispose", arguments );

			var key:Object;

			for( key in _atlases )
			{
				( _atlases[key] as starling.textures.TextureAtlas ).dispose();
				delete _atlases[key];
			}

			for( key in _textures )
			{
				if( _textures[key] is RenderTexture )
				{
					( _textures[key] as starling.textures.RenderTexture ).clear();
				}

				( _textures[key] as starling.textures.Texture).dispose();
				delete _textures[key];
			}

			for( key in _particles )
			{
				delete _particles[key];
			}

			for( key in _sounds )
			{
				try
				{
					// Attempt to close the stream. This will error if the stream is completed already.
					( _sounds[key] as Sound ).close();
				}
				catch( e:* ) { /* Do Nothing */ }
				delete _sounds[key];
			}

			for( key in _flvAnimations )
			{
				( _flvAnimations[key] as FLVByteArray ).clear();
				delete _flvAnimations[key];
			}

			for( key in _swfAnimations )
			{
				( _swfAnimations[key] as ByteArray ).clear();
				delete _swfAnimations[key];
			}

			_assets = null;
			_atlases = null;
			_flvAnimations = null;
			_swfAnimations = null;
			_textures = null;
			_sounds = null;
			_particles = null;

			cleanupLoader();
			cleanupXMLLoader();
			cleanupFLVLoader();
			cleanupSWFLoader();
			cleanupSndLoader();

			// Clear Context
			logger.popContext();
		}
	}
}