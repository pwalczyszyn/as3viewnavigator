//////////////////////////////////////////////////////////////////////////////////////
//
//	Copyright 2011 Piotr Walczyszyn (http://riaspace.com | @pwalczyszyn)
//	
//	Licensed under the Apache License, Version 2.0 (the "License");
//	you may not use this file except in compliance with the License.
//	You may obtain a copy of the License at
//	
//		http://www.apache.org/licenses/LICENSE-2.0
//	
//	Unless required by applicable law or agreed to in writing, software
//	distributed under the License is distributed on an "AS IS" BASIS,
//	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//	See the License for the specific language governing permissions and
//	limitations under the License.
//	
//////////////////////////////////////////////////////////////////////////////////////

package com.riaspace.as3viewnavigator
{
	import flash.display.DisplayObject;

	public interface IViewNavigator
	{
		/**
		 * Adds view on top of the stack. 
		 * 
		 * If added view implements IView interface it will also inject the reference to
		 * this navigator instance.
		 * 
		 * @see com.riaspace.as3viewnavigator.IView
		 * 
		 * @param view - instance or Class of the view to add. It must inherit from DisplayObject at some point.
		 * @param viewProps - associative array of properties and values to set on the view. Especially usefull if 
		 * view is passed as Class.
		 * @param context - object that can be passed to the view if it implements IView. It also will be returned
		 * by ViewNavigator's poppedViewContext property no matter if the view implements IView or not.
		 * @param transition - enum value from <code>ViewTransition</code> class. By default it is set to <code>ViewTransition.SLIDE</code>.
		 * 
		 * @return Returns pushed view.
		 */
		function pushView(view:Object, viewProps:Object = null, context:Object = null, transition:String = "slide"):DisplayObject;

		/**
		 * Pops current view from the top of the stack.
		 * 
		 * @param transition - enum value from <code>ViewTransition</code> class. By default it is set to <code>ViewTransition.SLIDE</code>.
		 *  
		 * @return Returns the view that was on top of the stack. 
		 */
		function popView(transition:String = "slide"):DisplayObject;

		/**
		 * Pops to the first view from the very top.
		 * 
		 * @param transition - enum value from <code>ViewTransition</code> class. By default it is set to <code>ViewTransition.SLIDE</code>.
		 *  
		 * @return Returns the view that was on top of the stack.
		 */
		function popToFirstView(transition:String = "slide"):DisplayObject;

		/**
		 * Pops all views from the stack.
		 * 
		 * @param transition - enum value from <code>ViewTransition</code> class. By default it is set to <code>ViewTransition.SLIDE</code>.
		 *  
		 * @return Returns the view that was on top of the stack.
		 */
		function popAll(transition:String = "slide"):DisplayObject;

		/**
		 * Replaces view with the one passed as parameter.
		 * 
		 * @param view - instance or Class of the view to add. It must inherit from DisplayObject at some point.
		 * @param viewProps - associative array of properties and values to set on the view. Especially usefull if 
		 * view is passed as Class.
		 * @param context - object that can be passed to the view if it implements IView. It also will be returned
		 * by ViewNavigator's poppedViewContext property no matter if the view implements IView or not.
		 * @param transition - enum value from <code>ViewTransition</code> class. By default it is set to <code>ViewTransition.SLIDE</code>.
		 *  
		 * @return Returns the view that was on top of the stack.
		 */
		function replaceView(view:Object, viewProps:Object = null, context:Object = null, transition:String = "slide"):DisplayObject;
		
		function get width():Number;
		function set width(value:Number):void;
		
		function get height():Number;
		function set height(value:Number):void;
		
		
		function get firstView():Object;
		function set firstView(value:Object):void;
		
		function get firstViewProps():Object;
		function set firstViewProps(value:Object):void;
		
		function get firstViewContext():Object;
		function set firstViewContext(value:Object):void;
		
		function get firstViewTransition():String;
		function set firstViewTransition(value:String):void;
		
		/**
		 * Views transition duration, default value is 0.5s.
		 */
		function get transitionDuration():Number;
		/**
		 * @private
		 */
		function set transitionDuration(value:Number):void;

	}
}