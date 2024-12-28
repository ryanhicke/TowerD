package Hicke.Ryan{
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	public class HTTP{		
		public static function GetScores(func:Function):void{
			SendHttp(Player.scoreUrl,func);
		}
		private static function SendHttp(url:String,func:Function,params:String = ""):void{
			var http:HTTPService = new HTTPService();
			http.url = url +  (params.length>0?
				params + "&mapID="+Player.mapID+"&playerID="+Player.playerID:
				"?mapID="+Player.mapID+"&playerID="+Player.playerID);
			http.addEventListener(ResultEvent.RESULT,func);
			http.addEventListener(FaultEvent.FAULT,Error);
			http.send();
		}			
		public static function SubmitScore(func:Function,name:String,score:String):void{
			SendHttp(Player.submitScoreUrl,func,"?name="+name+"&score="+score);
		}
		public static function LoadLogic(func:Function):void{
			SendHttp(Player.logicUrl,func);
		}	
		public static function Error(event:FaultEvent):void{
		}
	}
}