/**********************************************************
* AUTHOR: POINTROLL
* 
* CLASS: PRBannerMain
*
* DESCRIPTION: 
*
**********************************************************/
package com.pointroll{
 
	import com.pointroll.Widgets.FileLoader;
	import flash.events.*;
	import flash.display.*;
	import flash.net.*;
	import flash.text.*; 
	import utils.string.afterLast;
	
	import pointroll.*;
	import pointroll.info.*;
	import pointroll.initAd;
	import flash.events.MouseEvent;
 

	public class PRBannerMain extends MovieClip {
		private var fl:FileLoader;
		var trackedNoun:String;
		
		
		public function PRBannerMain() {
			loaderInfo.addEventListener(Event.INIT, onINIT);
			this.visible = false;
		}

 
		// Private Functions
		private function init():void {
			pointroll.initAd(this);
			
			cta.addEventListener(MouseEvent.CLICK, onClick)
			myButton.addEventListener(MouseEvent.CLICK, onClick)
			
			var regionID:String = getFlashVar("regionID");
			if (root.loaderInfo.url.indexOf("file") == 0) {
				//regionID = "US:florida"; // DE:berlin;
				//regionID = "CA:ontario"; // DE:berlin;
			}
			
 			trace ("regionID: " + regionID);
			
			if (regionID != null) 
			{
				var country_str:String  = regionID.substr(0, 2);
				trace("\n country_str: " + country_str);
			
				if (country_str == "US") 
				{
					var state_str = afterLast(regionID, ":").toUpperCase();
					//trace("\n state_str: " + state_str)
					TeamScore.text = state_str;
					trackedNoun = "GeoLocation"
					trackNonUIActivityWithNoun(100001, trackedNoun);
					this.visible = true;
				}else {
					trace("\n graceful fail!!!! "  )
					//graceful fail
 					 showGracefulFail()
				}
			}
			else 
			{
				//graceful fail
				showGracefulFail()
 			}
 			
		}
		
		private function showGracefulFail() {
			
			trackedNoun = "GracefulFail"
			//public function loadImageInto(mc:MovieClip, img:String, scale:Number = 1):void{
			cta.visible = false;
			trackNonUIActivityWithNoun(100001, trackedNoun);
			
			fl = new FileLoader(this, "728x90_1k_finger_spin.jpg", "dft");
			fl.pingBack = onLoadComplete;
			fl.loadFile();
			
 			
		}
		
		private function onLoadComplete():void 
		{
			trace("\n onLoadComplete " )
			this.visible = true;
			addChild(fl);
			addChild(myButton)
		}
		
		private function onClick(e:MouseEvent):void 
		{
			trace("\n e.currentTarget.name: " + e.currentTarget.name)
			switch (e.currentTarget.name) 
			{
				case "myButton":
					launchURL(getFlashVar("clickTag1"), true, trackedNoun);
				break;
				case "cta":
					launchURL(getFlashVar("clickTag2"), true, trackedNoun);
				break;
				
				default:
			}
		}


		// EVENTS
		private function onINIT(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onINIT);
			init();
		}
	}
}