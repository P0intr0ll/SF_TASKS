package com.pointroll.vpaid.oop
{
	public class OOPCompanion
	{
		public var  pid:String;
		public var  xOffset:Number=0;
		public var  yOffset:Number=0;
		public var  htmlAnchor:String;
		
		public function OOPCompanion(pid:String, xOffset:Number=0, yOffset:Number=0, htmlAnchor:String=null)
		{
			this.pid = pid;
			this.xOffset = xOffset;
			this.yOffset = yOffset;
			this.htmlAnchor = htmlAnchor;
		}
		
		public function toString():String
		{
			return pid+","+yOffset+","+xOffset+","+htmlAnchor;
		}
	}
}