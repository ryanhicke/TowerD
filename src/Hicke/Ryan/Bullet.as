package Hicke.Ryan{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.controls.Image;

	public class Bullet extends Image{
		private var speed:int;
		private var damage:int;
		private var target:Creep;
		private var effect:int = 0;
		
		public static var types:ArrayCollection; 
		public static var bullets:Array = new Array();
		
		private var startY:Number;
		private var startX:Number;
		private var range:Number;
		
		public static function CreateTypes(coll:ArrayCollection):void{
			types=coll;	
		}
		
		
		public function Bullet(x:Number,y:Number,startX:Number,startY:Number,range:Number,speed:int,damage:int,effect:int,imgSrc:String,target:Creep,c:Canvas){
			this.x = x;
			this.y = y;
			this.speed = speed;
			this.target = target;
			this.damage = damage;
			this.effect = effect;
			this.startX = startX;
			this.startY = startY;
			this.range = range;
			
			source = new Bitmap(BitmapData(Global.preLoader.Get(imgSrc)));
			
			width = 6;
			height = 6;
			
			c.addChild(this);
		}		
		private function Lead(d:int):int{
			return target.speed * (d/8);
		}		
		public function CenterY():Number{
			return y+(height/2);
		}
		public function CenterX():Number{
			return x+(width/2);
		}
		public function Move():void{
			if(target.parent == null) Kill();
			var thisX:Number = target.CenterX();
			var thisY:Number = target.CenterY();
			switch(target.dir){
				case 0:
					thisY -= Lead(Global.DistanceDobj(this,target));
				break;
				case 1:
					thisX += Lead(Global.DistanceDobj(this,target));
				break;
				case 2:
					thisY +=Lead(Global.DistanceDobj(this,target)); 
				break;
				case 3: 
					thisX -= Lead(Global.DistanceDobj(this,target)); 
				break;
			}			
			var ratio:Number = Math.abs(x/(x+y));
			var targY:int = (y> thisY) ? -1:1;
			var targX:int = (x>thisX)?-1:1;
			
			if(Math.abs(thisX-CenterX()) < ratio * speed) x = thisX;
			else x+= targX * (ratio * speed);
			if(Math.abs(thisY-CenterY()) < ((1-ratio) * speed)) y = thisY;
			else y += targY * ((1-ratio) *speed);
			if(Math.abs(Global.DistanceDobj(target,this)) < Math.max(width,height))Explode();
			if(Global.Distance(this.x,startX,this.y,startY) > range) this.alpha -= .05;
			if(Global.Distance(this.x,startX,this.y,startY) > range + (range *.10))Kill();
				
		}		
		private function Explode():void{
			if(target.hp > 0){
				target.Damage(damage);
				Effect();
			}
			x=1000;
			y=1000;
			if(parent != null){
				parent.removeChild(this);
				bullets.filter(Filter);
			}
			damage = 0; 
		}		
		private function Kill():void{
			if(parent != null){
				this.parent.removeChild(this);
				speed = 0;
			}	
			bullets.filter(Filter);
		}		
		private static function Filter(bullet:Bullet, index:int, arr:Array):Boolean {
			return (bullet.parent != null);
		}
	 	public static function Fire(x:Number,y:Number,range:Number,speed:int,damage:int,effect:int,imgSrc:String,target:Creep,c:Canvas):void{
	 		Bullet.bullets.push(new Bullet(x,y,x,y,range,speed,damage,effect,imgSrc,target,c));
	 	}			
	 	private function Effect():void{
	 		switch(effect){
	 			case 1:	StartSlow();break;
	 			case 2: StartFreeze();break;
	 			case 3: StartPoison();break;
	 		}
	 	}
	 	private var temp:int;
	 	private function StartSlow(counter:int = 1):void{
	 		if(!target.effect){
	 			temp = target.speed;
	 			target.speed = target.speed/2;
	 			target.DrawEffect(0x00ff00);
	 			setTimeout(EndSlow,500);
	 		}
	 	}
	 	private function EndSlow(counter:int = 1):void{
	 		if(counter <= 6){
	 			if(!Global.pause)counter+=1
	 			setTimeout(EndSlow,500,counter);
	 		}else{
		 		target.speed = temp;
		 		target.EndEffect();
		 	}
	 	}
	 	private function StartFreeze():void{
	 		if(!target.effect){
	 			temp = target.speed;
	 			target.speed = 0;
	 			target.DrawEffect(0x0000ff);
	 			setTimeout(EndFreeze,100);
	 		}
	 	}
	 	private function EndFreeze(counter:int = 1):void{
	 		if(counter <= 10){
	 			if(!Global.pause)counter+=1;
	 			setTimeout(EndSlow,100,counter);
	 		}else{
		 		target.speed = temp;
		 		target.EndEffect();
		 	}
	 	}
	 	private function StartPoison():void{
 			target.DrawEffect(0xff0000);
 			setTimeout(Poison,500,1);
	 	}
	 	private function Poison(counter:int):void{
	 		if(counter == 10){
	 			target.EndEffect();
	 			return;
	 		}
	 		if(!Global.pause)target.Damage(damage/10);
	 		if(target.hp > 0){
	 			if(!Global.pause)counter+=1;
	 			setTimeout(Poison,500,counter);
	 		}
	 	}	 		
	}
}