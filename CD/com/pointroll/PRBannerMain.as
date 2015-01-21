/**********************************************************
* AUTHOR: POINTROLL
* 
* CLASS: PRBannerMain
*
* DESCRIPTION: 
*
**********************************************************/
package com.pointroll{
	import pointroll.*;
	import pointroll.info.*;
	import com.pointroll.api.utils.net.*;

	import flash.events.*;
	import flash.display.*;
	import flash.net.*;
	import flash.text.*; 	
	import flash.filters.*; 	
	import flash.geom.*; 	
	//import com.PrUtils; 	
	import com.greensock.loading.*; 	
	import com.greensock.events.LoaderEvent; 
	import com.greensock.loading.display.*;
	import flash.utils.*;
	//import flash.media.*;
	//import flash.external.*;
	//import flash.system.Security;
	//
	import com.greensock.*; 	
	import com.greensock.plugins.*; 	

	public class PRBannerMain extends MovieClip {
 		private var cityStr:String;
		private var _xmlRequest:URLRequest;
		private var _xmlVariables:URLVariables;
		public var motionMC:MovieClip;
		public var preloader:MovieClip;
		public var cityname:TextField;
		public var pic:MovieClip;
		public var prOpen:SimpleButton;
		public var picB:MovieClip;
		public var LOGO:MovieClip;
		public var CTA:MovieClip;
		public var BG_mc:MovieClip;
		public var Footer:MovieClip;
		public var citySz:uint = 60;
		
		public var stageWidth:uint;
		public var stageHt:uint;
		public var local_zip:String;
		public var queue:LoaderMax;
		public var assetPath:String// = "assets/";
  		private var _xmlLoader:URLLoader = new URLLoader();
		private var _xml:XML;
		private var timeSecs:uint;
		private var tl:TimelineLite;
		public var rollHint:MovieClip;
		TweenPlugin.activate([AutoAlphaPlugin]);
		
		
		public function PRBannerMain() {
			loaderInfo.addEventListener(Event.INIT, onINIT);
			this.buttonMode = true
 		}

		// Public Functions

		// Private Functions
		private function init():void {
			pointroll.initAd(this);
 			prOpen.addEventListener(MouseEvent.ROLL_OVER, onOver)
 			BG_mc.addEventListener(MouseEvent.CLICK, onClick)
			
 			//assetPath = getFlashVar("assetPath") || "http://speed.pointroll.com/PointRoll/Media/Panels/LOreal/880928/"; 
 			assetPath = getFlashVar("assetPath") || "assets/"; 
			
			preloader.width = getSWFDimensions().width;
			preloader.height = getSWFDimensions().height;
			preloader.x = preloader.y = 0;
 			
 			
 		//Load Assets
			queue = new LoaderMax( { name:"mainQueue", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler } );
			loadAllAssets();
		}
		
		private function onClick(e:MouseEvent):void 
		{
			launchURL(getFlashVar("clickTag1"));
		}
		
		private function onOver(e:MouseEvent):void 
		{
			openPanel(1);
		}
		
 		
		protected function loadAllAssets():void {
			 //implemented in subclass
		}
		
		protected function completeHandler(event:LoaderEvent):void {
  			trace(event.target + " is complete!");
			this.dispatchEvent(new Event("All_Loaded"));
			TweenLite.to(preloader, 1, { autoAlpha:0 } );
			var frameTime:uint = Number(getFlashVar("frameTime")) || 1000;
			trace("\n ############ frameTime: " + frameTime)
			timeSecs = setInterval(nextBnrFrame, frameTime);
			
		}
		
		var framesIndex:Number = 1;
		
		private function nextBnrFrame():void 
		{
			trace("\n framesIndex: " + framesIndex)
			framesIndex++;
			if (framesIndex < 6) 
			{				
				var frame_next:ContentDisplay = LoaderMax.getContent( String(framesIndex) ) as ContentDisplay;
				//trace("\n frame_next.alpha: " + frame_next.alpha)
				TweenLite.to(frame_next, .5, { alpha:1 } );	
			}else 
			{
				clearInterval(timeSecs);
			}
			
			if (framesIndex == 5)  
			{
				//TweenLite.to(rollHint, .5, { alpha:0 } );
				
			}
		}
	
		public function errorHandler(event:LoaderEvent):void {
			trace("error occured with " + event.target + ": " + event.text);
		}
		
		public function progressHandler(event:LoaderEvent):void {
			//trace("progress: " + event.target.progress);
			
		}
		
		
 		// EVENTS
		private function onINIT(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onINIT);
			init();
		}
	}
}


