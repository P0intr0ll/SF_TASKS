package com.pointroll.vpaid.player {
	import com.pointroll.vpaid.core.VPAIDEvent;

	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	public class VPAIDPlayer extends Sprite
	{
//		protected var adTag:String = "http://ads.webdeely.com/Wrapper.swf";
		protected var adTag:String = "http://localhost/vpaid/player/Wrapper.swf";
		protected var adLoader:Loader;
		
		protected var proxy:VPAIDAdProxy;
		protected var VPAIDversion:String;
		protected var adLinear:Boolean;
		
		protected var adWidth:Number = 900;
		protected var adHeight:Number = 375;
		
		public function VPAIDPlayer()
		{
			var g:Graphics = this.graphics;
			g.beginFill(0xff0000);
			g.drawRect(0,0,adWidth,adHeight);
			g.endFill();
			
			var req:URLRequest = new URLRequest(adTag);
			adLoader = new Loader();
			adLoader.contentLoaderInfo.addEventListener(Event.INIT, adLoaded, false, 0, true);
			adLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError, false, 0, true);
			
			addChild(adLoader);
			adLoader.load(req);
			
			
		}
		
		protected function adLoaded(e:Event):void
		{
			proxy = new VPAIDAdProxy(Object(adLoader.content).getVPAID());
			VPAIDversion = proxy.handshakeVersion("1.0");
			adLinear = proxy.adLinear;
			
			trace("Player loaded ad: version > "+VPAIDversion + ", linear > "+adLinear);
			
			//loading
			proxy.addEventListener(VPAIDEvent.AdLoaded, vpaidAdLoaded, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdImpression, eventLogger, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdStarted, eventLogger, false,0,true);
			
			//changes
			proxy.addEventListener(VPAIDEvent.AdLinearChange, eventLogger, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdExpandedChange, eventLogger, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdRemainingTimeChange, eventLogger, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdVolumeChange, eventLogger, false,0,true);
			
			//video
			proxy.addEventListener(VPAIDEvent.AdVideoStart, eventLogger, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdVideoFirstQuartile, eventLogger, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdVideoMidpoint, eventLogger, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdVideoThirdQuartile, eventLogger, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdVideoComplete, eventLogger, false,0,true);
			
			//interaction
			proxy.addEventListener(VPAIDEvent.AdClickThru, eventLogger, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdUserAcceptInvitation, eventLogger, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdUserMinimize, eventLogger, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdUserClose, eventLogger, false,0,true);

			//playback
			proxy.addEventListener(VPAIDEvent.AdPaused, eventLogger, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdPlaying, eventLogger, false,0,true);
			
			//LOGGING
			proxy.addEventListener(VPAIDEvent.AdLog, eventLogger, false,0,true);
			proxy.addEventListener(VPAIDEvent.AdError, eventLogger, false,0,true);
		
			//finished
			proxy.addEventListener(VPAIDEvent.AdStopped, eventLogger, false,0,true);
			
			proxy.initAd(adWidth,adHeight,"normal",700);
			
		}
		protected function ioError(e:IOErrorEvent):void
		{
			trace("IOERROR: "+e.toString());
		}
		
		protected function vpaidAdLoaded(e:Event):void
		{
			proxy.startAd();
		}
		
		protected function eventLogger(e:Event):void
		{
			trace("Ad Event:> "+e.type);
		}
		
		private function pauseAd(e:Event):void
		{
			this.proxy.pauseAd();
		}
		
		private function resumeAd(e:Event):void
		{
			this.proxy.resumeAd();
		}
		private function resizeAd(e:Event):void
		{
			this.proxy.resizeAd(800,200,"normal");
		}
	}
}