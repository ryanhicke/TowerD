package Hicke.Ryan{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import mx.containers.Canvas;
	import mx.controls.Image;

	public class Road extends Image{
		public var dir:int;
		
		public function Road(x:Number,y:Number,dir:int,imgSrc:String,c:Canvas){
			this.x = x;
			this.y = y
			this.width = 45;
			this.height = 45;
			this.dir = dir;
		
			source = new Bitmap(BitmapData(Global.preLoader.Get(imgSrc)));
						
			c.addChild(this);
		}
		public function GetRot(dir:int):int{
			var retVal:int;
			switch(dir){
				case 0: retVal = 0; break;
				case 1: retVal = 90; break;
				case 2: retVal = 180; break;
				case 3: retVal = 270; break;
			}
			return retVal;
		}
		
		public static function GetRotation(dir:int):String{
			var retVal:String;
			switch(dir){
				case 0: retVal = "U"; break;
				case 1: retVal = "R"; break;
				case 2: retVal = "D"; break;
				case 3: retVal = "L"; break;
			}
			return retVal;
		}
		
		public static var roads:Array = new Array();
		
		public function AtPos(x:Number,y:Number):Boolean{
			return ((x >= this.x && x <= this.x +width)&&(y>=this.y && y<=this.y +height));
		}
		
		static public function GetRoadAtPos(x:Number, y:Number):Road{
			for each(var r:Road in roads){
				if(r.AtPos(x,y)) return r;
			}
			return null;
		}		
	}
}