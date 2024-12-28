package Hicke.Ryan{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.effects.Rotate;

	public class Creep extends Canvas{
		static public var types:ArrayCollection;
		static public var creeps:Array = new Array();
		public var speed:Number;
		public var hp:int;
		public var maxHp:int;
		public var creepName:String;
		
		public var xBuffer:int;
		public var yBuffer:int;
		public var dir:int = 0;
		public var score:int;
		public var cash:int;
		public var effect:Boolean = false;
		private var imgSrc:String;
		
		public static var hoverCreep:Creep =null;
		private var imgs:Array = new Array();
		
		public static function Clear():void{
			for each(var c:Creep in creeps){
				c.parent.removeChild(c);
			}
			creeps = new Array();
		}
		
		static public function CreateTypes(coll:ArrayCollection):void{
			types=coll;
		}
		private function RandomBuffer(max:int):int{
			return Math.floor(Math.random() * 17)+12;
		}
		public function Creep(x:Number,y:Number,speed:Number,hp:int,score:int,cash:int,creepName:String,imgSource:String,c:Canvas){
			width = 11;
			height = 11;
						
			xBuffer = RandomBuffer(width);
			yBuffer = RandomBuffer(height);
			
			
			this.score = score * (Player.difficulty);
			this.cash=cash;
			this.creepName = creepName;
			
			this.x = x!= 0 ? x+xBuffer:0;
			this.y = y!= 0 ? y+yBuffer:0;
			this.imgSrc = imgSource;
			
				
			for(var i:int =0;i<4;i++){
				var img:Image = new Image();
				img.x=0;
				img.y =0;
				img.width = this.width;
				img.height = this.height;
				img.source = new Bitmap(BitmapData(Global.preLoader.Get(GetSource(i))));
								
				img.visible = false;
				
				imgs.push(img);
				
				this.addChild(img);
			}
			
					
			this.speed = speed;
			this.hp = hp *(Player.difficulty);
			this.maxHp = this.hp;
			
			
			this.addEventListener(MouseEvent.MOUSE_OVER,over_Handler); 
			this.addEventListener(MouseEvent.MOUSE_OUT,out_Handler);
			
			c.addChild(this);
		}
		
		
		private function over_Handler(event:MouseEvent):void{
			hoverCreep = this;
		}
		
		private function out_Handler(event:MouseEvent):void{
			if(hoverCreep == this)hoverCreep = null;
		}
		
		private function GetSource(dir:int):String{
			return imgSrc.replace(".png",GetRotation(dir)+".png");
		}
		
		private var killed:Boolean = false;
		public function Damage(damage:int):void{
			hp -= damage;
			if(hp <=0){
				Kill();
				if(!killed){
					Player.score += score;
					Player.cash+=cash;
					killed = true;
					SoundPlayers.DeathSound();
				}
			}
		}
		private var xT:int = 1;
		private var yT:int = 1;
		public function Move():void{ 
			if(parent != null){
				var xBuff:int = (x+(width/2))-xBuffer > 0 ? (x+(width/2))-(xT*xBuffer) : (x+(width/2));
				var yBuff:int = (y+(height/2))-yBuffer > 0 ? (y+(height/2))-(yT*yBuffer) : (y+(height/2));
				var r:Road = Road.GetRoadAtPos(xBuff,yBuff);
				if (r==null) r = Road.GetRoadAtPos(x,y);
				if(r != null) MoveDir(r.dir);
				else{
					Player.lives -= 1;
					if(Player.lives <= 0) Global.LoseGame(parent);
					Kill();
				}
			}else creeps.filter(Filter);
		}
		private function Kill():void{
			if(parent!= null){
				if(creeps.length == 1 && Raid.raidNum == Raid.totalRaids && Player.lives > 0) Global.WinGame(parent);
				parent.removeChild(this);
				creeps = creeps.filter(Filter);
			}
		}
		
		public function DrawEffect(color:uint):void{
			if(effect) return;
			effect = true;
			graphics.clear();
	 		graphics.beginFill(color,.7);
	 		graphics.drawCircle(width/2,height/2,(width/2)+3);
	 		graphics.endFill();
		 }
		 public function EndEffect():void{
		 	effect = false;
		 	graphics.clear();
		 }
		 			
		private static function Filter(creep:Creep, index:int, arr:Array):Boolean {
			return (creep.parent != null);
		}
		private var lastDir:int = -1;
		public function MoveDir(dir:int):void{
			switch(dir){
				case 0:
					y -= speed;
					yT = -1;
				break;
				case 1:
					x += speed;
					xT=1;
				break;
				case 2: 
					y+= speed;
					yT=1;
				break;
				case 3: 
					x -= speed;
					xT=-1
				break;
			}
			Rota(dir);
			
			this.dir = dir;
		}	
		
		public function Rota(dir:int):void{
			if(lastDir == dir)return;
			lastDir = dir;
			for(var i:int = 0; i < imgs.length;i++){
				Image(imgs[i]).visible = dir==i;
			}
		}
		public function Rota2(dir:int):void{
			if(lastDir == dir)return
			lastDir = dir;
			switch(dir){
				case 0: 
					rotationZ = 0; 
				break;
				case 1: 
					rotationZ = 90; 
				break;
				case 2: 
					rotationZ = 180; 
				break;
				case 3: 
					rotationZ = -90; 
				break;
			}
		}		
		
		public function CenterY():Number{
			return y+(height/2);
		}
		public function CenterX():Number{
			return x+(width/2);
		}
		public function GetRotation(dir:int):String{
			var retVal:String;
			switch(dir){
				case 0: retVal = "U"; break;
				case 1: retVal = "R"; break;
				case 2: retVal = "D"; break;
				case 3: retVal = "L"; break;
			}
			return retVal;
		}
		public function GetRot(dir:int):int{
			var retVal:int;
			switch(dir){
				case 0: retVal = 0; break;
				case 1: retVal = 90; break;
				case 2: retVal = 180; break;
				case 3: retVal = -90; break;
			}
			return retVal
		}
		private function RotateThis(dir:int):void{
			if(lastDir == dir)return;
			lastDir = dir;
			var rotEff:Rotate = new Rotate();
			rotEff.target = this;
			
			rotEff.originX = this.width/2;
			rotEff.originY = this.height/2;
			
			rotEff.duration = 1;
			rotEff.angleFrom = 0;
			rotEff.angleTo = GetRot(dir);
			
			rotEff.play(); 
		}
		
		static public function GetCreepAtPos(x:Number, y:Number):Creep{
			for each(var c:Creep in creeps){
				if(c.AtPos(x,y)) return c;
			}
			return null;
		}	
		public function AtPos(x:Number,y:Number):Boolean{
			return ((x >= this.x && x <= this.x +width)&&(y>=this.y && y<=this.y +height));
		}
		
		static public function FindClosestCreep(t:Tower):Creep{
			var retVal:Creep = null;
			var d:Number = Number.MAX_VALUE;
			for each(var c:Creep in creeps){
				var distance:Number = Global.DistanceDobj(t,c);
				if(distance < d){
					d= distance
					retVal = c;
				}
			}
			return retVal;
		}
	}
}