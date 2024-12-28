package Hicke.Ryan {
	import com.manishjethai.code.flash.utils.JSONObject;
	
	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.containers.ViewStack;
	import mx.controls.Button;
	import mx.controls.Image;
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	import mx.rpc.events.ResultEvent;

	public class Global	{
		static public var canva:Canvas;
		static public var bgImgSrc:String;		
 		static public var roadImg:String;
 		static private var raidList:Array;
 		static private var roadList:Array;
		static private var gameOver:Boolean = false;
		static public var preLoader:PreLoader = new PreLoader();


		static private function PreLoadDirections(s:String,road:Boolean = false):void{
			preLoader.Put(s.replace(".png","U.png"));
			preLoader.Put(s.replace(".png","D.png"));
			preLoader.Put(s.replace(".png","R.png"));
			preLoader.Put(s.replace(".png","L.png"));
			if(road){
				preLoader.Put(s.replace(".png","LU.png"));
				preLoader.Put(s.replace(".png","RU.png"));
				preLoader.Put(s.replace(".png","RD.png"));
				preLoader.Put(s.replace(".png","LD.png"));
			}
		}
				
		
		static public function Logic(event:ResultEvent):void{
			var json:JSONObject = new JSONObject(event.result.toString());
			bgImgSrc = json.bgImg;
			preLoader.Put(bgImgSrc);
			roadImg = json.roadImg;
			PreLoadDirections(roadImg,true);
			var tow:ArrayCollection = new ArrayCollection();
			tow.addItem(json.tower1);
			preLoader.Put(json.tower1.img);
			tow.addItem(json.tower2);
			preLoader.Put(json.tower2.img);
			tow.addItem(json.tower3);
			preLoader.Put(json.tower3.img);
			tow.addItem(json.tower4);
			preLoader.Put(json.tower4.img);
			tow.addItem(json.tower5);
			preLoader.Put(json.tower5.img);
			Tower.CreateTypes(tow);
			var bull:ArrayCollection = new ArrayCollection();
			bull.addItem(json.bullet1);
			preLoader.Put(json.bullet1.img);
			bull.addItem(json.bullet2);
			preLoader.Put(json.bullet2.img);
			bull.addItem(json.bullet3);
			preLoader.Put(json.bullet3.img);
			bull.addItem(json.bullet4);
			preLoader.Put(json.bullet4.img);
			bull.addItem(json.bullet5);
			preLoader.Put(json.bullet5.img);
			Bullet.CreateTypes(bull);
			var cree:ArrayCollection = new ArrayCollection();
			cree.addItem(json.creep1);
			PreLoadDirections(json.creep1.img);
			cree.addItem(json.creep2);
			PreLoadDirections(json.creep2.img);
			cree.addItem(json.creep3);
			PreLoadDirections(json.creep3.img);
			cree.addItem(json.creep4);
			PreLoadDirections(json.creep4.img);
			cree.addItem(json.creep5);
			PreLoadDirections(json.creep5.img);
			cree.addItem(json.creep6);
			PreLoadDirections(json.creep6.img);
			cree.addItem(json.creep7);
			PreLoadDirections(json.creep7.img);
			cree.addItem(json.creep8);
			PreLoadDirections(json.creep8.img);
			Creep.CreateTypes(cree);
			SoundPlayers.Init(json.sounds);
			
			raidList = json.raids;
			roadList = json.roads;
			
			
		}		
		
		static public function CreateRoads(c:Canvas):void{
			for(var count:int = 0; count<roadList.length;count++){
				var tX:int = roadList[count].x;
				var tY:int = roadList[count].y;
				var newRoads:Array = roadList[count].road;
				for(var i:int = 0;i<newRoads.length;i++){
					var dir = newRoads[i].dir;
					var lastDir = i==0? -1: newRoads[i-1].dir;
					Road.roads.push(new Road(tX,tY,dir,
						newRoads[i]["img"].toString().length>0?newRoads[i]["img"]:GetRoadImg(dir,lastDir),c));
					switch(dir){
						case 0:	tY -=45;break;
						case 1: tX += 45; break;
						case 2: tY += 45; break;
						case 3: tX -= 45; break;
	 				}
	 			}
	 		}
 		}
		static public function CreateRaids(can:Canvas):void{
			Raid.Clear();
			for(var i:int;i<raidList.length;i++){
				var r:Raid = new Raid(raidList[i].creeps,raidList[i].time,can);
			}
			Raid.StartRaid();
		}
		static public function BeginGame():void{
			Global.InitPlayer();
			Global.SetTimer();
			Global.CreateRaids(canva);
			gameOver = false;
		}
		static public function ResetGame():void{
			Creep.Clear();
			Tower.Clear();
			Raid.Clear();
			ChangeViews(0,0);
		}
		static public function ChooseDiff(can:DisplayObject):void{
			var sg:StartGame = new StartGame();
			PopUpManager.addPopUp(sg,can,true);
			PopUpManager.centerPopUp(sg);
		}
		static public var pause:Boolean = false;		
		static public function Pause(c:Canvas,img:Image,img2:Image,btn:Button):void{
			pause = true;
			c.graphics.beginFill(0xffffff,.9);
			c.graphics.drawRect(10,10,400,400);
			c.graphics.endFill();
			Raid.Pause();
			dontSet = true;
			img.visible = true;
			img2.visible = true;
			btn.label = "Play";
		}
		static public function EndPause(c:Canvas,img:Image,img2:Image,btn:Button):void{
			if(dontSet){
				dontSet = false;
				return;
			}
			pause = false;
			c.graphics.clear();
			Raid.EndPause();
			img.visible = false;
			img2.visible = false;
			btn.label = "Pause";
		}
					
		static public function Distance(x1:int,x2:int,y1:int,y2:int): Number{
			return Math.sqrt(Math.pow(x2-x1,2)+Math.pow(y2-y1,2));
		}
		static public function DistanceDobj(dobj1:DisplayObject,dobj2:DisplayObject):Number{
			return  Distance(CenterX(dobj1),CenterX(dobj2),CenterY(dobj1),CenterY(dobj2));
		}		
		static public function CenterY(d:DisplayObject):Number{
			return d.y+(d.height/2);
		}
		static public function CenterX(d:DisplayObject):Number{
			return d.x+(d.width/2);
		}		
		static public function AtPos(x:int,y:int,img:Image):Boolean{
			return ((x >= img.x && x < (img.x +img.width)) && 
				(y >= img.y && y< (img.y + img.height)));
		}		
		
 		static public function GetRoadImg(dir:int,lastDir:int):String{
 			if(dir == lastDir   || lastDir == -1) return roadImg.replace(".png",Road.GetRotation(dir)+".png");
 			var replacer:String = "";
 			switch(dir){
 				case 0:
 					if(lastDir == 1) replacer = "LU.png";
 					else if(lastDir == 3) replacer = "RU.png";
 				break;
 				case 1:
 					if(lastDir == 0)replacer = "RD.png";
 					else if(lastDir == 2)replacer = "RU.png";
 				break;
 				case 2:
 					if(lastDir == 1) replacer = "LD.png";
 					else if(lastDir == 3) replacer = "RD.png";
 				break;
 				case 3:
 					if(lastDir == 0) replacer = "LD.png";
 					else if(lastDir == 2)replacer = "LU.png";
 				break;
 			}
 			return roadImg.replace(".png",replacer);
 		}
		static var tmr:Timer;
		static public function SetTimer():void{
			tmr  = new Timer(30);
			tmr.addEventListener(TimerEvent.TIMER,Timer_Handle);
			
			tmr.start();
		}
		static private function Timer_Handle(event:TimerEvent):void{
			if(!pause){
				Timer_HandleCreep();
				Timer_HandleNewTower();
				Timer_HandleTowerShots();
				Timer_HandleBullets();
			}
		}
		static private function Timer_HandleCreep():void{
			for each(var c:Creep in Creep.creeps){
				c.Move();
			}
		}
		static private function Timer_HandleNewTower():void{
			if(towerToSet!=null){
				towerToSet.x = FlexGlobals.topLevelApplication.mouseX
				towerToSet.y = FlexGlobals.topLevelApplication.mouseY;
				if(towerToSet.y < 450 - (towerToSet.height/2) && !towerToSet.RoadAtPos() && !towerToSet.TowerAtPos())towerToSet.DrawGoodCirc();
				else towerToSet.DrawBadCirc();
			}
		}
		static private function Timer_HandleTowerShots():void{
			for each(var t:Tower in Tower.towers){
				t.Fire();
			}
		}
		static private function Timer_HandleBullets():void{
			for each(var b:Bullet in Bullet.bullets){
				b.Move();
			}
		}
		
		static public var towerToSet:Tower = null;
		static public var dontSet:Boolean = false;
		static public function NewTower(c:Canvas,i:int):void{
			dontSet = true;
			var tower:Object = Tower.types.getItemAt(i);
			if(Player.cash >= tower.cost)towerToSet = new Tower(FlexGlobals.topLevelApplication.mouseX,
							FlexGlobals.topLevelApplication.mouseY,tower.shot,tower.range,tower.cost,tower.name,tower.img,
							Bullet.types.getItemAt(i),i,c);
			else SoundPlayers.CantBuild();
		}		
		static public function SetTower():void{
			if(!towerToSet.RoadAtPos() && !towerToSet.TowerAtPos()){
				towerToSet.SetTower();
				towerToSet = null;
				dontSet = false;
			}
		}		
		static public function RemoveSet():void{
			if(towerToSet!=null){
				if(dontSet)dontSet=false;
				else{
					towerToSet.parent.removeChild(towerToSet);
					towerToSet = null;
				}
			}
		}
		public static var vwsInfo:ViewStack;
		public static var vwsBuy:ViewStack;
		static public function ChangeViews(infoIndex:int,buyIndex:int):void{
			vwsInfo.selectedIndex = infoIndex;
			vwsBuy.selectedIndex = buyIndex;
		}
		
		static public var towerShowingRange:Tower = null;
		static public function ChangeShowRangeTower(t:Tower):void{
			towerShowingRange = t;
			dontSet = true;
		}
	
		static public function InitPlayer():void{
			Player.lives = 40;
			Player.cash = 1000;
			Player.score = 0;
		}
		
		static public function LoseGame(dobj:DisplayObject):void{
			if(gameOver) return;
			gameOver= true;
			var gm:GameOver = new GameOver();
			gm.Open("You Lose");	
			PopUpManager.addPopUp(gm,dobj,true);
			PopUpManager.centerPopUp(gm);			
		}
		static public function WinGame(dobj:DisplayObject):void{
			if(gameOver) return;
			gameOver = true;
			var gm:GameOver = new GameOver();
			gm.Open("You WIN!!!");
			PopUpManager.addPopUp(gm,dobj,true);
			PopUpManager.centerPopUp(gm);	
		}
	}
}