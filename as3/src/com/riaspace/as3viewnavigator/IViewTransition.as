package com.riaspace.as3viewnavigator
{
	import flash.display.DisplayObject;

	public interface IViewTransition
	{
		function set navigator(value:IViewNavigator):void;
		
		function set transitionDuration(value:Number):void;
		
		function set action(value:String):void;
		
		function set hideView(value:DisplayObject):void;
		
		function set showView(value:DisplayObject):void;
		
		function play():void;
	}
}