package com.pointroll
{
	
	import flash.events.*;
	import flash.display.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.*;
	import flash.external.*;
	import fl.data.DataProvider; 
 	import fl.controls.*
	
	import PointRollAPI_AS3.PointRoll;
	import pointroll.*;
	import com.pointroll.api.form.*;
	import com.pointroll.api.events.FormEvent;
	import com.pointroll.api.form.formats.*;

	
	public class COSE_PRform extends MovieClip
	{
		
		private var fields_array:Array;
		private var hint_array:Array;
		
		private var prRoot_obj:PointRoll;
		private var scriptRequest:URLRequest;
		private var scriptLoader:URLLoader;
		private var scriptVars:URLVariables;
		private var type_str:String;
		public var thankYou_mc:MovieClip;
 		public var btnSubmit:SimpleButton;
 		public var termsBtn:SimpleButton;
 		public var county_cb:ComboBox;
 		public var cb_agree:CheckBox;
 		public var cb_yes:CheckBox;
		var prForm:PointRollForm;
		
		private var timer:Timer;
		
		public function COSE_PRform()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
 
function changeHandler(event:Event):void { 
    //var request:URLRequest = new URLRequest(); 
    //request.url = ComboBox(event.target).selectedItem.data; 
    //navigateToURL(request); 
    county_cb.selectedIndex  = ComboBox(event.target).selectedIndex; 
	trace("\n county_cb.selectedItem : " + county_cb.selectedIndex )
	county_cb.prompt = "select..."
	
}
		
		private function init(evt:Event)
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			prRoot_obj = PointRoll.getInstance(root);
			pointroll.initAd(this)
			prForm = new PointRollForm("157458162");
			
			thankYou_mc.visible = false;
			errorMC.visible = false;
			
			thankYou_mc.buttonMode = true;
			 
 			
			county_cb.addEventListener(Event.CHANGE, changeHandler); 
			var items:Array = [ 
				{label:"Cuyahoga", data:"Cuyahoga"}, 
				{label:"Ashtabula", data:"Ashtabula"}, 
				{label:"Lorain", data:"Lorain"}, 
				{label:"Lake", data:"Lake"}, 
				{label:"Geauga", data:"Geauga" }, 
				{label:"Summit", data:"Summit" }, 
				{label:"Medina", data:"Medina" }, 
				{label:"Portage", data:"Portage" }, 
				
				]; 
			county_cb.dataProvider = new DataProvider(items); 
			
			thankYou_mc.addEventListener(MouseEvent.CLICK, hideME);
			thankYou_mc.ctaBTN.addEventListener(MouseEvent.CLICK, onCTABtn);
			errorMC.addEventListener(MouseEvent.CLICK, hideME);
			//
 			scriptLoader = new URLLoader();
			scriptVars = new URLVariables();
			scriptRequest = new URLRequest("http://clients.pointroll.com/apps/staf/send.ashx");
			
			
			
			
			
			fields_array = new Array(tf_biz, tf_ind, tf_fname, tf_lname, tf_phone1, tf_phone2, tf_phone3, tf_email, tf_zip);
  			
			
			
			
			
			
			//hint_array = ["0",  "1",  "2",  "3",  "4",  "5",  "6",  "slee@pointroll.com",  "8" ];
			hint_array = new Array("", "", "", "", "", "", "", "", "", "");
			
			scriptLoader.addEventListener(Event.COMPLETE, handleLoadSuccessful);
			scriptLoader.addEventListener(IOErrorEvent.IO_ERROR, handleLoadError);
			
			btnSubmit.addEventListener(MouseEvent.CLICK, onSubmitBtn);
			termsBtn.addEventListener(MouseEvent.CLICK, onTermsBtn);
			
			setUpFields();
			resetFields();
 			
		}
		
		
		private function DataSent(e:FormEvent):void
		{
			trace(" Submitted PRFORM Data");	 
 		}
		
		private function hideME(e:MouseEvent)
		{
			e.currentTarget.visible = false;
			
		}
		
		private function onSubmitBtn(e:MouseEvent)
		{
			submitRequest();
		}
		
		private function onTermsBtn(e:MouseEvent)
		{
			prRoot_obj.launchURL(prRoot_obj.parameters.clickTag2);
		}
		
		private function onCTABtn(e:MouseEvent)
		{
			prRoot_obj.launchURL(prRoot_obj.parameters.clickTag1);
		}
		
		/*
		   yourName_txt.selectable = true;
		   yourName_txt.stage.focus = yourName_txt;
		   yourName_txt.setSelection(0,yourName_txt.text.length);
		 */
		public function validateFields():Boolean
		{
			var length_n:Number = fields_array.length;
			
			for (var i:Number = 0; i < length_n; i++)
			{
				//trace(fields_array[i].text == hint_array[i]);
				
				if (fields_array[i].text.length < 1 || fields_array[i].text == hint_array[i])
				//if (fields_array[i].text.length < 1 )
				{
					fields_array[i].selectable = true;
					fields_array[i].stage.focus = fields_array[i];
					fields_array[i].setSelection(0, fields_array[i].text.length);
					
					//btnSubmit.visible = false;
					errorMC.visible = true;
					
					errorMC.errorTF.text = "Please fill in all fields" 
					errorMC.errorTF.text += "\n *"+ offender 
					return false;
				}
			} 
			
			if (!validateEmail(fields_array[7].text))
			{
				fields_array[7].stage.focus = fields_array[7];
				fields_array[7].setSelection(0, fields_array[7].text.length);
				//btnSubmit.visible = false;
				errorMC.visible = true;
				errorMC.errorTF.text = "Please provide a valid email"
				
				return false;
			}
			
			//validate non text fields
			if (!cb_agree.selected) 
			{
				errorMC.visible = true;
				errorMC.errorTF.text = "Please agree to the Terms."
				return false;
			}
			trace("\n county_cb.selectedLabel: " + county_cb.selectedLabel)
			if (!county_cb.selectedLabel ) 
			{
				errorMC.visible = true;
				errorMC.errorTF.text = "Please select a county."
				return false;
			}
			
			
			return true;
		}
		
		public function submitRequest():void
		{
			trace("\n validateFields(): " + validateFields())
			
			if (validateFields())
			{
				sendSTAF();
				
				//prRoot_obj.activity(2);
			}
		}
		
		private function setUpFields():void
		{
			TextField(tf_zip).restrict = "0-9";
			TextField(tf_phone1).restrict = "0-9";
			TextField(tf_phone2).restrict = "0-9";
			TextField(tf_phone3).restrict = "0-9";
			
			
			var length_n:Number = fields_array.length;
			for (var i:Number = 0; i < length_n; i++)
			{
				fields_array[i].tabIndex = i + 1;
				fields_array[i].addEventListener(FocusEvent.FOCUS_IN, focusInListener);
				fields_array[i].addEventListener(FocusEvent.FOCUS_OUT, focusOutListener);				
			}
			
			errorMC.errorTF.text = "";
		
		}
		
		private function resetFields():void
		{
 			
			//RadioButtonGroup(RadioButtonGroup1).getRadioButtonAt(0).selected = false;
			RadioButton(rb_no).selected = true;
			cb_agree.selected = false;
			cb_yes.selected = false;
 			
			var length_n:Number = fields_array.length;
			for (var i:Number = 0; i < length_n; i++)
			{
				//trace("\n hint_array[i]: " + hint_array[i])
 				fields_array[i].text  = hint_array[i];
			}
 			
			
		}
		
		private function sendSTAF():void
		{
			trace("sendStaf");
					
			
			
			scriptVars.Senderemail =  "donotreply@pointroll.com";
			//scriptVars.Recipientemail = "org;RDiPietro@cose.org;DMcPherson@cose.org"; // doesn't work comma delimited
			scriptVars.Recipientemail = "sales@cose.org";
			scriptVars.Recipientname = "COSE Small Biz Celebration";
			scriptVars.cc =  "RDiPietro@cose.org;DMcPherson@cose.org;gmarshall@pointroll.com;slee@pointroll.com"; // 
			scriptVars.Id = "5806965";
			
  			
			scriptVars.Plcmt = prRoot_obj.parameters.PRplcmt;
			scriptVars.AdId = prRoot_obj.parameters.PRAd;
			if (root.loaderInfo.url.indexOf("file") == 0) {
				scriptVars.AdId = "0000";
				scriptVars.Plcmt = "0000";
			}
			
   			
			scriptVars.BusinessName = fields_array[0].text;
			scriptVars.BusinessIndustry = fields_array[1].text;
			scriptVars.OwnerName = fields_array[2].text +" "+ fields_array[3].text;
 			scriptVars.Email = fields_array[7].text;
			scriptVars.PhoneNumber = fields_array[4].text+"-"+fields_array[5].text+"-"+fields_array[6].text;
		
			
			//component input
			scriptVars.County = county_cb.selectedLabel;
			scriptVars.State = "Ohio";
			
			
			
			//DATA COLLECT -start
			var phoneTF_temp:TextField = new TextField()
			var tips_temp:TextField = new TextField()
			var memb_temp:TextField = new TextField()
			var county_temp:TextField = new TextField()
			var state_temp:TextField = new TextField()
			var name_temp:TextField = new TextField()
			
			county_temp.text = county_cb.selectedLabel;
			
			if (rb_yes.selected) 
			{
 			 	scriptVars.Member = "yes";
				memb_temp.text = "yes"
			} else 
			{
				 scriptVars.Member = "no";
				memb_temp.text = "no"
			}
			trace("\n ###### cb_yes.selected: " + cb_yes.selected)
			
			if (cb_yes.selected == false) 
			{
				scriptVars.Tips = "no"
				tips_temp.text = "no"
			} else 
			{				
				scriptVars.Tips = "yes"
				tips_temp.text = "yes"
			}
			
 			
 			trace("\n ###### tips_temp.text: " + tips_temp.text)
			
			//scriptRequest.method = URLRequestMethod.POST;
			scriptRequest.data = scriptVars;
			trace("vars sent: " + scriptVars.toString());
			scriptLoader.load(scriptRequest);
			
  			
			phoneTF_temp.text = fields_array[4].text+"-"+fields_array[5].text+"-"+fields_array[6].text
			state_temp.text  ='OHIO'
			name_temp.text  = fields_array[2].text +" "+ fields_array[3].text;
			
  		//fields_array = new Array(tf_biz, tf_ind, tf_fname, tf_lname, tf_phone1, tf_phone2, tf_phone3, tf_email, tf_zip);
//
			
 			var field1:TextualFormField = new TextualFormField('F1',tf_biz,'text');		 
			var field2:TextualFormField = new TextualFormField('F2',tf_ind,'text');		 
			var field3:TextualFormField = new TextualFormField('F3',name_temp,'text');		 
 			var field4:PhoneFormField = new PhoneFormField('F4', phoneTF_temp, 'text');	 
			
			var field5:EmailFormField = new EmailFormField('F5', tf_email, 'text'); 
			var field6:TextualFormField = new TextualFormField('F6', county_temp, 'text'); 
			
			var field7:TextualFormField = new TextualFormField('F7',state_temp,'text');	
			var field8:ZipCodeFormField = new ZipCodeFormField('F8', tf_zip, 'text');
 		 
 			var field9:TextualFormField = new TextualFormField('F9',memb_temp,'text');	 
			var field10:TextualFormField = new TextualFormField('F10',tips_temp,'text');	 
	
			prForm.registerField(field1);
			prForm.registerField(field2);
			prForm.registerField(field3);
			prForm.registerField(field4);
			prForm.registerField(field5);
			prForm.registerField(field6);
			prForm.registerField(field7);
			prForm.registerField(field8);
			prForm.registerField(field9);
			prForm.registerField(field10);
			
			
			prForm.addEventListener(FormEvent.SUBMIT, DataSent);
			prForm.submitForm();
			//DATA COLLECT - end
			
			
			
			showThankYou(true);
		
		}
		
		private function showThankYou(stillSending:Boolean):void
		{
			addChild(thankYou_mc);
			
			if (stillSending)
			{
				thankYou_mc.gotoAndStop(2)
				thankYou_mc.visible = true;
			}
			else
			{
				thankYou_mc.gotoAndStop(1)
				thankYou_mc.visible = true;
			}
		
		}
		
		private function validateEmail(email:String):Boolean
		{
			var iChars:String = "*|,\":<>[]{}`';()&$#%";
			var eLength:Number = email.length;
			
			if (email.length < 3)
			{
				return false;
			}
			
			for (var i:Number = 0; i < eLength; i++)
			{
				if (iChars.indexOf(email.charAt(i)) != -1)
				{
					return false;
				}
			}
			
			var atIndex:Number = email.lastIndexOf("@");
			
			if (atIndex < 1 || (atIndex == eLength - 1))
			{
				return false;
			}
			
			var pIndex:Number = email.lastIndexOf(".");
			if (pIndex < 4 || (pIndex == eLength - 1))
			{
				return false;
			}
			
			if (atIndex > pIndex)
			{
				return false;
			}
			return true;
		}
		
		//Events
		private function handleLoadSuccessful(evt:Event):void
		{
			trace(" ######## Message sent. scriptLoader.data:" );
			var returnX:XML = XML(scriptLoader.data)
			
			
			trace("\n returnX: " + returnX.status)
			
			if (returnX.status == "success")
			{				
				showThankYou(false)
				
				timer = new Timer(3000, 1);
				timer.addEventListener(TimerEvent.TIMER, onTimer);
				timer.start();
				
				resetFields();
			}
		}
		
		private function handleLoadError(evt:IOErrorEvent):void
		{
			trace(" !!!!!!!!!! handleLoadError " + evt);
		
		}
		
		private function focusInListener(e:FocusEvent)
		{
			var i:Number = e.currentTarget.tabIndex - 1;
			if (e.currentTarget.text == hint_array[i])
			{
				e.currentTarget.text = "";
				btnSubmit.visible = true;
				errorMC.visible = false;
			}
			
			trace(e.currentTarget.name + " " + e.currentTarget.tabIndex);
			
			switch (e.currentTarget.tabIndex ) 
			{
				case 1:
					offender =  'Business Name'
					prRoot_obj.activity(3);
				break;
				case 2:
					prRoot_obj.activity(4);
				offender =  'Business Industry'
				break;
				case 3:
					 prRoot_obj.activity(5);
					offender = 'First Name'
				break;
				case 4:
					 prRoot_obj.activity(6);
					offender =  'Last Name'
				break;
				case 5:
 				case 6:
 				case 7:
					 offender =  'Phone Number'
				break;
				
				case 7:
					 offender =  'Email'
				break;
				case 8:
					 offender =  'Zip'
				break;
				
				
				default:
			}
			
			//if (formsNotValid) 
			//{
				 //offender = e.currentTarget.name;
				//
			//}
 			
		}
		
		var formsNotValid:Boolean = true;
		var offender:String ;
		
		
		private function focusOutListener(e:FocusEvent)
		{
			if (e.currentTarget.text == "")
			{
				var i:Number = e.currentTarget.tabIndex - 1;
				fields_array[i].text = hint_array[i];
				trace(e.currentTarget.name + " " + e.currentTarget.tabIndex);
			}
			
			btnSubmit.visible = true;
			errorMC.visible = false;
		}
		
		private function onTimer(e:TimerEvent):void
		{
			trace("onTimer");
			thankYou_mc.visible = false;
		}
	}
}