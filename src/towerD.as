
import Hicke.Ryan.Bullet;
import Hicke.Ryan.Creep;
import Hicke.Ryan.Global;
import Hicke.Ryan.HTTP;
import Hicke.Ryan.Player;
import Hicke.Ryan.Raid;
import Hicke.Ryan.SoundPlayers;
import Hicke.Ryan.Tower;

import flash.display.Bitmap;
import flash.display.BitmapData;

import mx.containers.ViewStack;
import mx.controls.Image;
import mx.events.FlexEvent;
import mx.rpc.events.ResultEvent;

private var appCreated:Boolean = false;
protected function application1_creationCompleteHandler(event:FlexEvent):void{
	appCreated = true;
}
protected function PrepareGameWork():void{
	if(appCreated && Global.preLoader.LoadsComplete()){
		imgBG.source = new Bitmap(BitmapData(Global.preLoader.Get(Global.bgImgSrc)));
		Global.canva = can;
		Global.vwsBuy = vwsBuy;
		Global.vwsInfo = vwsInfo;
		Global.CreateRoads(can);
		SetTowerImages();
		pgbLoading.visible = false;
		timeLeftTimer.addEventListener(TimerEvent.TIMER,Timer_Handle);
		timeLeftTimer.start();
		can.visible = true;
		can.alpha = 1.0
		Global.ChooseDiff(can);
	}else{
		callLater(PrepareGameWork);
	}
}
protected function PrepareGame(event:ResultEvent):void{
	Global.Logic(event);
	PrepareGameWork();
}
protected function SetTowerImages():void{
	btnTower1.source = new Bitmap(BitmapData(Global.preLoader.Get(Tower.types[0].img))); 
	btnTower2.source = new Bitmap(BitmapData(Global.preLoader.Get(Tower.types[1].img))); 
	btnTower3.source = new Bitmap(BitmapData(Global.preLoader.Get(Tower.types[2].img))); 
	btnTower4.source = new Bitmap(BitmapData(Global.preLoader.Get(Tower.types[3].img))); 
	btnTower5.source = new Bitmap(BitmapData(Global.preLoader.Get(Tower.types[4].img))); 
}
protected function can_clickHandler(event:MouseEvent):void{
	if(Global.pause){
		Global.EndPause(can,imgOverlay,imgPause,btnPause);
		return;
	}		
	var t:Tower = Tower.GetTowerAtPos(mouseX,mouseY);
	if(t != null){
		ClickTower();
		if(t != Global.towerShowingRange) t.clickThis();
		return;
	}
	if(Global.towerShowingRange != null && mouseY < 450){
		Global.towerShowingRange.ClearCirc();
		if(Global.towerToSet == null)Global.ChangeViews(0,0);
		vwsInfo.selectedIndex = 0;
		vwsBuy.selectedIndex = 0;
		Global.towerShowingRange = null;		 
		return;
	}
	if(Global.towerToSet != null ){
		if(Global.towerToSet.y < 450 - (Global.towerToSet.width/2)) Global.SetTower();
		else Global.RemoveSet();
	}
	if(Global.towerToSet == null && Global.towerShowingRange == null){
		vwsBuy.selectedIndex=0;
		vwsInfo.selectedIndex = 0;
	}
}
private var timeLeftTimer:Timer = new Timer(50);
private function Timer_Handle(event:TimerEvent):void{
	lblRaidTimer.text = Raid.raidNum < Raid.totalRaids ?
		"Raid "+ (Raid.raidNum +1)+" in: " + Raid.TimeTillNext():
		Raid.raidNum == 0?
			"":
			"Final Raid";
	if(Creep.hoverCreep != null){
		CreepStats();
	}else{
		if(vwsInfo.selectedIndex == 3){
			vwsInfo.selectedIndex = 0;
			vwsBuy.selectedIndex = 0;
		}
	}
}
protected function image1_clickHandler(event:MouseEvent):void{
	Global.NewTower(can,0);
}
protected function image2_clickHandler(event:MouseEvent):void{
	Global.NewTower(can,1);
}
protected function image3_clickHandler(event:MouseEvent):void{
	Global.NewTower(can,2);
}
protected function image4_clickHandler(event:MouseEvent):void{
	Global.NewTower(can,3);
}
protected function image5_clickHandler(event:MouseEvent):void{
	Global.NewTower(can,4);
}
protected function button1_clickHandler(event:MouseEvent):void{
	Global.Pause(can,imgOverlay,imgPause,btnPause);
}
protected function application1_deactivateHandler(event:Event):void	{
	Global.Pause(can,imgOverlay,imgPause,btnPause);
}
protected function imgOverlayClick(event:Event):void{
	if(Global.pause)Global.EndPause(can,imgOverlay,imgPause,btnPause);
}
protected function lblRaidTimer_clickHandler(event:MouseEvent):void{
	if(Raid.raidNum < Raid.totalRaids)	Raid.SendEarly();
	if(Raid.raidNum == Raid.totalRaids){
		lblRaidTimer.buttonMode = false;
		lblRaidTimer.graphics.clear();
	}
}
protected function lblRaidTimer_mouseOverHandler(event:MouseEvent):void{
	if(Raid.raidNum < Raid.totalRaids){
		if(!lblRaidTimer.buttonMode)lblRaidTimer.buttonMode = true;
		lblRaidTimer.graphics.beginFill(0xffffff,.4);
		lblRaidTimer.graphics.drawRect(0,0,lblRaidTimer.width,lblRaidTimer.height);
		lblRaidTimer.graphics.endFill();
	}else{
		lblRaidTimer.buttonMode = false;
	}
}
private function DrawOverlay(img:Image):void{
	img.graphics.beginFill(0xffffff,.4);
	img.graphics.drawRect(0,0,img.width,img.height);
	img.graphics.endFill();
}
private function KillOverlay(img:Image):void{
	img.graphics.clear();
}
protected function lblRaidTimer_mouseOutHandler(event:MouseEvent):void{
	lblRaidTimer.graphics.clear();
}
private var ClickTowerNotShown:Boolean = true;
protected function ClickTower():void{
	vwsInfo.selectedIndex = 2;
	if(ClickTowerNotShown){
		ClickTowerNotShown = false;
		callLater(ClickTower);
	}else{					
		var bullet:Object = Global.towerShowingRange.bullet;
		
		if(Global.towerShowingRange.upgradeCost > Player.cash) lblTwrUpgCost.styleName="red";
		else lblTwrUpgCost.styleName = "";
		lblTwrUpgCost.text = "$"+Global.towerShowingRange.upgradeCost;
		lblTwrUpgDmg.text = "Damage: " +bullet.damage;
		lblTwrUpgEffect.text = GetEffect(bullet.effect); 		
		lblTwrUpgName.text = Global.towerShowingRange.towerName+" Level: "+Global.towerShowingRange.level;
		lblTwrUpgRange.text = "Range: "+Global.towerShowingRange.range;
		lblTwrUpgSpeed.text = "Speed: "+Global.towerShowingRange.shotPerSec;
	}
}		
private var HoverTowerNotShown:Boolean = true;
protected function HoverTower(i:int):void{
	vwsInfo.selectedIndex = 1;
	if(HoverTowerNotShown){
		HoverTowerNotShown = false;
		callLater(HoverTower,[i]);
	}else{
		var tower:Object = Tower.types[i];
		var bullet:Object = Bullet.types[i];
		
		if(tower.cost > Player.cash) lblTwrBuyCost.styleName ="red"
		else lblTwrBuyCost.styleName = "";
		lblTwrBuyCost.text = "$"+tower.cost;
		lblTwrBuyDmg.text = "Damage: " +bullet.damage;
		lblTwrBuyEffect.text = GetEffect(bullet.effect); 		
		lblTwrBuyName.text = tower.name;
		lblTwrBuyRange.text = "Range: "+tower.range;
		lblTwrBuySpeed.text = "Speed: "+ShotsPerSec(tower.shot);
	}
}			
protected function HoverTowerOut():void{
	if(Global.towerToSet == null){
		vwsInfo.selectedIndex = 0;
		vwsBuy.selectedIndex = 0;
	}
}			
private function ShotsPerSec(shotInterval:int):String{
	return (1000 / 30 /shotInterval).toPrecision(2).toString();
}		
private function GetEffect(type:int):String{
	var effectName:String = "";
	switch(type){
		case 0:effectName = "";break;
		case 1:effectName = "Slow"; break;
		case 2:effectName = "Freeze";break;
		case 3:effectName = "Poison";break;
	}
	return  effectName;
}

protected function button2_clickHandler(event:MouseEvent):void{
	if(Global.towerShowingRange!=null){
		Global.towerShowingRange.UpgradeTower();
		ClickTower();
	}
}


protected function btnSell_clickHandler(event:MouseEvent):void{
	if(Global.towerShowingRange != null) Global.towerShowingRange.SellTower();
}

public function CreepStats():void{
	try{
		vwsBuy.selectedIndex = 0;
		vwsInfo.selectedIndex = 3;
		lblCreepCash.text = "$ " +Creep.hoverCreep.cash;
		lblCreepHP.text = Creep.hoverCreep.hp +"/"+Creep.hoverCreep.maxHp;
		lblCreepName.text = Creep.hoverCreep.creepName; 
		lblCreepPoints.text = Creep.hoverCreep.score + " pts";
		lblCreepSpeed.text = "Speed: " +Creep.hoverCreep.speed;
	}catch(te:TypeError){
	}				
}

protected function imgSpk_clickHandler(event:MouseEvent):void{
	vwsSound.selectedIndex = SoundPlayers.GetVolume()>0? 1:0;
	SoundPlayers.ToggleMute();
}

protected function vwsGraphicsOver(vws:ViewStack):void{
	vws.graphics.beginFill(0xffffff,.4);
	vws.graphics.drawRect(0,0,vws.width,vws.height);
	vws.graphics.endFill();
}

protected function vwsGraphicsOut(vws:ViewStack):void{
	vws.graphics.clear();
}

protected function application1_preinitializeHandler(event:FlexEvent):void{
	Player.logicUrl = this.parameters.logicUrl;
	Player.scoreUrl = this.parameters.scoreUrl;
	Player.submitScoreUrl = this.parameters.submitScoreUrl; 
	Player.domain = this.parameters.domain;
	Player.mapID = this.parameters.mapID;
	Player.playerID = this.parameters.playerID;
	HTTP.LoadLogic(PrepareGame);
}
