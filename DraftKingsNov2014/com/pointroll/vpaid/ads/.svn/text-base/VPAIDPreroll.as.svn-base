package com.pointroll.vpaid.ads
{
	import PointRollAPI_AS3.StateManager;
	import PointRollAPI_AS3.events.media.PrMediaEvent;
	import PointRollAPI_AS3.events.media.PrProgressEvent;
	import PointRollAPI_AS3.media.PrVideo;
	import PointRollAPI_AS3.net.URLHandler;
	
	import com.pointroll.vpaid.core.IVPAID;
	import com.pointroll.vpaid.core.VPAIDEvent;
	
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.media.Video;
	import flash.system.Security;
	
	
	public class VPAIDPreroll extends MovieClip implements IVPAID
	{
		protected var myVideo:PrVideo;
		protected var theVideo:Video;
		
		protected var _adVolume:Number = 0;
		protected var _clickThru:String;
		
		protected var availableWidth:Number;
		protected var availableHeight:Number;
		protected var viewMode:String = "normal";
		
		protected var advertiser:String;
		protected var baseVideoName:String;
		protected var videoLength:Number = 0;
		
		protected var metaData:Object;
		
		public function VPAIDPreroll()
		{
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			
			StateManager.setRoot(this);
			advertiser = StateManager.URLParameters.advertiser;
			baseVideoName = StateManager.URLParameters.baseVideoName;
			
			if(!advertiser || !baseVideoName)
			{
				dispatchEvent(new VPAIDEvent(VPAIDEvent.AdError,{message:"Missing 'advertiser' and/or 'baseVideoName' variables"},true));
			}
			
			if(StateManager.URLParameters.videoLength)
			{
				videoLength = StateManager.URLParameters.videoLength;
			}
		}
		
		public function getVPAID():*
		{
			return this;
		}
		
		/** Calculates new dimensions for a video to fit a target size.
		 * @param clipWidth The full width of the video 
		 * @param clipHeight The full height of the video
		 * @param maxWidth The maximum width available for display
		 * @param maxHeight The maximum height available for display
		 * @param scaleUp Set to true if the video should be scaled up to fill the maximum space (i.e. for fullscreen)
		 **/
		protected function getScaledDimensions(clipWidth:Number, clipHeight:Number, maxWidth:Number, maxHeight:Number, scaleUp:Boolean=false):Point
		{
			var clipWDiff:Number = clipWidth-maxWidth;
			var clipHDiff:Number = clipHeight-maxHeight;
			var clipWRatio:Number = (clipWDiff>0)?clipWDiff/clipWidth: (scaleUp ? clipWDiff/clipWidth:0);
			var clipHRatio:Number = (clipHDiff>0)?clipHDiff/clipHeight: (scaleUp ? clipHDiff/clipHeight:0);
			
			var scale:Number = Math.max(clipWRatio, clipHRatio);
			
			return new Point(clipWidth * (1-scale), clipHeight * (1-scale));
		}
		
		/** IVPAID **/
		// Properties
		public function get adLinear() : Boolean { return true; };
		public function get adExpanded() : Boolean { return false; }
		public function get adRemainingTime() : Number 
		{
			var n:Number = -2;
			try{
//				log(myVideo.totalTime +"-"+ myVideo.currentTime +"="+(myVideo.totalTime - myVideo.currentTime));
				n = Number(Number(myVideo.totalTime - myVideo.currentTime).toFixed(2));
			}catch(e:Error)
			{
				log("Unable to access video object: "+e.message);
			}
			return n;
		}
		public function get adVolume() : Number
		{
			try{
				_adVolume = myVideo.volume;
			}catch(e:Error)
			{
				log("Unable to access video object: "+e.message);
			}
			
			return _adVolume;
		}
		public function set adVolume(value : Number) : void
		{
			_adVolume = value;
			try{
				myVideo.volume = _adVolume;
			}catch(e:Error)
			{
				log("Unable to access video object: "+e.message);
			}
			
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdVolumeChange,null,true));
		}
		
		// Methods
		public function handshakeVersion(playerVPAIDVersion : String) : String
		{
			return "1.0";
		}
		public function initAd(width : Number, height : Number, viewMode : String, desiredBitrate : Number, creativeData :String=null, environmentVars : String=null) : void
		{
			log("initAd("+ arguments.join(',') +")");
			
			availableWidth = width;
			availableHeight = height;
			this.viewMode = viewMode;
			
			dispatchEvent( new VPAIDEvent(VPAIDEvent.AdLoaded,null,true));
		}
		
		public function resizeAd(width : Number, height : Number, viewMode : String) : void
		{
			availableWidth = width;
			availableHeight = height;
			this.viewMode = viewMode;
			scaleVideo();
		}
		
		public function startAd():void
		{
			log("startAd()");
			
			drawBackground();
			
			theVideo = new Video(availableWidth,availableHeight);
			addChild(theVideo);
			
			myVideo	= new PrVideo(advertiser, baseVideoName, baseVideoName, videoLength, theVideo, _adVolume,1);
			
			addVideoListeners();
			myVideo.startVideo();
			log("video started");
			
			//listen for click thru
			try{
				_clickThru = this.root.loaderInfo.parameters.clickTag1;
			}catch(e:Error)
			{
				log("Cannot assign clickTag: "+e.message);
			}
			
			if(_clickThru)
			{
				var cta:Sprite = new Sprite();
				cta.graphics.beginFill(0xff000000,0);
				cta.graphics.drawRect(0,0,availableWidth, availableHeight);
				cta.graphics.endFill();
				
				cta.buttonMode = true;
				cta.useHandCursor = true;
				
				addChild(cta);
				cta.addEventListener(MouseEvent.CLICK, launchClickThru, false,0,true);
			}
		}
		
		protected function addVideoListeners():void
		{
			myVideo.addEventListener(PrMediaEvent.ONMETADATA, myVideo_onMetaData, false,0,true);
			myVideo.addEventListener(PrMediaEvent.COMPLETE, myVideo_CompleteHandler, false,0,true);
			myVideo.addEventListener(PrMediaEvent.FAILURE, myVideo_FailureHandler, false,0,true);
			myVideo.addEventListener(PrProgressEvent.PROGRESS, myVideo_ProgressHandler, false,0,true);
			myVideo.addEventListener(PrMediaEvent.START, myVideo_StartHandler, false,0,true);
			myVideo.addEventListener(PrMediaEvent.PAUSE, myVideo_pauseHandler, false,0,true);
			myVideo.addEventListener(PrMediaEvent.PLAY, myVideo_playHandler, false,0,true);
		}
		
		protected function removeVideoListeners():void
		{
			myVideo.removeEventListener(PrMediaEvent.ONMETADATA, myVideo_onMetaData);
			myVideo.removeEventListener(PrMediaEvent.COMPLETE, myVideo_CompleteHandler);
			myVideo.removeEventListener(PrMediaEvent.FAILURE, myVideo_FailureHandler);
			myVideo.removeEventListener(PrProgressEvent.PROGRESS, myVideo_ProgressHandler);
			myVideo.removeEventListener(PrMediaEvent.START, myVideo_StartHandler);
			myVideo.removeEventListener(PrMediaEvent.PAUSE, myVideo_pauseHandler);
			myVideo.removeEventListener(PrMediaEvent.PLAY, myVideo_playHandler);
		}
		
		public function stopAd() : void
		{
			log("stopAd()");
			try{
				removeVideoListeners();
				
				myVideo.killVideo();
				myVideo = null;
			}catch(e:Error)
			{
				log("Unable to access video object: "+e.message);
			}
			
			try{
				removeChild(theVideo);
				theVideo.clear();
				theVideo = null;
			}catch(e:Error)
			{
				log("Unable to access video object: "+e.message);
			}
			
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdStopped,null,true));
		}
		public function pauseAd() : void
		{
			log("pauseAd()");
			try{
				myVideo.pause();
			}catch(e:Error)
			{
				log("Unable to access video object: "+e.message);
			}
		}
		public function resumeAd() : void
		{
			log("resumeAd()");
			try{
				myVideo.play();
			}catch(e:Error)
			{
				log("Unable to access video object: "+e.message);
			}
		}
		
		protected function myVideo_onMetaData(event:PrMediaEvent):void
		{
			metaData = myVideo.metaData;
			
			scaleVideo();
		}
		
		protected function myVideo_pauseHandler(event:PrMediaEvent):void
		{
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdPaused,null,true));
		}
		
		protected function myVideo_playHandler(event:PrMediaEvent):void
		{
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdPlaying,null,true));
		}
		
		protected function myVideo_CompleteHandler(event:PrMediaEvent):void
		{
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdVideoComplete,null,true));
			stopAd();
		}
		protected function myVideo_FailureHandler(event:PrMediaEvent):void
		{
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdError,"video failure",true));
		}
		protected function myVideo_ProgressHandler(event:PrProgressEvent):void
		{
			if(event.milestone > -1)
			{
				log("video milestone: "+event.milestone);
				var e:VPAIDEvent;
				switch(event.milestone)
				{
					case 25:
						e = new VPAIDEvent(VPAIDEvent.AdVideoFirstQuartile,null,true);
						break;
					case 50:
						e = new VPAIDEvent(VPAIDEvent.AdVideoMidpoint,null,true);
						break;
					case 75:
						e = new VPAIDEvent(VPAIDEvent.AdVideoThirdQuartile,null,true);
						break;
					default:
						log("Unexpected milestone: "+event.milestone);
						return
				}
				
				if(e) dispatchEvent(e);
			}
		}
		protected function myVideo_StartHandler(event:PrMediaEvent):void
		{
			log("video started");
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdImpression,null,true));
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdStarted,null,true));
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdVideoStart,null,true));
		}
		
		protected function drawBackground():void
		{
			var g:Graphics = this.graphics;
			g.clear();
			g.beginFill(0x000000);
			g.drawRect(0,0,availableWidth,availableHeight);
			g.endFill();
		}
		
		protected function scaleVideo():void
		{
			removeChild(theVideo);
			drawBackground();
			
			var w:Number;
			var h:Number;
			
			try{
				w = metaData.width;
				h = metaData.height;
			}catch(e:Error)
			{
				return
			}
			var p:Point = getScaledDimensions(w,h,availableWidth,availableHeight, viewMode == "fullscreen" ? true:false);
			theVideo.width = p.x;
			theVideo.height = p.y;
			
			theVideo.x = (availableWidth/2) - (theVideo.width /2);
			theVideo.y = (availableHeight/2) - (theVideo.height /2);
			addChild(theVideo);
		}
		
		protected function launchClickThru(e:MouseEvent):void
		{
			log("clickThru");
			if(_clickThru)
			{
				//Let the player handle the click thru so the popup blocking becomes their issue
				var clk:VPAIDEvent = new VPAIDEvent(VPAIDEvent.AdClickThru, {url:_clickThru, id:1, playerHandles:false},true);
				new URLHandler().launchURL(_clickThru);
				dispatchEvent(clk);
				log("Clickthru sent to player: "+_clickThru);
			}
		}
		
		/** Not implemented for pre-roll **/
		public function expandAd() : void 
		{
			log("expandAd not implemented");
		}
		public function collapseAd() : void 
		{
			log("collapseAd not implemented");
		}
		
		protected function log(message:String) : void 
		{
			trace("PRLog:> "+message);
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdLog,{message:"VPAIDPreroll: "+message},true));
		}
		
	}
}