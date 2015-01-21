package com.pointroll.vpaid
{
	import PointRollAPI_AS3.net.URLHandler;
	
	import com.pointroll.vpaid.core.VPAIDEvent;
	import com.pointroll.vpaid.plugins.IVPAIDPlugin;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * The <code>INIT</code> event is fired to indicate that the ad may begin to load any required assets; when assets have been loaded, call the <code>readyToPlay()</code> method.
	 * @eventType flash.events.Event.INIT
	 */
	[Event(name = "init", type = "flash.events.Event")]
	
	/**
	 * The <code>START</code> event is fired to indicate that the publisher is ready for the ad to begin playback.
	 * @eventType flash.events.Event
	 */
	[Event(name = "start", type = "flash.events.Event")]
	
	/**
	 * The <code>EXPAND</code> event is fired to indicate that the ad should move into its expanded state.
	 * @eventType flash.events.Event
	 * @see VPAID#expandAd()
	 */
	[Event(name = "expand", type = "flash.events.Event")]
	
	/**
	 * The <code>COLLAPSE</code> event is fired to indicate that the ad should move into its collapsed state.
	 * @eventType flash.events.Event
	 * @see VPAID#collapseAd()
	 */
	[Event(name = "collapse", type = "flash.events.Event")]
	
	/**
	 * The <code>PAUSE</code> event is fired to indicate that the ad should pause its playback until further notice.
	 * @eventType flash.events.Event
	 * @see VPAID#pauseAd()
	 */
	[Event(name = "pause", type = "flash.events.Event")]
	
	/**
	 * The <code>RESUME</code> event is fired to indicate that the ad should resume playback.
	 * @eventType flash.events.Event
	 * @see VPAID#resumeAd()
	 */
	[Event(name = "resume", type = "flash.events.Event")]
	
	/**
	 * The <code>VOLUME_CHANGE</code> event is fired when the publisher requests a change to the ad's volume level; check the <code>volume</code> property to get the desired value.
	 * @eventType flash.events.Event
	 */
	[Event(name = "volume_change", type = "flash.events.Event")]
	
	/**
	 * The <code>UNLOAD</code> event is fired in response the the <code>stopAd()</code> function to indicate that the ad must cease playback and unload any assets.
	 * @eventType flash.events.Event.UNLOAD
	 * @see VPAID#stopAd()
	 */
	[Event(name = "unload", type = "flash.events.Event")]
	
	public class VPAID extends EventDispatcher
	{
		/** @eventType init **/
		public static const INIT:String = "init";
		/** @eventType start **/
		public static const START:String = "start";
		/** @eventType pause **/
		public static const PAUSE:String = "pause";
		/** @eventType resume **/
		public static const RESUME:String = "resume";
		
		/** @eventType volume_change **/
		public static const VOLUME_CHANGE:String = "volume_change";
		
		/** @eventType resize **/
		public static const RESIZE:String = "resize";
		/** @eventType expand **/
		public static const EXPAND:String = "expand";
		/** @eventType collapse **/
		public static const COLLAPSE:String = "collapse";
		/** @eventType unload **/
		public static const UNLOAD:String = "unload";
		
		private var _proxy:VPAIDPubProxy;
		private var plugins:Array; 
		
		public function VPAID(mainTimeline:MovieClip)
		{
			//we require the 'timeline' parameter to be a movieclip because MC is a dynamic class - and we need to add a function at runtime
			super();
			
			//establish a proxy object that will handle publisher communication
			_proxy = new VPAIDPubProxy(this);
			_proxy.addEventListener(INIT, initAd);
			_proxy.addEventListener(START, startAd);
			_proxy.addEventListener(PAUSE, pauseAd);
			_proxy.addEventListener(RESUME, resumeAd);
			_proxy.addEventListener(EXPAND, expandAd);
			_proxy.addEventListener(COLLAPSE, collapseAd);
			_proxy.addEventListener(VOLUME_CHANGE, volumeChange);
			_proxy.addEventListener(RESIZE, resizeAd);
			_proxy.addEventListener(UNLOAD, stopAd);
			
			//add the proxy to the display list to ensure event bubbling
			_proxy.visible = false;
			mainTimeline.addChild(_proxy);
			
			
			//prepare the accessor function on the main timeline
			// this function is called by our ad server as well as the publisher
			mainTimeline.getVPAID = function():*{return getVPAID()};
		}
		
		/**
		 * @private
		 * Used by our FiF wrapper to obtain a reference to the VPAID controller for this ad unit
		 */
		public function getVPAID():*
		{
			return _proxy;
		}
		
		/** Signal that the unit has been loaded by the publisher and may begin to load assets **/
		protected function initAd(e:Event=null):void
		{
			dispatchEvent(new Event(INIT));
		}
		
		/** Call the <code>readyToPlay()</code> method AFTER receiving the <code>INIT</code> event to signal to the publisher that all required ad assets have been loaded and the ad is ready to be played. **/
		public function readyToPlay():void
		{
			_proxy.issueCommand(new VPAIDEvent(VPAIDEvent.AdLoaded,null,true));
		}
		
		protected function startAd(e:Event=null):void
		{
			//theoretically the ad should be able to kick off during the flow of the Activate event, so we can handle the AdStarted event immediately after, rather than requiring the designer to fire it
			dispatchEvent(new Event(START));
			_proxy.issueCommand(new VPAIDEvent(VPAIDEvent.AdImpression,null,true));
			_proxy.issueCommand(new VPAIDEvent(VPAIDEvent.AdStarted,null,true));
		}
		
		/** Call the <code>expandAd()</code> function to trigger the unit to move into an expanded state.  Listen for the <code>EXPAND</code> event to begin your expansion. **/
		public function expandAd(e:Event=null):void
		{
			dispatchEvent(new Event(EXPAND));
			// if the function is called directly from the ad, it is in response to user interaction
			if(!e) _proxy.issueCommand(new VPAIDEvent(VPAIDEvent.AdUserAcceptInvitation,null,true));
			_proxy.adExpanded = true;
			_proxy.adLinear = true;
		}
		
		/** Call the <code>collapseAd()</code> function to trigger the unit to move into a collapsed state.  Listen for the <code>COLLAPSE</code> event to initiate the collapse. **/
		public function collapseAd(e:Event=null):void
		{
			dispatchEvent(new Event(COLLAPSE));
			// if the function is called directly from the ad, it is in response to user interaction
			if(!e) _proxy.issueCommand(new VPAIDEvent(VPAIDEvent.AdUserMinimize,null,true));
			_proxy.adExpanded = false;
			_proxy.adLinear = false;
		}
		
		/** Opens the specified click-thru URL in a new browser window.
		 * @param url The destination URL
		 * @param playerHandles Set to <code>true</code> if the publisher's player should handle launching of the URL. Default <code>false</code>
		 * @param noun An optional argument - populates the $NOUN$ macro in the click-thru URL (see the URLHandler class for details)
		 */
		public function clickThru( url:String, playerHandles:Boolean=false, noun:String=null):void
		{
			if (!playerHandles)
			{
				new URLHandler().launchURL(url, true, noun);
			}
			
			var fv:Object = parseFlashVars(url);
			//obtain click id
			var id:String = (fv.hasOwnProperty("c")) ? fv.c : "1";
			
			_proxy.issueCommand(new VPAIDEvent(VPAIDEvent.AdClickThru, {url:url, id:id, playerHandles:playerHandles},true));
		}
		
		protected function resizeAd(e:Event):void
		{
			dispatchEvent(new Event(RESIZE));
		}
		
		protected function volumeChange(e:Event):void
		{
			dispatchEvent(new Event(VOLUME_CHANGE));
			_proxy.issueCommand(new VPAIDEvent(VPAIDEvent.AdVolumeChange,null,true));
		}
		
		protected function pauseAd(e:Event=null):void
		{
			dispatchEvent(new Event(PAUSE));
			_proxy.issueCommand(new VPAIDEvent(VPAIDEvent.AdPaused,null,true));
		}
		
		protected function resumeAd(e:Event=null):void
		{
			dispatchEvent(new Event(RESUME));
			_proxy.issueCommand(new VPAIDEvent(VPAIDEvent.AdPlaying,null,true));
		}
		
		/** Call the <code>stopAd()</code> method when the user chooses to completely close the ad experience.  
		 * This will result in the broadcast of the <code>UNLOAD</code> event; your event listener should handle this by 
		 * stoping any video, audio, animations, etc.
		 **/
		public function stopAd(e:Event=null):void
		{
			dispatchEvent(new Event(UNLOAD));
			// if the function is called directly from the ad, it is in response to user interaction
			if(!e) _proxy.issueCommand(new VPAIDEvent(VPAIDEvent.AdUserClose,null,true));
			
			_proxy.issueCommand(new VPAIDEvent(VPAIDEvent.AdStopped,null,true));
			if(plugins)
			{
				while(plugins.length > 0)
				{
					var p:IVPAIDPlugin;
					try{
						p = plugins.pop();
						p.destroy();
					}catch(e:Error){}
					finally{
						p = null;
					}
				}
			}
			
		}
		
		/**
		 * True if the ad unit, in its current state, demands the user's full attention and prevents viewing of the publisher content.  This value can change during ad playback, if for instance, 
		 * the ad enters its expanded state.
		 */ 
		public function get adLinear():Boolean
		{
			return _proxy.adLinear;
		}
		public function set adLinear(l:Boolean):void
		{
			_proxy.adLinear = l;
		}
		
		/** True if the ad is currently in an expanded state. **/
		public function get adExpanded():Boolean
		{
			return _proxy.adExpanded;
		}
		
		/** The current volume level of the ad unit on a scale of 0-1. **/
		public function get adVolume():Number
		{
			return _proxy.adVolume;
		}
		
		public function set adVolume(value:Number):void
		{
			_proxy.adVolume = value;
		}

		/** The amount of time, in seconds, remaining in the ad execution.  This value is usually polled by the video player in order 
		 * to give the user a countdown until their content begins. If building a custom linear execution, you must update the value yourself.**/
		public function get adRemainingTime():Number
		{
			return _proxy.adRemainingTime;
		}
		
		public function set adRemainingTime(value:Number):void
		{
			_proxy.adRemainingTime = value;
		}
		
		/**
		 * This method alerts the publisher video player that the ad unit's total time is being extended. This allows the publisher to update any countdowns displayed to the user.
		 * It is important to use this method in "AdChooser" executions, where the length of the ad may change based on which video a user selects.
		 * 
		 * @param newTime The new total remaining time for the ad
		 **/
		public function remainingTimeChanged( newTime:Number ):void
		{
			adRemainingTime = newTime;
			_proxy.issueCommand(new VPAIDEvent(VPAIDEvent.AdRemainingTimeChange,null,true));
		}
		
		/**
		 * This signals to the publisher video player that the user interacted with the ad unit.  This should only be fired a maximum of one time per ad impression.
		 **/
		public function userAcceptedInvitation():void
		{
			_proxy.issueCommand(new VPAIDEvent(VPAIDEvent.AdUserAcceptInvitation,null,true));
		}
		
		/** The width of the area currently made available to the ad unit. 
		 *  @see #event:resize 
		 *  @see #event:init 
		 **/
		public function get width():Number
		{
			return _proxy.canvasWidth;
		}
		
		/** The height of the area currently made available to the ad unit. 
		 *  @see #event:resize 
		 * @see #event:init
		 **/
		public function get height():Number
		{
			return _proxy.canvasHeight;
		}
		
		/** The current view mode of the publisher's video player: "normal", "fullscreen" or "thumbnail" 
		 *  @see #event:resize 
		 * @see #event:init
		 **/
		public function get viewMode():String
		{
			return _proxy.viewMode;
		}
		
		/** The desired video bitrate as supplied by the publisher - currently unimplemented 
		 * @see #event:init
		 **/
		public function get desiredBitrate():Number
		{
			return _proxy.desiredBitrate;
		}
		
		/** Initialization data sent by the publisher. Could be behavioral targeting information, impression beacons and/or click thru redirects depending on the implementation 
		 * @see #event:init
		 **/
		public function get creativeData():String
		{
			return _proxy.creativeData;
		}
		
		/** Player environment data sent by the publisher.  Generally formatted as a URL "GET" variable string. 
		 * @see #event:init
		 **/
		public function get environmentVars():String
		{
			return _proxy.environmentVars;
		}
		
		public function registerPlugin(plugin:IVPAIDPlugin):void
		{
			if(!plugins) plugins = [];
			plugin.publisherProxy = _proxy;
			plugins.push( plugin );
		}
		
		private function log(message:String):void
		{
			trace(message);
		}
		
		private function parseFlashVars(url:String):Object
		{
			var fv:Object = {};
			try{
				var a:Array = String(url.split("?")[1]).split("&");
				while(a.length>0)
				{
					var b:Array = String( a.pop() ).split("=");
					fv[ String(b[0]).toLowerCase() ] = b[1];
				}
			}catch(e:Error){}
			return fv;
		}
	}
	
}
