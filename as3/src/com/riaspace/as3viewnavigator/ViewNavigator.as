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
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * Dispatched when changing the current view.
	 */
	[Event(name="viewChanging", type="com.riaspace.as3viewnavigator.events.ViewNavigatorEvent")]
	
	/**
	 * This is a wrapper class for ViewNavigatorBase. It can be used for pure AS3/Flash projects.
	 * Also Flex version is available in a separate swc.
	 * 
	 * @author Piotr Walczyszyn
	 */
	public class ViewNavigator extends Sprite implements IViewNavigator
	{
		protected var _width:Number;
		
		protected var _height:Number;
		
		protected var _base:ViewNavigatorBase;
		
		/**
		 * ViewNavigator constructor.
		 * 
		 * @param parent - parent application Sprite.
		 * @param firstView - instance or Class of the view to add. It must inherit from DisplayObject at some point.
		 * @param firstViewProps - associative array of properties and values to set on the view. Especially usefull if 
		 * view is passed as Class.
		 * @param firstViewContext - object that can be passed to the view if it implements IView. It also will be returned
		 * by ViewNavigator's poppedViewContext property no matter if the view implements IView or not.
		 * @param firstViewTransition - views transition, the default for first view is  none transition.
		 */
		public function ViewNavigator(firstView:Object = null, firstViewProps:Object = null, firstViewContext:Object = null, firstViewTransition:IViewTransition = null)
		{
			addEventListener(Event.ADDED_TO_STAGE, this_addedToStageHandler);
			
			// _base:ViewNavigatorBase is actually where all the logic happens
			_base = new ViewNavigatorBase(this, firstView, firstViewProps, firstViewContext, firstViewTransition);
		}
		
		protected function this_addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, this_addedToStageHandler);
			
			// Resizing current content
			resizeContent();
			
			// width & height are not set, using stage dimensions and scaling
			if (!_width && !_height)
				stage.addEventListener(Event.RESIZE, stage_resizeHandler);
		}
		
		protected function stage_resizeHandler(event:Event):void
		{
			// Resizing current content
			resizeContent();
		}
		
		/**
		 * Sets size of the ViewNavigator container. If this function is used ViewNavigator will
		 * not auto resize itself to the size of the stage. In that case custom function has to
		 * be provided to scale this container according to its parent or stage.
		 * 
		 * @param width Width of ViewNavigator 
		 * @param height Height of ViewNavigator 
		 */
		public function setSize(width:Number, height:Number):void
		{
			_width = width;
			_height = height;
			
			// Resizing current content
			resizeContent();
			
			// Removing stage listener, explicit dimensions will be used
			if (stage)
				stage.removeEventListener(Event.RESIZE, stage_resizeHandler);
		}
		
		protected function resizeContent():void
		{
			// Resizing scrollRect to clip the view
			scrollRect = new Rectangle(0, 0, width, height);
			
			// Resizing active view
			_base.resizeCurrentView();
		}
				
		/**
		 * Returns width of ViewNavigator.
		 */
		override public function get width():Number
		{
			if (_width)
				return _width;
			else if (stage)
				return stage.stageWidth;
			
			return super.width;
		}
		
		/**
		 * Setting this property will actually trigger setSize(width:Number, height:Number):void 
		 * function and ViewNavigator will not auto size itself according to stage anymore. 
		 * 
		 * @param width Width of ViewNavigator 
		 */
		override public function set width(value:Number):void
		{
			setSize(value, _height);
		}
		
		/**
		 * Returns height of ViewNavigator.
		 */
		override public function get height():Number
		{
			if (_height)
				return _height;
			else if (stage)
				return stage.stageHeight;
			
			return super.height;
		}
		
		/**
		 * Setting this property will actually trigger setSize(width:Number, height:Number):void 
		 * function and ViewNavigator will not auto size itself according to stage anymore. 
		 * 
		 * @param width Width of ViewNavigator 
		 * @param height Height of ViewNavigator 
		 */
		override public function set height(value:Number):void
		{
			setSize(_width, value);
		}
		
		//--------------------------------------------------------------------------
		//
		// IViewNavigator functions implementation
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function popAll(transition:IViewTransition = null):DisplayObject
		{
			return _base.popAll(transition);
		}
		
		/**
		 * @inheritDoc
		 */
		public function popToFirstView(transition:IViewTransition = null):DisplayObject
		{
			return _base.popToFirstView(transition);
		}
		
		/**
		 * @inheritDoc
		 */
		public function popView(transition:IViewTransition = null):DisplayObject
		{
			return _base.public::popView(transition);
		}
		
		/**
		 * @inheritDoc
		 */
		public function pushView(view:Object, viewProps:Object=null, context:Object=null, transition:IViewTransition = null):DisplayObject
		{
			return _base.public::pushView(view, viewProps, context, transition);
		}
		
		/**
		 * @inheritDoc
		 */
		public function replaceView(view:Object, viewProps:Object=null, context:Object=null, transition:IViewTransition = null):DisplayObject
		{
			return _base.replaceView(view, viewProps, context, transition);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get firstView():Object
		{
			return _base.firstView;
		}
		/**
		 * @inheritDoc
		 */
		public function set firstView(value:Object):void
		{
			_base.firstView = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get firstViewProps():Object
		{
			return _base.firstViewProps;
		}
		/**
		 * @inheritDoc
		 */
		public function set firstViewProps(value:Object):void
		{
			_base.firstViewProps = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get firstViewContext():Object
		{
			return _base.firstViewContext;
		}
		/**
		 * @inheritDoc
		 */
		public function set firstViewContext(value:Object):void
		{
			_base.firstViewContext = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get firstViewTransition():IViewTransition
		{
			return _base.firstViewTransition;
		}
		/**
		 * @inheritDoc
		 */
		public function set firstViewTransition(value:IViewTransition):void
		{
			_base.firstViewTransition = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get transitionDuration():Number
		{
			return _base.transitionDuration;
		}
		/**
		 * @inheritDoc
		 */
		public function set transitionDuration(value:Number):void
		{
			_base.transitionDuration = value;
		}	
		
		/**
		 * @inheritDoc
		 */
		public function get defaultTransition():IViewTransition
		{
			return _base.defaultTransition;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function set defaultTransition(value:IViewTransition):void
		{
			_base.defaultTransition = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get length():Number
		{
			return _base.length;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get currentView():DisplayObject
		{
			return _base.currentView;
		}
	}	
}