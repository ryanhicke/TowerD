package Hicke.Ryan{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.controls.Image;

	public class Tower extends Image{
		static public var types:ArrayCollection;
		static public var towers:Array = new Array();
		[Bindable]private var shotInterval:int = 0;
		[Bindable]public var range:int;
		[Bindable]public var cost:int;
		[Bindable]public var towerName:String;
		[Bindable]public var bullet:Object;
		[Bindable]public var upgradeCost:int;
		[Bindable]public var shotPerSec:String;
		[Bindable]public var effectName:String;
		
		private var soundIndex:int;
		
		static public function CreateTypes(coll:ArrayCollection):void{
			types= coll;
		}
		public function setShotPerSec():void{
			shotPerSec = (1000 / 30 / shotInterval).toPrecision(2).toString();
		}		
		public function Tower(x:int,y:int,shotInterval:int,range:int,cost:int,towerName:String,
				imgSource:String,bullet:Object,soundIndex:int,c:Canvas){
			this.x = x;
			this.y = y;
			this.shotInterval = shotInterval
			this.range = range;
			this.towerName = towerName;
			this.soundIndex = soundIndex;
			setShotPerSec();
			width = 20;
			height = 20;
			this.cost = cost;
			source =new Bitmap(BitmapData(Global.preLoader.Get(imgSource)));
			this.bullet = bullet;
			
			GetEffect(bullet.effect);
			
			this.upgradeCost = Math.ceil(cost *1.2);			
			c.addChild(this);
		}
		public function clickThis():void{
			for each(var t:Tower in towers){
				t.ClearCirc();
			}
			DrawGoodCirc();
			Global.towerShowingRange = this;
			Global.ChangeViews(1,1);
		}
		private function ClickHandler(event:MouseEvent):void{
			clickThis();
		}		
		public function SetTower():void{
			ClearCirc()
			towers.push(this);
			addEventListener(MouseEvent.CLICK,ClickHandler);			
			Player.cash -= this.cost;
			Global.ChangeViews(0,0);
		}
		public function RoadAtPos():Boolean{
			return (
					(Road.GetRoadAtPos(x,y)!=null)||
					(Road.GetRoadAtPos(x,y+height)!=null)||
					(Road.GetRoadAtPos(x+width,y)!=null)||
					(Road.GetRoadAtPos(x+width,y+height)!=null)
				);
		}
		public function TowerAtPos():Boolean{
			return (
					(GetTowerAtPos(x,y)!=null)||
					(GetTowerAtPos(x,y+height)!=null)||
					(GetTowerAtPos(x+width,y)!=null)||
					(GetTowerAtPos(x+width,y+height)!=null)
				);
		}
		private var lastColor:uint = 0xfffff;
		private function DrawRangeCirc(color:uint):void{
			if(color == lastColor) return;
			lastColor = color;
			graphics.clear();     
			graphics.beginFill(color,.3);
			graphics.drawCircle(width/2,height/2,range);
			graphics.endFill();
		}	
		public function DrawGoodCirc():void{
			DrawRangeCirc(0x111111);
		}
		public function DrawBadCirc():void{
			DrawRangeCirc(0xff0000);
		}
		public function ClearCirc():void{
			graphics.clear();
			lastColor = 0xffffff;
		}
		public function CenterY():Number{
			return y+(height/2);
		}
		public function CenterX():Number{
			return x+(width/2);
		}
		private var currentShot:int = 0;		
		public function Fire():void{
			if(currentShot == shotInterval){
				var c:Creep = Creep.FindClosestCreep(this);
				if(c!= null && Global.DistanceDobj(this,c)< this.range){
					Bullet.Fire(x+(width/2),y+(height/2),range,bullet.speed,bullet.damage,bullet.effect,bullet.img,c,Canvas(parent));
					SoundPlayers.ShootSound(soundIndex);
					currentShot=0;
				}
			}else currentShot++;
		}
		public static function Clear():void{
			for each(var t:Tower in towers){
				t.parent.removeChild(t);
			}
			towers = new Array();
		}
		
		public function AtPos(x:Number,y:Number):Boolean{
			return ((x >= this.x && x <= this.x +width)&&(y>=this.y && y<=this.y +height));
		}
		public var level:int = 1;
		public function UpgradeTower():void{
			if(Player.cash > (upgradeCost)){
				upgradeCost = Math.ceil(upgradeCost *1.2);
				Player.cash -= upgradeCost;
				shotInterval -= 2;
				range += 5;
				bullet.damage = Math.ceil(bullet.damage * 1.1);
				setShotPerSec();
				level++;
			}else SoundPlayers.CantBuild();				
		}
		
		public function SellTower():void{
			this.graphics.clear();
			parent.removeChild(this);
			Player.cash += Math.ceil(upgradeCost/2);
			towers = towers.filter(Filter);
			Global.ChangeViews(0,0);
		}
		
		private static function Filter(t:Tower, index:int, arr:Array):Boolean {
			return (t.parent != null);
		}
		private function GetEffect(type:int):void{
			switch(type){
				case 0:effectName = "";break;
				case 1:effectName = "Slow"; break;
				case 2:effectName = "Freeze";break;
				case 3:effectName = "Poison";break;
			}
		}
		
		static public function GetTowerAtPos(x:Number, y:Number):Tower{
			for each(var t:Tower in towers){
				if(t.AtPos(x,y)) return t;
			}
			return null;
		}	
	}
}