﻿/*********************************************************** AUTHOR: TOBI ECHEVARRIA* COMPANY: POINTROLL* * CLASS: PRPanelMain** DESCRIPTION: ***********************************************************/package com.pointroll.main{	import pointroll.*;	import flash.display.MovieClip;	import flash.events.Event;	import flash.events.MouseEvent;	import com.pointroll.abstract.PointRollAbstractUI;	import com.pointroll.events.PRUIEvents;		import com.pointroll.factory.PRPanelUIFactory;	public class PRPanelMain extends MovieClip {		private var _ui:PointRollAbstractUI;				private var _stageWidth:int;		private var _stageHeight:int;		public function PRPanelMain(stageWidth:int, stageHeight:int) {			_stageWidth = stageWidth;			_stageHeight = stageHeight;			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);		}		// Public Functions		// Private Functions		private function init():void {			pointroll.initAd(this);						//_ui = new PointRollPanelUI(this);			_ui = PRPanelUIFactory.createUIPage(_stageWidth+"x"+_stageHeight,this)			_ui.addEventListener(PRUIEvents.ON_UI_CLICK , onPanelEvents);							}		// EVENTS		private function onAddedToStage(e:Event):void {			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);			init();		}		private function onPanelEvents(e:PRUIEvents):void{					}	}}