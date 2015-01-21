package com.pointroll{

	import com.*;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import PointRollAPI_AS3.PointRoll;
	import flash.display.*;
	import flash.events.*;
 	import flash.text.*;
	import com.jan2012combo.*;
	
	import com.pointroll.data.*;
	import com.pointroll.events.*;
	import PointRollAPI_AS3.events.media.*;

	public class PRAutoMain extends MovieClip {
		private var myPR:PointRoll;

		public var clickTag_btn:SimpleButton;
		public var prvidMC:PRVideoPlayer;
		public var endFrame_MC:MovieClip;
		public var marker:MovieClip;
		public var navMC:VideoNavMC;
		private var adFolder:String;
		
		private var vidStream:String;
 		private var vidStream15secs:String;
		
 		private var vidID:String;

		private var _ds:PRDataStorage = new PRDataStorage();
		var loader:Loader = new Loader();
		
		public function PRAutoMain() {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		
		// EVENTS
		private function onAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			myPR = PointRoll.getInstance(this);
			
			//var req:URLRequest = new URLRequest(myPR.absolutePath + "SHOcomboJAN2012_728x300_sync_bnr_sub.swf");
			var sub:String = myPR.parameters.subswf || "SHOcomboJAN2012_728x300_sync_bnr_sub.swf"
			var asset:String=myPR.absolutePath + sub;
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, init);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.load(new URLRequest(asset));
			
			//init();			
		}
		
		public function errorHandler( error:IOErrorEvent ):void{
   		 trace("subswf, SHOcomboJAN2012_728x300_sync_bnr_sub.swf,  did not load  error: "+ error);
		}
		
		// Private Functions
		private function init(e:Event):void{
			trace("init");
						
			endFrame_MC = MovieClip(loader.content).endFrame_MC;			
			addChild(endFrame_MC);
			endFrame_MC.replay_btn.addEventListener(MouseEvent.CLICK, replayCurrVid);
			endFrame_MC.visible = false;
			navMC = endFrame_MC.vidNavMC_disp;
			
 			clickTag_btn.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			adFolder = myPR.parameters.adFolder || "Showtime";
			vidID = "init";
			//****
			// 
			// ###### UNCOMMENT HERE FOR DEMO
			var now:Date = new Date();
			
			//var now:Date = new Date(2012, 0, 8); //test for TONIGHT
			//var now:Date = new Date(2012, 0, 7); //test for week of, SUNDAY 
			//var now:Date = new Date(2012, 0, 9); //test for PAST premiere date
			
			var _initStream:String = SHODateUtil.dateCheck(now);
			trace("\n _initStream: " + _initStream)
			
			switch(_initStream) {
				
				case "GENERIC":
					  vidStream15secs = myPR.parameters.vidStream15secs || "combo_728x300_zap2it_init_sun";
						vidStream = myPR.parameters.vidStream || "combo_728x300_zap2it_init_sun";
					break
				
				case "SUNDAY":
					  vidStream15secs = myPR.parameters.vidStream15secs || "combo_728x300_zap2it_init_sun";
						vidStream = myPR.parameters.vidStream || "combo_728x300_zap2it_init_sun";
					break
				
				case "TONIGHT":
					  vidStream15secs = myPR.parameters.vidStream15secsTon || "combo_728x300_zap2it_init_ton";
						vidStream = myPR.parameters.vidStreamTon || "combo_728x300_zap2it_init_ton";
					break
					
			}
			
			 
			 marker.gotoAndStop('init');
			//****	
			
			prvidMC.initVideo(adFolder);
			//prvidMC.startVideoPlay(vidStream, 1	);
			prvidMC.startVideoPlay(vidStream, 0);
			
			prvidMC._video.addEventListener(PrMediaEvent.COMPLETE, onVideoComplete);
			navMC.addEventListener(VidNavEvent.ONVID_HOL, onChooseVid);
			navMC.addEventListener(VidNavEvent.ONVID_CAL, onChooseVid);
			navMC.addEventListener(VidNavEvent.ONVID_SHA, onChooseVid);
			
					
			this.addEventListener(VidNavEvent.ONVID_HOL, onChooseVid);
			this.addEventListener(VidNavEvent.ONVID_CAL, onChooseVid);
			this.addEventListener(VidNavEvent.ONVID_SHA, onChooseVid);
			
 			
						
			///DATA STORAGE
			_ds.checkAvailability(0, 10);
			_ds.startTimer();
			
			_ds.addEventListener(DataStorageEvents.ON_DATA_STORAGE_LOAD, onDSload);
			_ds.addEventListener(DataStorageEvents.ON_DATA_STORAGE_FAIL, onDSFail);

 		}
		
		private function onDSload(e:DataStorageEvents):void 
		{
			trace("\n ###### onDSload e.type: " + e.type)
			_ds.dsAlertOnChange("vidReq", 10, dsVidRequest);
			
		}
		
		
		private function dsVidRequest(theVar:String, value:String):void 
		{
			var vidReq:String = _ds.getVariable("vidReq");
			trace("\n ###### DS vidReq: " + vidReq)
			switch(vidReq) {
				case "c1":
					trace("\n ###### c1 - Shameless")
						dispatchEvent(new VidNavEvent("sha"));
				break;
				
				case "c2":
					trace("\n ###### c2 - House of Lies")
						dispatchEvent(new VidNavEvent("hol"));
					break;
					
				case "c3":
					trace("\n ###### c3 - Californication")
						dispatchEvent(new VidNavEvent("cal"));
					break;
			}
		}
 		
		private function onDSFail(e:DataStorageEvents):void 
		{
			trace("\n ###### onDSFail e.type: " + e.type)
		}
		
		
		
		private function replayCurrVid(e:MouseEvent) {
			endFrame_MC.visible = false;
			prvidMC._video.replayVideo();
		}
		
		
		
		function callJS_skin(id:Number):void 
		{
 			/*
			1 - shameless
			2 - house of lies
			3 - californiacation 
			*/
			if (ExternalInterface.available) 
			{ 
				trace("\n callJS_skin: " + id)
				// Perform ExternalInterface method calls here. 
				ExternalInterface.call("prChangeBackground", id);
			}
			else 
			{
				trace("\n ExternalInterface.available: " + ExternalInterface.available)
			}
		}
		
		private function onChooseVid(e:VidNavEvent) {
			trace("\n ###### onChooseVid e: " + e.type)
			
 			vid_markerMC(marker).btn_twit.visible = true;
			vid_markerMC(marker).btn_fb.visible = true;
			
			var instance_Num:Number;

			switch(e.type) {
			case "hol":
					callJS_skin(2);
					_ds.setVariable("vidReq", "c2");
					
					vidID = "hol";
					if (SHODateUtil.dateCheck(new Date()) == "TONIGHT") 
					{
						vidStream = myPR.parameters.vidStream_HOL || "combo_728x300_zap2it_hol_ton_15";
						instance_Num = 7 ;//soro
					}else
					{
						vidStream = myPR.parameters.vidStream_HOL || "combo_728x300_zap2it_hol_sun_15";
						instance_Num = 4 ;//soro
					}
					
 					vid_markerMC(marker).btn_visit_hol.visible = true;
  					vid_markerMC(marker).btn_visit_cal.visible = false;
					vid_markerMC(marker).btn_visit_sha.visible = false;
					
					marker.gotoAndStop('hol');
					//instance_Num = 2 ;//soro
				break;
				
			case "sha":
				
				callJS_skin(1);
				_ds.setVariable("vidReq", "c1");
				
					vidID = "sha";
					if (SHODateUtil.dateCheck(new Date()) == "TONIGHT") 
					{
						vidStream = myPR.parameters.vidStream_SHA || "combo_728x300_zap2it_sha_ton";
						instance_Num = 6 ;//soro
					}else
					{
						vidStream = myPR.parameters.vidStream_SHA || "combo_728x300_zap2it_sha_sun";
						instance_Num = 3 ;//soro
					}
					
 					vid_markerMC(marker).btn_visit_hol.visible = false;
 					vid_markerMC(marker).btn_visit_cal.visible = false;
					
					
					//marker.addChild(vid_markerMC(marker).btn_visit_sha);
					vid_markerMC(marker).btn_visit_sha.visible = true;
					
					marker.gotoAndStop('sha')
					//instance_Num = 3 ;//soro
					
					 
				break;
				
			case "cal":
				
					callJS_skin(3);
					_ds.setVariable("vidReq", "c3");
					
					vidID = "cal";
					if (SHODateUtil.dateCheck(new Date()) == "TONIGHT") 
					{
						vidStream = myPR.parameters.vidStream_CAL || "combo_728x300_zap2it_cal_ton";
						instance_Num = 8 ;//soro
					}else
					{
						vidStream = myPR.parameters.vidStream_CAL || "combo_728x300_zap2it_cal_sun";
						instance_Num = 5 ;//soro
					}
 					vid_markerMC(marker).btn_visit_hol.visible = false;
					
					//marker.addChild(vid_markerMC(marker).btn_visit_cal);
 					vid_markerMC(marker).btn_visit_cal.visible = true;
					
					vid_markerMC(marker).btn_visit_sha.visible = false;
					
					marker.gotoAndStop('cal')
					 //instance_Num = 4 ;//soro
				break;
					
			}
			
			
			
			vid_markerMC(marker).btn_fb.addEventListener(MouseEvent.CLICK, onFB_Click);
			vid_markerMC(marker).btn_twit.addEventListener(MouseEvent.CLICK, onTwit_Click);
 			vid_markerMC(marker).btn_visit_sha.addEventListener(MouseEvent.CLICK, onSiteVisitClick);
 			vid_markerMC(marker).btn_visit_cal.addEventListener(MouseEvent.CLICK, onSiteVisitClick);
 			vid_markerMC(marker).btn_visit_hol.addEventListener(MouseEvent.CLICK, onSiteVisitClick);
			
			prvidMC.killVid();
			
			prvidMC.initVideo(adFolder);
			prvidMC.startVideoPlay(vidStream, instance_Num);
			prvidMC._video.addEventListener(PrMediaEvent.COMPLETE, onVideoComplete);
			prvidMC._video.addEventListener(PrMediaEvent.START, onVideoStart);
			//endFrame_MC.visible = false;
			
			removeTheseNow();//soro
		}

		
		private function onFB_Click(e:MouseEvent) {
			trace("\n vidID: " + vidID)
			switch(vidID){
				 
				case "sha":
					myPR.launchURL(myPR.parameters.clickTag2);//soro
					trace("---------- CLICKTAG 2");//soro
					
 					break;
				case "hol":
					myPR.launchURL(myPR.parameters.clickTag5);//soro
					trace("---------- CLICKTAG 5");//soro
					
					break;
				case "cal":
					myPR.launchURL(myPR.parameters.clickTag8);//soro
					trace("---------- CLICKTAG 8");//soro
					
					break;
			}
		}
		
		private function onTwit_Click(e:MouseEvent) {
			trace("\n vidID: " + vidID)
 			switch(vidID){
				 
				case "sha":
					myPR.launchURL(myPR.parameters.clickTag1);//soro
					trace("---------- CLICKTAG 1");//soro
					
 					break;
				case "hol":
					myPR.launchURL(myPR.parameters.clickTag4);//soro
					trace("---------- CLICKTAG 4");//soro
					
					break;
				case "cal":
					myPR.launchURL(myPR.parameters.clickTag7);//soro
					trace("---------- CLICKTAG 7");//soro
					
					break;
			}
		}
		
		private function onSiteVisitClick(e:MouseEvent) {
			trace("\n vidID: " + vidID)
 			switch(vidID){
				 
				case "sha":
					myPR.launchURL(myPR.parameters.clickTag3);//soro
					trace("---------- CLICKTAG 3");//soro
 					break;
				case "hol":
					myPR.launchURL(myPR.parameters.clickTag6);//soro
					trace("---------- CLICKTAG 6");//soro
					break;
				case "cal":
					myPR.launchURL(myPR.parameters.clickTag9);//soro
					trace("---------- CLICKTAG 9");//soro
					break;
			}
		}
		
		
		private function onVideoStart(e:PrMediaEvent):void {
			endFrame_MC.visible = false;
		}
		
		
		private function onVideoComplete(e:PrMediaEvent):void {
			trace(this + " onVideoComplete");
			trace("\n vidID: " + vidID)
			
			//trace("\n prvidMC._video._baseStreamName: " + prvidMC._video._baseStreamName)
			endFrame_MC.visible = true;
			trace("\n endFrame_MC.visible: " + endFrame_MC.visible)
			switch(vidID){
				case "init":
					endFrame_MC.gotoAndStop("init_videp") 
					navMC.gotoAndPlay(2);
 					break;
				case "sha":
					endFrame_MC.gotoAndStop("sha_videp")  
					break;
				case "cal":
					endFrame_MC.gotoAndStop("cal_videp") 		
					break;
				case "hol":
					endFrame_MC.gotoAndStop("hol_videp") 		
					break;
 				 
			}
		}
		
		private function removeTheseNow():void{
			navMC.sha_mc.buttonMode = false;
			navMC.hol_mc.buttonMode = false;
			navMC.cal_mc.buttonMode = false;
			navMC.removeEventListener(VidNavEvent.ONVID_HOL, onChooseVid);
			navMC.removeEventListener(VidNavEvent.ONVID_CAL, onChooseVid);
			navMC.removeEventListener(VidNavEvent.ONVID_SHA, onChooseVid);
			
		}//soro
	

		private function onButtonClick(e:MouseEvent):void{
			switch(e.target){
				case clickTag_btn:
					trace('click 1');
					myPR.launchURL(myPR.parameters.clickTag1);
					break;		
				//case closeBtn:
					//myPR.close();
					//myPR.pushDown(0,-352);
					//break;			
			}
		}
		
		private function btnClickTag_Click(event:MouseEvent):void{
			myPR.launchURL(myPR.parameters.clickTag1);
			trace("~~~~~ CLICKTAG 1 FIRED");
		}//soro
		
		
		
		
		 
		
		 
	}
}



