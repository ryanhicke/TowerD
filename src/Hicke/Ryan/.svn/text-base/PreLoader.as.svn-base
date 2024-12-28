package Hicke.Ryan{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	public class PreLoader{
		private var dict:Dictionary;
		private var targetLoaded:int = 0;
		private var loaded:int = 0;
		
		public function PreLoader(){
			dict = new Dictionary();
		}
		
		public function Put(url:String):void{
			targetLoaded += 1;
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,OnComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,OnError);
			var req:URLRequest = new URLRequest(Player.domain+url);
			loader.load(req);
		}
		public function LoadsComplete():Boolean{
			return loaded == targetLoaded;
		}
		
		public function Get(key:String):Object{
			return dict[Player.domain+key];
		}
		private function OnComplete(e:Event):void{
			if(!hasKey(e.currentTarget.url)){
				//var bd:BitmapData = new BitmapData(e.currentTarget.content.width,e.currentTarget.content.height,e);
				//bd.draw(e.currentTarget.content);
				var bd:BitmapData = BitmapData(e.currentTarget.content.bitmapData);
				push(e.currentTarget.url,bd);
			}
			loaded+=1;
		}
		private function OnError(e:IOErrorEvent):void{
			var i:int = 0;
		}
		
		private function hasKey(key:String):Boolean{
			return dict[key] != null;
		}
		private function push(key:String,val:Object):void{
			dict[key] = val;
		}
		
	}
}