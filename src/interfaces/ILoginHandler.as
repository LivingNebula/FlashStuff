package interfaces
{
	public interface ILoginHandler
	{
		function loginSuccess( user:String, pass:String ):void;
		
		function loginFailed( user:String, pass:String, reason:String ):void;
		
		function exit( reason:String ):void;
	}
}