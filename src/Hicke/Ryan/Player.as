package Hicke.Ryan{
	public class Player{
		[Bindable] public static var lives:int;
		[Bindable] public static var cash:int;
		[Bindable] public static var score:int; 
		[Bindable] public static var difficulty:Number;
		[Bindable] public static var name:String;
		[Bindable] public static var id:int;
		
		public static var domain:String = "";
		public static var scoreUrl:String = "";
		public static var logicUrl:String = "";
		public static var submitScoreUrl:String = "";
		public static var mapID:String = "";
		public static var playerID:String = "";
	}
}