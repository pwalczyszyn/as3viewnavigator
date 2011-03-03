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
	import flash.events.IEventDispatcher;

	/**
	 * Dispatched when changing the current view.
	 */
	[Event(name="viewChanging", type="com.riaspace.as3viewnavigator.events.ViewNavigatorEvent")]

	public interface IViewNavigator extends IEventDispatcher
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
		 * @param transition - views transition, default is slide transition.
		 * 
		 * @return Returns pushed view.
		 */
		function pushView(view:Object, viewProps:Object = null, context:Object = null, transition:IViewTransition = null):DisplayObject;

		/**
		 * Pops current view from the top of the stack.
		 * 
		 * @param transition - views transition, default is slide transition.
		 *  
		 * @return Returns the view that was on top of the stack. 
		 */
		function popView(transition:IViewTransition = null):DisplayObject;

		/**
		 * Pops to the first view from the very top.
		 * 
		 * @param transition - views transition, default is slide transition.
		 *  
		 * @return Returns the view that was on top of the stack.
		 */
		function popToFirstView(transition:IViewTransition = null):DisplayObject;

		/**
		 * Pops all views from the stack.
		 * 
		 * @param transition - views transition, default is slide transition.
		 *  
		 * @return Returns the view that was on top of the stack.
		 */
		function popAll(transition:IViewTransition = null):DisplayObject;

		/**
		 * Replaces view with the one passed as parameter.
		 * 
		 * @param view - instance or Class of the view to add. It must inherit from DisplayObject at some point.
		 * @param viewProps - associative array of properties and values to set on the view. Especially usefull if 
		 * view is passed as Class.
		 * @param context - object that can be passed to the view if it implements IView. It also will be returned
		 * by ViewNavigator's poppedViewContext property no matter if the view implements IView or not.
		 * @param transition - views transition, default is slide transition.
		 *  
		 * @return Returns the view that was on top of the stack.
		 */
		function replaceView(view:Object, viewProps:Object = null, context:Object = null, transition:IViewTransition = null):DisplayObject;
		
		/**
		 * Returns width of navigator container.
		 */
		function get width():Number;
		/**
		 * Sets width of navigator container. 
		 * 
		 * @param width Width of ViewNavigator 
		 */
		function set width(value:Number):void;

		/**
		 * Returns height of navigator container.
		 */
		function get height():Number;
		/**
		 * Sets height of navigator container. 
		 * 
		 * @param width Width of ViewNavigator 
		 */
		function set height(value:Number):void;
		
		/**
		 * Returns first view that will be display when navigator
		 * is constructed.
		 */
		function get firstView():Object;
		/**
		 * Sets first view object.
		 * @param value - first view object
		 */
		function set firstView(value:Object):void;
		
		/**
		 * Returns first view properties.
		 */
		function get firstViewProps():Object;
		/**
		 * Sets first view properties.
		 * @param value - first view properties object
		 */
		function set firstViewProps(value:Object):void;

		/**
		 * Returns first view context.
		 */
		function get firstViewContext():Object;
		/**
		 * Sets first view context object.
		 * @param value - first view context object
		 */
		function set firstViewContext(value:Object):void;
		
		/**
		 * Returns first view transition.
		 */
		function get firstViewTransition():IViewTransition;
		/**
		 * Sets first view transition.
		 * @param value - first view transition
		 */
		function set firstViewTransition(value:IViewTransition):void;
		
		/**
		 * Views transition duration, default value is 0.5s.
		 */
		function get transitionDuration():Number;
		/**
		 * @private
		 */
		function set transitionDuration(value:Number):void;

		/**
		 * Returns default transition.
		 */
		function get defaultTransition():IViewTransition;
		
		/**
		 * Sets default transition.
		 */ 
		function set defaultTransition(value:IViewTransition):void;
		
		/**
		 * Returns number of views managed by ViewNavigator container.
		 */
		function get length():Number;		
		
		/**
		 * Returns top view from the stack
		 */
		function get currentView():DisplayObject;
	}
}