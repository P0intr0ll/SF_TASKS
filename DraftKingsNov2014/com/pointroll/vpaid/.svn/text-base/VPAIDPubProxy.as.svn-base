package com.pointroll.vpaid
{
	import com.pointroll.vpaid.VPAID;
	import com.pointroll.vpaid.core.IVPAID;
	import com.pointroll.vpaid.core.VPAIDEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class VPAIDPubProxy extends Sprite implements IVPAID
	{
		private var _owner:VPAID;
		private var _adLinear:Boolean = false;
		private var _adExpanded:Boolean = false;
		private var _remainingTime:Number = -1;
		
		public var canvasWidth:Number;
		public var canvasHeight:Number;
		public var viewMode:String;
		public var desiredBitrate:Number;
		public var creativeData:String;
		public var environmentVars:String;
		public var volume:Number = 1;
		
		public function VPAIDPubProxy( owner:VPAID )
		{
			_owner = owner;
			addEventListener(Event.ADDED, readFlashVars);
		}
		
		protected function readFlashVars(e:Event):void
		{
			removeEventListener(Event.ADDED, readFlashVars);
			if(this.root)
			{
				var fv:Object = this.root.loaderInfo.parameters;
				if(fv.adLinear)
					_adLinear = String(fv.adLinear).toLowerCase() == 'true';
			}
		}
		
		public function get adLinear():Boolean
		{
			return _adLinear;
		}
		public function set adLinear(l:Boolean):void
		{
			_adLinear = l;
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdLinearChange, null, true));
		}
		
		public function handshakeVersion(playerVPAIDVersion:String):String
		{
			return "1.0";
		}
		
		public function initAd(width:Number, height:Number, viewMode:String, desiredBitrate:Number, creativeData:String=null, environmentVars:String=null):void
		{
			this.canvasWidth = width;
			this.canvasHeight = height;
			this.viewMode = viewMode;
			this.desiredBitrate = desiredBitrate;
			this.creativeData = creativeData;
			this.environmentVars = environmentVars;
			
			dispatchEvent(new Event(VPAID.INIT));
		}
		
		public function startAd():void
		{
			dispatchEvent(new Event(VPAID.START));
		}
		
		public function set adExpanded(exp:Boolean):void
		{
			_adExpanded = exp;
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdExpandedChange,null,true));
		}
		public function get adExpanded():Boolean
		{
			return _adExpanded;
		}
		
		public function get adRemainingTime():Number
		{
			return _remainingTime;
		}

		public function set adRemainingTime(t:Number):void
		{
			_remainingTime = t;
		}
		
		public function get adVolume():Number
		{
			return volume;
		}
		
		public function set adVolume(value:Number):void
		{
			volume = value;
			dispatchEvent(new Event(VPAID.VOLUME_CHANGE));
		}
		
		public function resizeAd(width:Number, height:Number, viewMode:String):void
		{
			this.canvasWidth = width;
			this.canvasHeight = height;
			this.viewMode = viewMode;
			dispatchEvent(new Event(VPAID.RESIZE));
		}
		
		public function stopAd():void
		{
			dispatchEvent(new Event(VPAID.UNLOAD));
		}
		
		public function pauseAd():void
		{
			dispatchEvent(new Event(VPAID.PAUSE));
		}
		
		public function resumeAd():void
		{
			dispatchEvent(new Event(VPAID.RESUME));
		}
		
		public function expandAd():void
		{
			dispatchEvent(new Event(VPAID.EXPAND));
		}
		
		public function collapseAd():void
		{
			dispatchEvent(new Event(VPAID.COLLAPSE));
		}
		
		public function issueCommand(e:Event):void
		{
			dispatchEvent(e);
		}
	}
}