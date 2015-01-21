package com.pointroll.vpaid.plugins
{
	import com.pointroll.vpaid.VPAIDPubProxy;

	public interface IVPAIDPlugin
	{
		function set publisherProxy(proxy:VPAIDPubProxy):void;
		function destroy():void;
	}
}