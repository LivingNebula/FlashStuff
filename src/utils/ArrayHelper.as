package utils
{
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;

	public class ArrayHelper
	{
		public function ArrayHelper()
		{
		}
		
		/**
		 * Swaps two item in an array.
		 */		
		public static function swap( arr:Array, a:int, b:int ):void
		{
			var item:* = arr[a];
			arr[a] = arr[b];
			arr[b] = item;
		};
		
		/**
		 * Randomizes an array by applying a random number to the sort function of the array.
		 */		
		public static function randomize( arr:Array ):void
		{
			arr.sort( sortRandom );
		};	
		
		/**
		 * Sorts an array randomly.
		 */
		public static function sortRandom( a:*, b:* ):Number
		{			
			return Math.round( Math.random() * 2 ) - 1;
		};
		
		/**
		 * Copies an array.
		 */			
		public static function copy( arr:Array ):Array
		{
			return arr.slice( 0 );
		}
		
		/**
		 * Returns an array containg only the unique elements from a single source array ( removes dupes )
		 */
		public static function getUnique( arr:Array ):Array
		{
			var i:int, arrRes:Array = [];
			for( i = 0; i < arr.length; i++ )
			{
				if( arrRes.indexOf( arr[i] ) == -1 )
				{
					arrRes.push( arr[i] );
				}
			}
			
			return arrRes;
		}
		
		/**
		 * Returns a new array containing only the unique elements from two source Arrays
		 */
		public static function getMergedUnique( arr1:Array, arr2:Array ):Array
		{
			var i:int, arrRes:Array = [];
			for( i = 0; i < arr1.length; i++ ) 
			{
				if( arr2.indexOf( arr1[i] ) == -1 && arrRes.indexOf( arr1[i] ) == -1 ) 
				{
					arrRes.push( arr1[i] );
				}	
			}
			
			for( i = 0; i < arr2.length; i++ ) 
			{
				if( arr1.indexOf( arr2[i] ) == -1 && arrRes.indexOf( arr2[i] ) == -1 )  
				{
					arrRes.push( arr2[i] );
				}	
			}		
			
			return arrRes;
		}
		
		/**
		 * Returns an new array containingthe elements from two source Arrays
		 */		
		public static function getMerged( arr1:Array, arr2:Array ):Array
		{
			var arrRes:Array = arr1.slice( 0 );
			arrRes.push.apply( arrRes, arr2 );
			
			return arrRes;
		}
	}
}