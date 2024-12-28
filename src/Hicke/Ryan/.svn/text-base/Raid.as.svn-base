package Hicke.Ryan{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import mx.containers.Canvas;

	public class Raid{
		static private var queue:Array = new Array(); 
		static private var current:Raid = null;
		private static var tmrDisplay:Timer;
		private var creeps:Array;
		private var interval:int;
		private static var canvas:Canvas = null;
		public static var totalRaids:int = 0;
		public static var raidNum:int = 0;
		
		public function Raid(creeps:Array,interval:int,c:Canvas){
			this.creeps = creeps;
			this.interval = interval;
			totalRaids++;
			
			if(canvas == null) canvas = c;
			queue.push(this);
		}
		
		public static function Clear():void{
			totalRaids = 0;
			raidNum = 0;
			queue = new Array();
		}
		
		private static var tmr:Timer;
		
		public static function Pause():void{
			tmr.stop();
			tmrDisplay.stop();
		}
		public static function EndPause():void{
			tmr.start();
			tmrDisplay.start();
		}
		
		private static function Timer_Handle(event:TimerEvent):void{
			CallRaid();
		}
		private static var timeIn:int = 1;		
		public static function TimeTillNext():String{
			if(tmr == null) return "";
			var timeLeft:int  = (tmr.delay/1000) - timeIn;
			var minLeft:int = Math.floor(timeLeft /60);
			var secLeft:String = Math.floor(timeLeft - (minLeft * 60)).toString();
			if(secLeft.length == 1) secLeft = "0" + secLeft;	
			return minLeft + ":" + secLeft;
		}
		private static function TimerDisplay_Handle(event:TimerEvent):void{
			timeIn+=1;
		}
		private static function CallRaid():void{
			tmr.stop();
			tmrDisplay.stop();
			raidNum++;
			if(tmr.delay/1000 > timeIn){
				var diffInSec:int = (tmr.delay/1000)-timeIn;
				Player.score += Math.ceil((diffInSec * 10 * raidNum * Player.difficulty));
			}
			if(current!=null){
				current.BeginRaid();
				current = queue.shift();
				if(current != null){
					timeIn = 1;
					tmrDisplay.start();
					tmr.delay = current.interval;
					tmr.start();
				}
			}
		}
		
		private static function EndRaid():void{
		}
		
		public static function SendEarly():void{
			if(tmr.running && timeIn > 1){
				CallRaid();
			}
		}
		
		public static function StartRaid():void{
			current = queue.shift();
			timeIn = 1;
			tmrDisplay = new Timer(1000);
			tmrDisplay.addEventListener(TimerEvent.TIMER,TimerDisplay_Handle);
			tmr = new Timer(current.interval);
			tmr.addEventListener(TimerEvent.TIMER,Timer_Handle);
			tmr.start();
			tmrDisplay.start();
		}
		
		private function BeginRaid(counter:int = 0):void{
			if(!Global.pause){
				CreateCreep(creeps[counter]);
				counter += 1;
			}
			if(counter< creeps.length)	setTimeout(BeginRaid,50,counter);
		}
		
		private function CreateCreep(c:Object):void{
			var cree:Object = Creep.types.getItemAt(c.type);
			Creep.creeps.push(new Creep(c.x,c.y,cree.speed,cree.hp,cree.score,cree.cash,cree.name,cree.img,canvas));			
		}
	}
}