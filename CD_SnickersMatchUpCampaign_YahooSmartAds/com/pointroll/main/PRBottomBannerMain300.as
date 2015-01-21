﻿/*********************************************************** AUTHOR: TOBI ECHEVARRIA* COMPANY: POINTROLL* * CLASS: PRBannerMain** DESCRIPTION: ***********************************************************/package com.pointroll.main{	import pointroll.*;	import pointroll.info.getSWFDimensions;	import com.pointroll.ui.PointRollBannerUI_300;	import com.pointroll.abstract.PointRollAbstractUI;	import flash.display.MovieClip;	import flash.events.Event;	import flash.events.MouseEvent;	import com.pointroll.events.PRUIEvents;	import com.pointroll.api.utils.net.isLocal;		import com.pointroll.data.MatchUpData;		import com.pointroll.data.PRDataScrapper;	import com.pointroll.events.PRDataScrapeEvents;			import pointroll.datastorage.*;	import pointroll.info.getFolderPath;		import flash.utils.Timer;	import flash.events.TimerEvent;	public class PRBottomBannerMain300 extends MovieClip {		private var _ui:PointRollBannerUI_300;		public var _stageWidth:int;		public var _stageHeight:int;				private var _scrapper:PRDataScrapper;				private var _localTestObject:Object;				private var _xml:XML;				private var _noun:String;		private var _static:String;				private var _timer:Timer;		public function PRBottomBannerMain300() {			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);		}		// Public Functions		// Private Functions		private function init():void {			pointroll.initAd(this);						trace("###################THIS IS CREATIVE B 300x250");			_stageWidth =  pointroll.info.getSWFDimensions().width;			_stageHeight =  pointroll.info.getSWFDimensions().height;			_static = pointroll.info.getFolderPath() + (pointroll.getFlashVar("static") || "snickers_manziel_concept3_728x90");			if (isLocal()) {				_localTestObject = new Object();				_localTestObject["varPRCurrTeamName"] = "Pointroll Fantasy";				_localTestObject["varPRMyLossesInRow"] = "0";				_localTestObject["varPRMyWinsInRow"] = "1";				_localTestObject["varPRJohnnyManziel"] = "TRUE";								_xml = <SnickersFantasyFootballSmartAd2014>							<NoValue>LosingStreak</NoValue>						</SnickersFantasyFootballSmartAd2014>;				//trace("\n _xml: " + _xml)				dataScrape();			}			_ui = new PointRollBannerUI_300(this);			_ui.addEventListener(PRUIEvents.ON_UI_EVENT , onBannerEvents);						pointroll.datastorage.checkOnInterval("inputData", 100, onDataStorage);						_timer = new Timer(5000)//If data is never recieved from creative a then load in default			_timer.addEventListener(TimerEvent.TIMER, onTimerEvent);			_timer.start();		}		// EVENTS		private function onAddedToStage(e:Event):void {			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);			init();		}		private function onBannerEvents(e:PRUIEvents):void{			pointroll.launchURL(pointroll.getFlashVar("clickTag1"),true,e.params.noun);					}		private function onDataStorage(name:String, value:String):void {			//trace("\n value: " + value)			if(value != null && value !="null"){				trace("onDataStorage: " + value);				killTimer();				pointroll.datastorage.stopAlert("inputData");				_xml = XML(value);				  								dataScrape();							}		}				private function dataScrape():void {				//trace("\n _xml.NoValue: " + _xml.NoValue)			 if(_xml.NoValue.toLowerCase() == "thursday")			    _scrapper = new PRDataScrapper(["varPRCurrTeamName"], 100 ,15);			 else			    _scrapper = new PRDataScrapper(["varPRCurrTeamName",											    MatchUpData._variableDictionary[String(_xml.NoValue)]],100,15);																 _scrapper.addEventListener(PRDataScrapeEvents.ON_DATA_SCRAPE_LOAD, onDataScrapperEvent); 			 _scrapper.addEventListener(PRDataScrapeEvents.ON_DATA_SCRAPE_FAIL, onDataScrapperEvent); 			 _scrapper.load();		}					private function dataScrape300():void {				trace("\n _xml.NoValue: " + _xml.NoValue)			 if(_xml.NoValue.toLowerCase() == "thursday")			    _scrapper = new PRDataScrapper(["varPRCurrTeamName"], 100 ,15);			 else			    _scrapper = new PRDataScrapper(["varPRCurrTeamName",											    MatchUpData._variableDictionary[String(_xml.NoValue)]],100,15);																 _scrapper.addEventListener(PRDataScrapeEvents.ON_DATA_SCRAPE_LOAD, onDataScrapperEvent); 			 _scrapper.addEventListener(PRDataScrapeEvents.ON_DATA_SCRAPE_FAIL, onDataScrapperEvent); 			 _scrapper.load();		}							private function onDataScrapperEvent(e:PRDataScrapeEvents):void{						switch(e.type){				case PRDataScrapeEvents.ON_DATA_SCRAPE_LOAD:					 					 _ui.buildUI(_xml, e.params); 											 gotoAndPlay(2);				break;				case PRDataScrapeEvents.ON_DATA_SCRAPE_FAIL:					 if (isLocal()) {						 trace(" ###### ON_DATA_SCRAPE_FAIL onDataScrapperEvent: " + e.type);						//*** LOCAL TESTING a proper LOAD CASE						 killTimer();  						_ui.buildUI(_xml, _localTestObject); 							 gotoAndPlay(2);					 }					 else {						 					 	_ui.buildUI(_xml, PRDataScrapeEvents.ON_DATA_SCRAPE_FAIL, _static, false);					 }				break;			}						_scrapper.removeEventListener(PRDataScrapeEvents.ON_DATA_SCRAPE_LOAD, onDataScrapperEvent); 			_scrapper.removeEventListener(PRDataScrapeEvents.ON_DATA_SCRAPE_FAIL, onDataScrapperEvent); 		}		private function onTimerEvent(e:TimerEvent):void{			killTimer();			_ui.buildUI(_xml, PRDataScrapeEvents.ON_DATA_SCRAPE_FAIL, _static, false);								}		private function killTimer():void{			if(_timer){				_timer.stop();				_timer.removeEventListener(TimerEvent.TIMER, onTimerEvent);				_timer = null;				}		}	}}