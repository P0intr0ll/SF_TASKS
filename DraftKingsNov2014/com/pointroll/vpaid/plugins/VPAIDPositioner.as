package com.pointroll.vpaid.plugins
{
	import com.pointroll.vpaid.VPAIDPubProxy;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	public class VPAIDPositioner extends EventDispatcher implements IVPAIDPlugin
	{
		//Positioning Constants
		public static const TOP_LEFT:String = "top_left";
		public static const TOP_CENTER:String = "top_center";
		public static const TOP_RIGHT:String = "top_right";
		public static const MIDDLE_LEFT:String = "middle_left";
		public static const MIDDLE_CENTER:String = "middle_center";
		public static const MIDDLE_RIGHT:String = "middle_right";
		public static const BOTTOM_LEFT:String = "bottom_left";
		public static const BOTTOM_CENTER:String = "bottom_center";
		public static const BOTTOM_RIGHT:String = "bottom_right";
		
		public var position:String = BOTTOM_CENTER;
		public var targetClip:DisplayObject;
		
		public var adWidth:Number;
		public var adHeight:Number;
		
		public var playerWidth:Number;
		public var playerHeight:Number; 
		public var viewMode:String = "normal";
		
		public var xOffset:Number = 0;
		public var yOffset:Number = 0;
		
		public var coordinates:Point;
		
		private var _proxy:VPAIDPubProxy;
		
		public function VPAIDPositioner(targetClip:DisplayObject=null)
		{
			this.targetClip = targetClip;
			if(targetClip)
			{
				adWidth = targetClip.width;
				adHeight = targetClip.height;
			}
		}
		
		public function set publisherProxy(proxy:VPAIDPubProxy):void
		{
			_proxy = proxy;
			_proxy.addEventListener("init", handlePlayerEvent, false,0,true);
			_proxy.addEventListener("resize", handlePlayerEvent, false,0,true);
			this.addEventListener(Event.CHANGE, autoAdjust);
			updatePosition();
		}
		
		public function destroy():void
		{
			_proxy.removeEventListener("init", handlePlayerEvent);
			_proxy.removeEventListener("resize", handlePlayerEvent);
			_proxy = null;
			this.removeEventListener(Event.CHANGE, autoAdjust);
		}
		
		private function updatePosition():void
		{
			playerHeight = _proxy.canvasHeight;
			playerWidth = _proxy.canvasWidth;
			viewMode = _proxy.viewMode;
			getCoords();
			trace("::::> Positioner "+playerWidth+"x"+playerHeight+" => "+coordinates.x+","+coordinates.y);
			
			//dispatch a cancellable event - if cancelled, the creative is handling the positioning itself
			dispatchEvent(new Event(Event.CHANGE,false,true));
		}
		
		protected function handlePlayerEvent(e:Event=null):void
		{
			if(e) trace("positioner received event: "+e.type);
			updatePosition();
		}
		
		private function autoAdjust(e:Event):void
		{
			if(!e.isDefaultPrevented())
			{
				if(targetClip)
				{
					targetClip.x = coordinates.x;
					targetClip.y = coordinates.y;
				}
			}
		}
		
		/**
		 * Returns suggested ad unit coordinates.  By providing the x,y coordinates of your video window, as well as 
		 * the width of the visible area, we can suggest a location for the ad unit.
		 * @param	adWidth Width of the ad unit (returned from your ad server)
		 * @param	adHeight Height of the ad unit (returned from your ad server)
		 * @return  a Point containing X & Y coordinates for the suggested placement of the ad unit
		 */
		public function getCoords( ):Point
		{
			coordinates = new Point();
			switch(position)
			{
				case TOP_LEFT:
					coordinates.x = xOffset;
					coordinates.y = yOffset;
					break;
				case TOP_CENTER:
					coordinates.x = ((playerWidth/2)-(adWidth/2))+xOffset;
					coordinates.y = yOffset;
					break;
				case TOP_RIGHT:
					coordinates.x = (playerWidth - adWidth)+xOffset;
					coordinates.y = yOffset;
					break;
				case MIDDLE_LEFT:
					coordinates.x = xOffset;
					coordinates.y = ((playerHeight/2)-(adHeight/2))+yOffset;
					break;
				case MIDDLE_CENTER:
					coordinates.x = ((playerWidth/2)-(adWidth/2))+xOffset;
					coordinates.y = ((playerHeight/2)-(adHeight/2))+yOffset;
					break;
				case MIDDLE_RIGHT:
					coordinates.x = (playerWidth - adWidth)+xOffset;
					coordinates.y = ((playerHeight/2)-(adHeight/2))+yOffset;
					break;
				case BOTTOM_LEFT:
					coordinates.x = xOffset;
					coordinates.y = (playerHeight - adHeight)+yOffset;
					break;
				case BOTTOM_CENTER:
					coordinates.x = ((playerWidth/2)-(adWidth/2))+xOffset;
					coordinates.y = (playerHeight - adHeight)+yOffset;
					break;
				case BOTTOM_RIGHT:
					coordinates.x = (playerWidth - adWidth)+xOffset;
					coordinates.y = (playerHeight - adHeight)+yOffset;
					break;
				default:
					coordinates = new Point();
			}	
			return coordinates;
		}
	}
}