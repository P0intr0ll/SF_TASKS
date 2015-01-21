package com.pointroll.vpaid.plugins.media
{
	import PointRollAPI_AS3.events.media.PrMediaEvent;
	import PointRollAPI_AS3.events.media.PrProgressEvent;
	import PointRollAPI_AS3.media.PrVideo;
	
	import com.pointroll.vpaid.VPAIDPubProxy;
	import com.pointroll.vpaid.core.VPAIDEvent;
	import com.pointroll.vpaid.plugins.IVPAIDPlugin;
	
	public class VPAIDVideo implements IVPAIDPlugin
	{
		protected var _proxy:VPAIDPubProxy;
		public var video:PrVideo;
		
		public function VPAIDVideo(video:PrVideo)
		{
			this.video = video;
			video.addEventListener(PrMediaEvent.COMPLETE, video_CompleteHandler, false,0,true);
			video.addEventListener(PrMediaEvent.FAILURE, video_FailureHandler, false,0,true);
			video.addEventListener(PrProgressEvent.PROGRESS, video_ProgressHandler, false,0,true);
			video.addEventListener(PrMediaEvent.START, video_StartHandler, false,0,true);
			video.addEventListener(PrMediaEvent.PAUSE, video_pauseHandler, false,0,true);
			video.addEventListener(PrMediaEvent.PLAY, video_playHandler, false,0,true);
		}
		
		
		public function set publisherProxy(proxy:VPAIDPubProxy):void
		{
			_proxy = proxy;
			
		}
		
		public function destroy():void
		{
			video.removeEventListener(PrMediaEvent.COMPLETE, video_CompleteHandler);
			video.removeEventListener(PrMediaEvent.FAILURE, video_FailureHandler);
			video.removeEventListener(PrProgressEvent.PROGRESS, video_ProgressHandler);
			video.removeEventListener(PrMediaEvent.START, video_StartHandler);
			video.removeEventListener(PrMediaEvent.PAUSE, video_pauseHandler);
			video.removeEventListener(PrMediaEvent.PLAY, video_playHandler);
			video = null;
			_proxy = null;
		}
		
		
		protected function video_pauseHandler(event:PrMediaEvent):void
		{
			_proxy.dispatchEvent(new VPAIDEvent(VPAIDEvent.AdPaused,null,true));
		}
		
		protected function video_playHandler(event:PrMediaEvent):void
		{
			_proxy.dispatchEvent(new VPAIDEvent(VPAIDEvent.AdPlaying,null,true));
		}
		
		protected function video_CompleteHandler(event:PrMediaEvent):void
		{
			_proxy.dispatchEvent(new VPAIDEvent(VPAIDEvent.AdVideoComplete,null,true));
		}
		protected function video_FailureHandler(event:PrMediaEvent):void
		{
			_proxy.dispatchEvent(new VPAIDEvent(VPAIDEvent.AdError,"video failure",true));
		}
		protected function video_ProgressHandler(event:PrProgressEvent):void
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
					case 100:
						//do nothing - handled in the COMPLETE handler
						break;
					default:
						log("Unexpected milestone: "+event.milestone);
						return
				}
				
				if(e) _proxy.dispatchEvent(e);
			}
		}
		protected function video_StartHandler(event:PrMediaEvent):void
		{
			log("video started");
			_proxy.dispatchEvent(new VPAIDEvent(VPAIDEvent.AdVideoStart,null,true));
		}
		
		protected function log(message:String):void
		{
			trace(message);
			_proxy.dispatchEvent(new VPAIDEvent(VPAIDEvent.AdLog, {message: message}, true));
		}
	}
}