package com.pointroll
{
	
	import flash.events.*;
	import flash.display.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.*;
	import flash.external.*;
 	import fl.controls.*
	
	import pointroll.*;
	import pointroll.info.*;
	import pointroll.panel.*;
	import com.pointroll.api.form.*;
	import com.pointroll.api.events.FormEvent;
	import com.pointroll.api.form.formats.*;

	
	public class PRform extends MovieClip
	{
		
		private var fields_array:Array;
		private var hint_array:Array;
		
		//private var scriptRequest:URLRequest;
		//private var scriptLoader:URLLoader;
		//private var scriptVars:URLVariables;
		//private var type_str:String;
		public var thankYou_mc:MovieClip;
 		public var btnSubmit:SimpleButton;
  		public var clickGen:SimpleButton;
  		public var clickRules:SimpleButton;
  		public var cb_yes:CheckBox;
 		public var rb_male:RadioButton;
 		public var rb_femme:RadioButton;
		
 		public var rb_adv:RadioButton;
 		public var rb_early:RadioButton;
 		var prForm:PointRollForm;
		
		private var timer:Timer;
		
		public function PRform()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
 
		function changeHandler(event:Event):void { 
 			//county_cb.selectedIndex  = ComboBox(event.target).selectedIndex; 
			//trace("\n county_cb.selectedItem : " + county_cb.selectedIndex )
			//county_cb.prompt = "select..."
			
		}
		
		private function init(evt:Event)
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
 			pointroll.initAd(this)
			
			var id_dataCollect:String = getFlashVar("id_dataCollect") || "894646231"
 			prForm = new PointRollForm(id_dataCollect);
			
			thankYou_mc.visible = false;
			errorMC.visible = false;
 			thankYou_mc.buttonMode = true;
			                       
  			thankYou_mc.close_ty.addEventListener(MouseEvent.CLICK, closeThankYou);
			thankYou_mc.ctaBTN.addEventListener(MouseEvent.CLICK, onCTABtn);
			thankYou_mc.buynowBtn.addEventListener(MouseEvent.CLICK, onBuyBtn_ThankYou);
			errorMC.addEventListener(MouseEvent.CLICK, hideME);
			Btn_closePnl.addEventListener(MouseEvent.CLICK, onClosePanelCLick);
			
			
			addEventListener(Event.CHANGE, changeHandler); 
  			
			fields_array = new Array(tf_fname, tf_lname, tf_street, tf_city, tf_state, tf_zip, tf_email);
  			//
 			hint_array = new Array("", "", "", "", "", "", "", "", "", "");
  			//
			btnSubmit.addEventListener(MouseEvent.CLICK, onSubmitBtn);
			btnBuy.addEventListener(MouseEvent.CLICK, onBuyBtn);
			clickGen.addEventListener(MouseEvent.CLICK, onClickTag);
			clickRules.addEventListener(MouseEvent.CLICK, onClickTag);
 			 //
			setUpFields();
			resetFields();
 			//
			if (root.loaderInfo.url.indexOf("file") == 0) {
				//sendSTAF();
			}
			
			if (root.loaderInfo.url.indexOf("file") == 0) {
				tf_fname.text = "firstNamexx";
				tf_lname.text = "lastNamexx";
				tf_street.text = "6663 Street st";
				tf_city.text = "CityName";
				tf_state.text = "NY";
				tf_zip.text = "1111xx";
				tf_email.text = "user@domain.com";
				//tf_age.text = "99";
				//tf_hair_stage_thinning.text = "Early";//"Advanced"
				//tf_optIn.text = "yes";//"No"
				//tf_gender.text = "Male";//"Female"
 			}
			
		}
		
		private function closeThankYou(e:MouseEvent):void 
		{
			thankYou_mc.visible = false;
		}
		
		private function onBuyBtn_ThankYou(e:MouseEvent):void 
		{
			trace("\n ## clickTag5 "  )
			launchURL(getFlashVar("clickTag5"));
		}
		
		private function onClosePanelCLick(e:MouseEvent):void 
		{
			closePanel()
		}
		
		private function onBuyBtn(e:MouseEvent):void 
		{
			launchURL(getFlashVar("clickTag2"));
		}
		
		private function onClickTag(e:MouseEvent):void 
		{
			switch (e.currentTarget.name) 
			{
				case "clickTag1":
					launchURL(getFlashVar("clickTag1"));
				break;
				case "clickRules":
					launchURL(getFlashVar("clickTag4"));
				break;
				
				default:
			}
			
		}
		
		
		private function DataSent(e:FormEvent):void
		{
			trace(" Submitted PRFORM Data");	
			showThankYou(false);
 		}
		
		private function hideME(e:MouseEvent)
		{
			e.currentTarget.visible = false;
			
		}
		
		private function onSubmitBtn(e:MouseEvent)
		{
			trackActivity(1);
			submitRequest();
		}
		
 		private function onCTABtn(e:MouseEvent)
		{
			launchURL(getFlashVar("clickTag3"));
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
			
			if (!validateEmail(fields_array[6].text))
			{
				fields_array[6].stage.focus = fields_array[6];
				fields_array[6].setSelection(0, fields_array[6].text.length);
				//btnSubmit.visible = false;
				errorMC.visible = true;
				errorMC.errorTF.text = "Please provide a valid email"
				
				return false;
			}
			
  			
			//validate non text fields
			//if (!cb_agree.selected) 
			//{
				//errorMC.visible = true;
				//errorMC.errorTF.text = "Please agree to the Terms."
				//return false;
			//}
 			 
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
			TextField(tf_age).restrict = "0-9";
			//TextField(tf_phone2).restrict = "0-9";
			//TextField(tf_phone3).restrict = "0-9";
 			
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
			//rb_early.selected = true;
			//RadioButtonGroup(RadioButtonGroup2).getRadioButtonAt(0).selected = true;
			cb_yes.selected = true;
 			
			var length_n:Number = fields_array.length;
			for (var i:Number = 0; i < length_n; i++)
			{
				//trace("\n hint_array[i]: " + hint_array[i])
 				fields_array[i].text  = hint_array[i];
			}
 			tf_age.text = "";
			
		}
		
		private function sendSTAF():void
		{
			trace("***** sendStaf");
			
			//fields_array = new Array(tf_fname, tf_lname, tf_street, tf_city, tf_zip, tf_email);
   			//1	f_Name
			//2	l_Name
			//3	Street
			//4	City
			//5	State
			//6	Zip
			//7	email
			
			//8		opt_in
			//9		age
			//10	gender
			//11	 hair_stage_thinning
			
			var tf_optIn:TextField = new TextField();
			var tf_gender:TextField = new TextField();
			var tf_hair_stage_thinning:TextField = new TextField();
			
			
			//(rb_adv.selected)? tf_hair_stage_thinning.text = "Advanced" : tf_hair_stage_thinning.text = "Early";
						//(rb_male.selected)? tf_gender.text = "Male" : tf_gender.text = "Female";

			
			if (rb_adv.selected) 
			{
				tf_hair_stage_thinning.text = "Advanced"
			}else if (rb_early.selected) 
			{
				tf_hair_stage_thinning.text = "Early"
			}else 
			{
				tf_hair_stage_thinning.text = "n/a"
			}
			
			
			if (rb_male.selected) 
			{
				tf_gender.text = "Male" 
			}else if (rb_femme.selected) 
			{
				tf_gender.text = "Female"
			}else 
			{
				tf_gender.text = "n/a";
			}
			
			
			
			(cb_yes.selected)? tf_optIn.text = "Yes" : tf_optIn.text = "No";
 			
			
			
 			var field1:TextualFormField = new TextualFormField('F1', tf_fname,'text');		 
			var field2:TextualFormField = new TextualFormField('F2', tf_lname,'text');		 
			var field3:TextualFormField = new TextualFormField('F3', tf_street,'text');		 
 			var field4:TextualFormField = new TextualFormField('F4', tf_city, 'text');	 
 			var field5:ZipCodeFormField = new ZipCodeFormField('F5', tf_state, 'text');	 
 			var field6:ZipCodeFormField = new ZipCodeFormField('F6', tf_zip, 'text');	 
			var field7:EmailFormField = new EmailFormField('F7', tf_email, 'text'); 
 			var field8:TextualFormField = new TextualFormField('F8', tf_optIn, 'text');	 
 			var field9:TextualFormField = new TextualFormField('F9', tf_age, 'text');	 
 			var field10:TextualFormField = new TextualFormField('F10', tf_gender, 'text');	 
 			var field11:TextualFormField = new TextualFormField('F11', tf_hair_stage_thinning, 'text');	 
			
			
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
			prForm.registerField(field11);
 			
			
			prForm.addEventListener(FormEvent.SUBMIT, DataSent);
			prForm.submitForm();
			//DATA COLLECT - end
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
			
			//var resetInterval:uint = setInterval(resetAd, 4500);
		
		}
		
		private function resetAd():void 
		{
			(thankYou_mc.visible == true)? thankYou_mc.visible = false : thankYou_mc.visible = false;
			resetFields();
			//clearInterval(resetInterval)
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
		
		 
		
		private function focusInListener(e:FocusEvent)
		{
			pinPanel();
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
					offender =  'First Name'
 				break;
				case 2:
 					offender =  'Last Name'
				break;
				case 3:
 					offender = 'Street Address'
				break;
				case 4:
 					offender =  'City'
				break;
				case 5:
 					 offender =  'Zip code'
				break;
				
				case 7:
					 offender =  'Email'
				break;
				
				case 6:
					 offender =  'Age'
				break;
				 
 				default:
			}
 			
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





