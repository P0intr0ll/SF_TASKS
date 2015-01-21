package com.pointroll 
{
	import flash.display.*;
	import flash.events.*;
	import flash.media.Video;
	import flash.utils.Timer;
	import pointroll.*;
	import pointroll.info.getVideoDeliveryMethod;
	import com.pointroll.api.events.*;
	import com.pointroll.api.media.*;
	import com.pointroll.api.media.definition.PointRollBasicVideoDefinition;
	
 	import com.greensock.TweenLite;
 	import com.greensock.plugins.*;
	/**
	 * ...
	 * @author slee@pointroll
	 */
	public class PrUI_VidMC_v7 extends MovieClip 
	{
 		public var Advertiser:String;
		public var VideoFileName:String;
		public var VideoFileName2:String;
		public var VideoFileName3:String;
		public var prVidObj:PointrollVideo  ;
		//var theVideoScreen:Video
		var VideoInstance:Number;
		var VideoMethod:Number;
		public var VideoDef:PointRollBasicVideoDefinition;
 		public var startPlaybtn:MovieClip;
  		public var progBar:MovieClip 
 		public var nav:MovieClip 
 		public var mcBuffering:MovieClip 
		TweenPlugin.activate([AutoAlphaPlugin]);
		public var theVideoScreen:Video
		public var mcToggleSoundBtn:Object
		public var mcToggleVideoPlayingBtn:Object
		public var btnReplayRestart:Object
 		
		public function PrUI_VidMC_v7() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, killVid);
  		}
		
		private function init(evt:Event) {
			removeEventListener(Event.ADDED_TO_STAGE, init);
		
			mcToggleSoundBtn.alpha = 0;
			mcToggleVideoPlayingBtn.alpha = 0;
  			//btnReplayRestart.visible = false;
  			mcBuffering.visible = false;
  			progBar.visible = false;
			
			//get a PointRoll instance
  			pointroll.initAd(this);
			startPlaybtn.buttonMode = true;
 			startPlaybtn.addEventListener(MouseEvent.CLICK, onVidNavBtn);
			startPlaybtn.addEventListener(MouseEvent.ROLL_OVER, onVidNavBtn);
			startPlaybtn.addEventListener(MouseEvent.ROLL_OUT, onVidNavBtn);
			
 			
		}
		
		
		
 		
		private function onVidNavBtn(e:MouseEvent) {
			//trace("\n VideoFileName: " + this.VideoFileName)
			//trace("\n VideoFileName2: " + this.VideoFileName2)
			switch (e.type) 
			{
				case "click":
					startPlaybtn.visible = false;
 					var adv:String = getFlashVar("advertiser") || "Showtime";
					//trace("\n hasConnected: " + hasConnected)
					if (hasConnected) 
					{
						killVid();
					}
 					
 					//trace("\n e.currentTarget.name: " + e.currentTarget.name)
					if (e.currentTarget.name == "startPlaybtn" ) 
					{
						
						prVidObj.playVideo(VideoDef);					
 						
						trace("*************************************" + VideoInstance)
						switch (String(VideoInstance)) {
							case "1":
							pointroll.trackActivity(3);
							break;
							case "3":
							pointroll.trackActivity(7);
							break;
							case "5":
							pointroll.trackActivity(11);
							break;
						}

						//set switch so we know when the video is connected?
						hasConnected = true;
  						
    				}
 				break;
				
				case "rollOver":
					MovieClip(e.currentTarget).gotoAndPlay("in");
				break;
				case "rollOut":
					MovieClip(e.currentTarget).gotoAndPlay("out");
				break;
				
				default:
			}
  		}
 		
		 
		private function skipit(e:MouseEvent) {
 			//prVidObj = null;
			prVidObj.destroy();
			trace("\n prVidObj: " + prVidObj)
			trace("\n ############ skipit: " )
			
		}
		
		public var hasConnected:Boolean = false; 		
		public function initPlayer(adv:String, file:String, instance:Number, Stream2:String=null, Stream3:String=null):void 
		{
			startPlaybtn.visible = true;
			//Advertiser = adv;
			mcToggleSoundBtn.gotoAndStop(1);
			theVideoScreen.alpha = 0;
			mcToggleSoundBtn.alpha = 0;
			mcToggleVideoPlayingBtn.alpha = 0;
   			mcBuffering.visible = false;
  			progBar.visible = false;

			if (file!=null && Stream2!=null && Stream3!=null ) 
			{
				VideoFileName = file;
				VideoFileName2 = Stream2;
				VideoFileName3 = Stream3;
					trace("\n #########  " )
					trace(" VideoFileName: " + VideoFileName)
					trace(" VideoFileName2: " + VideoFileName2)
					trace(" VideoFileName3: " + VideoFileName3)
			}
 			
			VideoInstance = instance;
  			VideoMethod	= pointroll.info.getVideoDeliveryMethod() || 1; // 1 streaming, 0 progressive
 			
			//Make sure the value 'theVideoScreen' is the instance of your video object
			prVidObj = new PointrollVideo(theVideoScreen,  VideoMethod );
			//prVidObj.progressTracker.clipDurationAmount = 0.025;
			prVidObj.autoKillTimeout = 0;
 			prVidObj.progressTracker.addEventListener(PrProgressEvent.MEDIA_START, startHandler);
			prVidObj.progressTracker.addEventListener(PrProgressEvent.MEDIA_COMPLETE, onVideoComplete);
			prVidObj.progressTracker.addEventListener(PrProgressEvent.MEDIA_PROGRESS, onProgressCheck);
			prVidObj.progressTrackingEnabled = false;
			
			
			VideoDef = new PointRollBasicVideoDefinition(adv, file, VideoInstance);
 				trace("\n VideoInstance: " + VideoInstance)
				
			mcToggleVideoPlayingBtn.buttonMode = true;
 			mcToggleSoundBtn.buttonMode = true;
			
			mcToggleSoundBtn.addEventListener(MouseEvent.CLICK, toggleSound);
			mcToggleVideoPlayingBtn.addEventListener(MouseEvent.CLICK, togglePlayPause);
			
			mcToggleVideoPlayingBtn.addEventListener(MouseEvent.ROLL_OUT, togglePlayPauseOVR);
			mcToggleVideoPlayingBtn.addEventListener(MouseEvent.ROLL_OVER, togglePlayPauseOVR);
			mcToggleSoundBtn.addEventListener(MouseEvent.ROLL_OUT, togglePlayPauseOVR);
			mcToggleSoundBtn.addEventListener(MouseEvent.ROLL_OVER, togglePlayPauseOVR);
			
			btnReplayRestart.addEventListener(MouseEvent.CLICK, restartVid);
 			addEventListener(PointRollEvent.PANEL_CLOSED, killVid);
			
			
			prVidObj.volume = 0;
			prVidObj.playVideo(VideoDef);	
			
			
		}
			
			
		public function toggleSound(e:MouseEvent=null):void {
 			if (prVidObj.volume>0) 
			{
				prVidObj.mute();
				mcToggleSoundBtn.gotoAndStop(2);
			}else 
			{
				prVidObj.unmute();
				mcToggleSoundBtn.gotoAndStop(1);
			}			
			
		}
		
		private function togglePlayPauseOVR(e:MouseEvent):void {
			
			TweenPlugin.activate([TintPlugin, RemoveTintPlugin]);

			switch (e.type) 
			{
				case "rollOver":
					TweenLite.to(e.currentTarget, 0.4, {tint:0xFFFFFF } );
				break;
				case "rollOut":
					TweenLite.to(e.currentTarget, 0.4, {removeTint:true});
				break;
				
 			}
		}
		
		private function togglePlayPause(e:MouseEvent):void {
			//trace("\n prVidObj.isPlaying: " + prVidObj.isPlaying)
			if (prVidObj.isPlaying) 
			{
				prVidObj.pause();
				MovieClip(e.currentTarget).gotoAndStop("paused")
			}else 
			{
				prVidObj.resume();
				MovieClip(e.currentTarget).gotoAndStop("playing")
			}
		}
  		
		
		private function restartVid(e:MouseEvent = null):void {
 			TweenLite.to(btnReplayRestart, 1, {autoAlpha:0 } );
 			prVidObj.restartWithSound();
			mcToggleVideoPlayingBtn.gotoAndStop("playing")
			prVidObj.progressTrackingEnabled=true;	//Turns on video tracking.
 		}
		
		function setNav(mcOFF:MovieClip, mcON:MovieClip) {
			
			MovieClip(mcOFF).removeEventListener(MouseEvent.CLICK, onVidNavBtn);
 			MovieClip(mcOFF).removeEventListener(MouseEvent.ROLL_OVER, onVidNavBtn);
			MovieClip(mcOFF).removeEventListener(MouseEvent.ROLL_OUT, onVidNavBtn);	
			
			MovieClip(mcON).addEventListener(MouseEvent.CLICK, onVidNavBtn);
 			MovieClip(mcON).addEventListener(MouseEvent.ROLL_OVER, onVidNavBtn);
			MovieClip(mcON).addEventListener(MouseEvent.ROLL_OUT, onVidNavBtn);	
			
			MovieClip(mcOFF).gotoAndStop("on");
			MovieClip(mcON).gotoAndStop(1);
		}
			
		private function startHandler(e:Event):void
		{
			trace("\n ############## CURRENTLY PLAYING VideoInstance: " + VideoInstance);
			if (prVidObj.volume == 0) 
			{
				startPlaybtn.visible = true;
			}else 
			{
				startPlaybtn.visible = false;
			}
			
			
			//TweenLite.to(btnReplayRestart, 0, {autoAlpha:0 } );
   			
			mcToggleVideoPlayingBtn.gotoAndStop("playing");
			progBar.visible = true;

			//TweenLite.to(mcBuffering, .5, { alpha:0 } );		
			TweenLite.to(theVideoScreen, .5, { alpha:1 } );		
			
			
			if (prVidObj.progressTrackingEnabled) 
			{
				TweenLite.to(btnReplayRestart, .5, { alpha:0 } );	
			}else 
			{
				TweenLite.to(btnReplayRestart, .5, { alpha:1 } );	
			}
 			
			
			
			//TweenLite.to(btnReplayRestart, 1, {autoAlpha:0 } );
			TweenLite.to(mcToggleVideoPlayingBtn, .5, { alpha:1 } );		
			TweenLite.to(mcToggleSoundBtn, .5, { alpha:1 } );		
			
 			
		}
		
  		
		private function onVideoComplete(e:PrProgressEvent):void
		{
			trace("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~		video completed");
			
			TweenLite.to(btnReplayRestart, 1, {autoAlpha:1 } );
 			TweenLite.to(theVideoScreen, .5, { alpha:0 } );		
 		}
		
		private function onProgressCheck(e:PrProgressEvent):void{
			//trace(' ~~~~~~ time is', e.currentTime);
			//trace(' ~~~~~~ totalTime is', e.totalTime);
			var perc:Number = e.currentTime / e.totalTime;
			//trace("\n perc: " + perc)
			MovieClip(progBar.progressFill).scaleX = perc;
				
			if (e.currentTime == e.totalTime) 
			{
				trace("\n Finished Video: " )
				//prVidObj.progressTracker.removeEventListener(PrProgressEvent.MEDIA_PROGRESS, onProgressCheck);
			}
		}
			
 		
		public function killVid(evt:Event = null) {
 			prVidObj.progressTracker.removeEventListener(PrProgressEvent.MEDIA_START, startHandler);
			prVidObj.progressTracker.removeEventListener(PrProgressEvent.MEDIA_COMPLETE, onVideoComplete);
			prVidObj.progressTracker.removeEventListener(PrProgressEvent.MEDIA_PROGRESS, onProgressCheck);

			prVidObj.disconnect() ;
			hasConnected = false;
		}	
		
	}

}