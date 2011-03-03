package com.riaspace.as3viewnavigator
{
	import flash.display.DisplayObject;

	public interface IViewTransition
	{
		function set navigator(value:IViewNavigator):void;
		
		function set transitionDuration(value:Number):void;
		
		function play(hideView:DisplayObject, showView:DisplayObject, action:String):void;
	}
}