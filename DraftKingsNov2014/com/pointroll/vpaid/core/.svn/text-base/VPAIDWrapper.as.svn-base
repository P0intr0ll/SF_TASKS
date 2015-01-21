package com.pointroll.vpaid.core
{
	import com.pointroll.vpaid.player.VPAIDAdProxy;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	
	public class VPAIDWrapper extends Sprite  implements IVPAID
	{
//		public var adTagURL:String = "http://speed.webdeely.com/Preroll.swf";
//		public var adTagURL:String = "http://localhost/vpaid/player/Preroll.swf?vpaidVersion=1.0&clickTag1=http://clk.pointroll.com/bc/?a=0%26c=1%26i=0%26clickurl=http://www.pointroll.com";
//		public var adTagURL:String = "http://localhost/vpaid/player/ProjectHanley_270x203_AS3_VPAID_r2.swf?vpaidVersion=1.0&clickTag1=http://clk.pointroll.com/bc/?a=0%26c=1%26i=0%26clickurl=http://www.pointroll.com";
		public var adTagURL:String = "                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ";
		protected var loader:Loader;
		
		/** TODO: Make this a generic object to avoid the extra k-weight of the class & interface **/
		protected var proxy:VPAIDAdProxy;
		
		protected var flashVars:Object;
		private var vpaidVersion:String;
		
		protected var initArgs:Array;
		
		public function VPAIDWrapper()
		{
			log("wrapper constructor");
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			if(this.root.loaderInfo.parameters.tag)
			{
				trace(this.root.loaderInfo.parameters.tag);
				adTagURL = this.root.loaderInfo.parameters.tag;
			}
			flashVars = parseFlashVars(adTagURL);
			if(flashVars.hasOwnProperty("vpaidversion"))
			{
				// this is a vpaid ad - save the version and wait for init
				vpaidVersion = flashVars.vpaidversion;
			}else{
				// standard FiF (non-vpaid) - load immediately
				vpaidVersion = null;
				loadAdTag();
			}
		}

		private function parseFlashVars(u:String):Object
		{
			var fv:Object = {};
			try{
				var a:Array = u.substr(u.indexOf("?")+1).split("&");
				while(a.length>0)
				{
					var b:Array = String( a.pop() ).split("=");
					fv[ String(b[0]).toLowerCase() ] = b[1];
				}
			}catch(e:Error){}
			return fv;
		}
		
		public function getVPAID():*
		{
			return vpaidVersion ? this:null;
		}
		
		public function handshakeVersion(v : String):String 
		{
			if(proxy)
				return proxy.handshakeVersion(v);
			else
			{
				return vpaidVersion;
			}
			
		}
		// Properties
		public function get adLinear():Boolean 
		{
			if(proxy)
				return proxy.adLinear;
			else
			{
				if(flashVars.hasOwnProperty("adlinear"))
				{
					return String(flashVars.adlinear).toLowerCase()=="true";
				}
				return true
			}
		}
		
		public function initAd(width:Number, height:Number, viewMode:String, desiredBitrate:Number, creativeData:String=null, environmentVars : String=null):void 
		{
			log("init ad( "+arguments.toString()+" )");
			initArgs = arguments;
			loadAdTag();
		}
		
		private function loadAdTag():void
		{
			//strip the trailing spaces left by the ad server
			var space:int = adTagURL.indexOf(" ");
			if(space > -1)
			{
				adTagURL = adTagURL.substring(0,space);
			}
			var request:URLRequest = new URLRequest( adTagURL );
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, adLoaded, false,0,true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError, false,0,true);
			addChild(loader);
			//The ApplicationDomain and SecurityDomain features can't be used when testing locally
			try{
				loader.load( request, new LoaderContext(false,ApplicationDomain.currentDomain,SecurityDomain.currentDomain) );
			}catch (e:Error)
			{
				removeChild(loader);
				loader = null;
				dispatchEvent(new VPAIDEvent(VPAIDEvent.AdError, e));
			}
		}
		
		protected function adLoaded( event:Event ):void
		{
			trace("Wrapper - Ad Has been loaded:" +event.target.width + ", "+event.target.height);
			
			if(vpaidVersion)
			{
				proxy = new VPAIDAdProxy(MovieClip(loader.content).getVPAID());
				proxy.addEventListener(VPAIDEvent.AdLog, logEventHandler, false, 0, true);
				proxy.addEventListener(VPAIDEvent.AdStopped, cleanup, false, 0, true);
				proxy.addEventListener(VPAIDEvent.AdError, cleanup, false, 0, true);
				
				//pass the initial arguments through
				proxy.initAd.apply(proxy, initArgs);
			}else{
				dispatchEvent( new Event("onAdLoadComplete"));
			}
		}
		
		protected function ioError( error:IOErrorEvent ):void
		{
			trace("Cannot load ad tag: "+error.text);
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdError, error.text));
		}
		
		public function get adExpanded():Boolean 
		{
			return proxy.adExpanded;
		}
		public function get adRemainingTime():Number 
		{
			return proxy.adRemainingTime;
		}
		public function get adVolume():Number 
		{
			return proxy.adVolume;
		}
		public function set adVolume(value:Number):void 
		{
			proxy.adVolume = value;
		}
		// Methods
		
		
		public function resizeAd(width:Number, height:Number, viewMode:String):void 
		{
			proxy.resizeAd(width, height, viewMode);
		}
		public function startAd():void {
			proxy.startAd();
		}
		public function stopAd():void {
			proxy.stopAd();
		}
		public function pauseAd():void {
			proxy.pauseAd();
		}
		public function resumeAd():void {
			proxy.resumeAd();
		}
		public function expandAd():void {
			proxy.expandAd();
		}
		public function collapseAd():void {
			proxy.collapseAd();
		}
		
		protected function logEventHandler(e:Event):void
		{
			log("AdLog received: "+Object(e).data.message);
		}
		
		protected function log(message:String) : void 
		{
			trace("Wrapper:> "+message);
		}
		
		protected function cleanup(e:Event):void
		{
			try{
				removeChild(loader);
				loader.close();
			}catch(e:Error){}
			
			loader = null;
		}
	}
}