﻿package com.pointroll.data{	import com.pointroll.interfaces.IPRDataParser;		import com.pointroll.events.PRMapParserEvents;		import flash.display.Sprite;	import flash.events.Event;	import flash.events.EventDispatcher;	public class PRMapParser extends EventDispatcher implements IPRDataParser{		private var _xml:XML;		private var _array:Array;		public function PRMapParser() {		}		public function parseData(sourceData:*,...args):void {			_xml = sourceData;			var _length:int = _xml..location.length();			_array = new Array();			//trace("status: " + _xml + "  length: " + _length);			if (_length < 1) {				dispatchEvent(new Event("noDataFound"));			}			else{				dispatchEvent(new PRMapParserEvents(PRMapParserEvents.ON_PARSER_COMPLETE,_xml));			}		}		public function getParseData():* {			return _array;		}	}}/*			var xmlData:XML=new XML(e.target.data);			//trace(xmlData);			if (xmlData..location.length()==0) {				//googleMapFrame_mc.errorPanel.visible=true;				this.dispatchEvent(new Event("onNoStoresFound"));			} else {				for each (var p:XML in xmlData.locations.location) {					var lat:Number=p.latitude;//p.@latituderadians * 180 / Math.PI;					var lng:Number=p.longitude;//p.@longituderadians * 180 / Math.PI;					map.createMarkerAt(lat, lng, new StoreMarker(), p);				}				prRoot_m.map_mc.mapHolder_mc.loading_mc.removeEventListener(Event.ENTER_FRAME,onLoadingEnterFrame);				prRoot_m.map_mc.mapHolder_mc.loading_mc.visible = false;				prRoot_m.map_mc.mapHolder_mc.noStoresFound_mc.visible = false;				map.zoom=8;			}*/