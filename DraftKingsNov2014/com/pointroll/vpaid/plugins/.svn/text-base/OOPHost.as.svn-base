package com.pointroll.vpaid.plugins
{
	import com.pointroll.vpaid.VPAID;
	import com.pointroll.vpaid.VPAIDPubProxy;
	import com.pointroll.vpaid.core.VPAIDEvent;
	import com.pointroll.vpaid.oop.JSBridge;
	import com.pointroll.vpaid.oop.OOPCompanion;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.Security;
	
	public class OOPHost extends EventDispatcher implements IVPAIDPlugin
	{
		public static const ALL_COMPANIONS_LOADED:String = "all_companions_loaded";
		public static const ALL_COMPANIONS_READY:String = "all_companions_ready";
		
		public var name:String;
		public var bridge:JSBridge;
		public var owner:VPAID;
		private var proxy:VPAIDPubProxy;
		
		public var companions:Array = [];
		private var numCompanionsLoaded:uint = 0;
		private var numCompanionsReady:uint = 0;
		
		public function OOPHost(adName:String, owner:VPAID)
		{
			Security.allowDomain("*");
			name = adName;
			this.owner = owner;
			bridge = new JSBridge(name);
		}
		
		public function set publisherProxy(proxy:VPAIDPubProxy):void
		{
			this.proxy = proxy;
			bridge.loadExternalJS(jsLoaded);
		}
		
		private function jsLoaded():void
		{
			bridge.registerAd();
			listenForAdCommands();
			listenForPlayerCommands();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function destroy():void
		{
			bridge = null;
			proxy = null;
		}
		
		/** Adds a companion unit to the controller - this function does not cause the unit to load; use <code>loadAllCompanions</code> to begin the actual loading. 
		 * @param pid The 'serve name' of the ad placement to deliver.  This can be obtained from Traffic > Placements in AdPortal
		 * @param width Width of the ad unit
		 * @param height Height of the ad unit
		 * @param xOffset X position to place the unit, relative to the htmlAnchor
		 * @param yOffset Y position to place the unit, relative to the htmlAnchor
		 * @param htmlAnchor ID of a div or other element on the page used as a reference point for positioning
		 **/
		public function addCompanion(pid:String, xOffset:Number=0, yOffset:Number=0, htmlAnchor:String=null):void
		{
			companions.push( new OOPCompanion(pid, xOffset, yOffset, htmlAnchor) )
		}
		
		/** Loads all companion ads that have been added to the controller via <code>addCompanion</code> **/
		public function loadAllCompanions():void
		{
			bridge.addEventListener("adRegistered", companionRegistered);
			for(var i:uint=0;i<companions.length;i++)
			{
				bridge.loadCompanionAd( OOPCompanion( companions[i] ) );
			}
		}
		
		private function companionRegistered(event:String, ad:String):void
		{
			numCompanionsLoaded++;
			trace("new registration: "+ad+", "+ numCompanionsLoaded+" of "+companions.length);
			if(numCompanionsLoaded == companions.length)
			{
				trace("HOST: All companions registered");
				bridge.removeEventListener("adRegistered");
				dispatchEvent(new Event(OOPHost.ALL_COMPANIONS_LOADED));
			}
		}
		
		/** Sends the VPAID initAd() call out to all companions **/
		public function initCompanions():void
		{
			bridge.addEventListener("companionLoaded", companionInitHandler);
			broadcastJSEvent( VPAID.INIT, [proxy.canvasWidth, proxy.canvasHeight, proxy.viewMode, proxy.desiredBitrate, proxy.creativeData, proxy.environmentVars].join(",") )
		}
		
		private function companionInitHandler(event:String, data:Object):void
		{
			numCompanionsReady++;
			trace("companion ready: "+data +", num "+numCompanionsReady+" of "+companions.length);
			if(numCompanionsReady == companions.length)
			{
				dispatchEvent(new Event(OOPHost.ALL_COMPANIONS_READY));
			}
		}
		
		private function listenForAdCommands():void
		{
			bridge.addEventListener(VPAIDEvent.AdExpandedChange, handleAdExpandedChange);
			bridge.addEventListener(VPAIDEvent.AdRemainingTimeChange, handleRemainingTimeChange);
			bridge.addEventListener(VPAIDEvent.AdVolumeChange , handleVolumeChange);
			bridge.addEventListener(VPAIDEvent.AdStopped, unloadUnits, true);

			//generic broadcasts - no data handling needed
			bridge.addEventListener(VPAIDEvent.AdLinearChange, sendBridgeEventToPlayer);
			bridge.addEventListener(VPAIDEvent.AdLog, sendBridgeEventToPlayer);
			bridge.addEventListener(VPAIDEvent.AdError, sendBridgeEventToPlayer);
//			bridge.addEventListener(VPAIDEvent.AdLoaded, sendBridgeEventToPlayer);
			bridge.addEventListener(VPAIDEvent.AdStarted, sendBridgeEventToPlayer,true);
			bridge.addEventListener(VPAIDEvent.AdImpression, sendBridgeEventToPlayer,true);
			bridge.addEventListener(VPAIDEvent.AdVideoStart, sendBridgeEventToPlayer);
			bridge.addEventListener(VPAIDEvent.AdVideoFirstQuartile, sendBridgeEventToPlayer);
			bridge.addEventListener(VPAIDEvent.AdVideoMidpoint, sendBridgeEventToPlayer);
			bridge.addEventListener(VPAIDEvent.AdVideoThirdQuartile, sendBridgeEventToPlayer);
			bridge.addEventListener(VPAIDEvent.AdVideoComplete, sendBridgeEventToPlayer);
			bridge.addEventListener(VPAIDEvent.AdClickThru, sendBridgeEventToPlayer);
			bridge.addEventListener(VPAIDEvent.AdUserAcceptInvitation, sendBridgeEventToPlayer);
			bridge.addEventListener(VPAIDEvent.AdUserMinimize, sendBridgeEventToPlayer);
			bridge.addEventListener(VPAIDEvent.AdUserClose, sendBridgeEventToPlayer, true);
			bridge.addEventListener(VPAIDEvent.AdPaused, sendBridgeEventToPlayer);
			bridge.addEventListener(VPAIDEvent.AdPlaying, sendBridgeEventToPlayer);
		}

		private function handleVolumeChange(eventName:String, data:Object):void
		{
			proxy.adVolume = Number(data);
		}

		private function handleRemainingTimeChange(event:String, data:Object):void
		{
			proxy.adRemainingTime = Number(data);
		}

		private function handleAdExpandedChange(event:String, data:Object):void
		{
				proxy.adExpanded = (data == "true");
		}

		private function sendBridgeEventToPlayer(eventName:String, data:Object):void
		{
			proxy.issueCommand(new VPAIDEvent(eventName,data,true));
		}
		
		private function listenForPlayerCommands():void
		{
			//require specific handling to pass data
//			owner.addEventListener(VPAID.INIT, initAd);
			owner.addEventListener(VPAID.VOLUME_CHANGE, volumeChange);
			owner.addEventListener(VPAID.RESIZE, resizeAd);

			//generic broadcasts - no data handling needed
			owner.addEventListener(VPAID.START, rebroadcast);
			owner.addEventListener(VPAID.PAUSE, rebroadcast);
			owner.addEventListener(VPAID.RESUME, rebroadcast);
			owner.addEventListener(VPAID.EXPAND, rebroadcast);
			owner.addEventListener(VPAID.COLLAPSE, rebroadcast);
			owner.addEventListener(VPAID.UNLOAD, rebroadcast);
		}
		
		private function rebroadcast(e:Event):void
		{
			trace("host rebroadcast: "+e.type);
			broadcastJSEvent(e.type);
		}
		
		private function broadcastJSEvent(eventName:String, data:Object=null):void
		{
			bridge.broadcastEvent(eventName, data);
		}
		
		
		
		public function unloadUnits(e:String=null, data:Object=null):void
		{
			//remove all companions
			for(var i:uint=0;i<companions.length;i++)
			{
				bridge.removeCompanion( OOPCompanion(companions[i]) );
			}
			if(e) sendBridgeEventToPlayer(e,data);
		}
		
		private function volumeChange(e:Event):void
		{
			broadcastJSEvent(VPAID.VOLUME_CHANGE, { volume: proxy.adVolume } );
		}
		
		private function resizeAd(e:Event):void
		{
			broadcastJSEvent( VPAID.RESIZE, [proxy.canvasWidth, proxy.canvasHeight, proxy.viewMode ].join(","))
		}
		
		private function callProxyFunction(eventName:String, data:Object):void
		{
			trace("call proxy: "+arguments.toString());
			if(proxy[eventName] == null || !(proxy[eventName] is Function))
				return
			
			var args:Array = (data==null)?[]:String(data).split(",");
			proxy[eventName].apply(proxy, args);
		}
		
		private function setProxyProperty(name:String, value:Object):void
		{
			proxy[name] = value;
		}
	}
}