﻿package  {		import com.pointroll.interface.IAdControl;			import 	PointRollAPI_AS3.data.DataStorage;		import PointRollAPI_AS3.data.AdControl;		import flash.display.Sprite;	import flash.display.MovieClip;	public class PRAdControl extends Sprite implements IAdControl{		private var _r:MovieClip:				private var _adControl:AdControl				public function PRAdControl(r:MovieClip) {			_r = r;			_adControl = new AdControl(_r);		}		public function loadAdControl():void{					}				public function setChangeZip(zip:String,autoLoad:Boolean=true):void{			_adControl.changeZip(zip,autoLoad);					}		public function setClearSTSData(name:String):void{			_adControl.clearSTSData(name);		}				public function set localXMLFile(file:String):void{			_adControl.localTestFile = file;					}		public function set clearSTSOnLoad(b:Boolean):void{			_adControl.clearSTSonLoad = b;					}		public function set interfaceID(value:String):void{			_adControl.interfaceID = value;		}				public function get AdControlData():XML{			return _adControl.getXMLData();					}		public function get AdvInputData():Object{			return _adControl.AdvInputData;					}		public function get BTData():Object{			return _adControl.BTData;		}			}}