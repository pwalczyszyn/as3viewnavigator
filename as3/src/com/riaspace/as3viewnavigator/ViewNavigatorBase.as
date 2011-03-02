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
	import com.riaspace.as3viewnavigator.events.ViewNavigatorEvent;
	import com.riaspace.as3viewnavigator.transitions.ViewNoneTransition;
	import com.riaspace.as3viewnavigator.transitions.ViewSlideTransition;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * Base class for ViewNavigator.
	 * 
	 * @author Piotr Walczyszyn
	 */
	public class ViewNavigatorBase
	{
		protected var _parent:Sprite;
		
		protected var _views:Vector.<ViewReference> = new Vector.<ViewReference>;
		
		protected var _poppedViewReturnedObject:Object;
		
		protected var _poppedViewContext:Object;
		
		protected var _firstView:Object;
		
		protected var _firstViewProps:Object;
		
		protected var _firstViewContext:Object;
		
		protected var _firstViewTransition:IViewTransition;
		
		protected var _transitionDuration:Number = 0.7;
		
		protected var _currentViewReference:ViewReference;
		
		protected var _defaultTransition:IViewTransition;
		
		public function ViewNavigatorBase(parent:Sprite, firstView:Object = null, firstViewProps:Object = null, firstViewContext:Object = null, firstViewTransition:IViewTransition = null)
		{
			_parent = parent;
			
			_firstView = firstView;
			_firstViewProps = firstViewProps;
			_firstViewContext = firstViewContext;
			_firstViewTransition = firstViewTransition ? firstViewTransition : new ViewNoneTransition(IViewNavigator(parent));
			
			_defaultTransition = new ViewSlideTransition(IViewNavigator(parent));
			
			_parent.addEventListener(Event.ADDED_TO_STAGE, parent_addedToStageHandler);
		}
		
		protected function parent_addedToStageHandler(event:Event):void
		{
			_parent.removeEventListener(Event.ADDED_TO_STAGE, parent_addedToStageHandler);
			
			// If first view was defined pushing it
			if (_firstView)
				pushView(_firstView, _firstViewProps, _firstViewContext, _firstViewTransition);
		}
		
		public function get currentView():DisplayObject
		{
			return _currentViewReference ? _currentViewReference.instance : null;
		}
		
		internal function resizeCurrentView():void
		{
			var view:Object = currentView;
			if (view && view is IView)
				IView(view).resize();
		}

		public function pushView(view:Object, viewProps:Object = null, context:Object = null, transition:IViewTransition = null):DisplayObject
		{
			var showViewReference:ViewReference = new ViewReference(IViewNavigator(_parent), view, viewProps, context);
			var showView:DisplayObject = showViewReference.instance;
			
			var hideViewReference:ViewReference = _currentViewReference;
			var hideView:DisplayObject = _currentViewReference ? _currentViewReference.instance : null;
				
			if (_parent.dispatchEvent(new ViewNavigatorEvent(ViewNavigatorEvent.VIEW_CHANGING, ViewNavigatorAction.PUSH, hideView, showView)))
			{
				push(hideViewReference, showViewReference, transition);
				
				// Returning pushed view
				return showView;				
			}
			return null;
		}
		
		public function popView(transition:IViewTransition = null):DisplayObject
		{
			if (_views.length > 0)
			{
				var hideViewReference:ViewReference = _currentViewReference;
				var hideView:DisplayObject = _currentViewReference.instance;
				
				var showViewReference:ViewReference = _views.length > 1 ? _views[_views.length - 2] : null;
				var showView:DisplayObject = showViewReference ? showViewReference.instance : null;

				if (_parent.dispatchEvent(new ViewNavigatorEvent(ViewNavigatorEvent.VIEW_CHANGING, ViewNavigatorAction.POP, hideView, showView)))
				{
					pop(hideViewReference, showViewReference, transition);
					return hideView;
				}
			}
			return null;
		}
		
		public function popToFirstView(transition:IViewTransition = null):DisplayObject
		{
			if (_views.length > 1)
			{
				var hideViewReference:ViewReference = _currentViewReference;
				var hideView:DisplayObject = _currentViewReference.instance;
				
				var showViewReference:ViewReference = _views[0];
				var showView:DisplayObject = showViewReference.instance;

				if (!_parent.dispatchEvent(new ViewNavigatorEvent(ViewNavigatorEvent.VIEW_CHANGING, ViewNavigatorAction.POP_TO_FIRST, hideView, showView)))
					return null;
				
				// Removing views except the bottom and the top one
				if (_views.length > 2)
					_views.splice(1, _views.length - 2);
				
				// Poping top view to have nice transition
				pop(hideViewReference, showViewReference, transition);
				
				return hideView;
			}
			return null;
		}
		
		public function popAll(transition:IViewTransition = null):DisplayObject
		{
			if (_views.length > 0)
			{
				var hideViewReference:ViewReference = _currentViewReference;
				var hideView:DisplayObject = _currentViewReference.instance;
				
				if (_parent.dispatchEvent(new ViewNavigatorEvent(ViewNavigatorEvent.VIEW_CHANGING, ViewNavigatorAction.POP_ALL, hideView, null)))
				{
					// Removing views except the top one
					_views.splice(0, _views.length - 1);
					
					// Poping top view to have nice transition
					pop(hideViewReference, null, transition);
					
					return hideView;
				}
			}
			return null;
		}
		
		public function replaceView(view:Object, viewProps:Object = null, context:Object = null, transition:IViewTransition = null):DisplayObject
		{
			if (_views.length > 0)
			{
				var hideViewReference:ViewReference = _currentViewReference;
				var hideView:DisplayObject = _currentViewReference.instance;
				
				var showViewReference:ViewReference = new ViewReference(IViewNavigator(_parent), view, viewProps, context);
				var showView:DisplayObject = showViewReference.instance;

				if (_parent.dispatchEvent(new ViewNavigatorEvent(ViewNavigatorEvent.VIEW_CHANGING, ViewNavigatorAction.REPLACE, hideView, showView)))
				{
					// Pushing view on top of the stack
					push(hideViewReference, showViewReference, transition);
					
					// Removing view below
					if (_views.length > 1)
						_views.splice(_views.length - 2, 1);
					
					return showView;
				}
			}
			return null;
		}
		
		protected function push(hideViewReference:ViewReference, showViewReference:ViewReference, transition:IViewTransition = null):void
		{
			// Adding current view to the stack
			_currentViewReference = showViewReference; 
			_views.push(_currentViewReference);
			
			var hideView:DisplayObject = hideViewReference ? hideViewReference.instance : null;
			var showView:DisplayObject = showViewReference.instance;
			
			// Applying transition
			applyTransition(
				transition ? transition : _defaultTransition, 
				hideView, 
				showView, 
				ViewNavigatorAction.PUSH
			);
			
			// Destroying hidden view reference
			if (hideView && hideView is IView && IView(hideView).destructionPolicy == ViewDestructionPolicy.AUTO)
				hideViewReference.destroyInstance();
		}
		
		protected function pop(hideViewReference:ViewReference, showViewReference:ViewReference, transition:IViewTransition = null):void
		{
			// Setting popped view ref
			_currentViewReference = showViewReference; 
			_views.pop();
			
			var hideView:DisplayObject = hideViewReference.instance;
			var showView:DisplayObject = showViewReference ? showViewReference.instance : null;
			
			// Setting context of popped view
			_poppedViewContext = hideViewReference.context;
			
			// Getting popped view return object
			_poppedViewReturnedObject = 
				hideView is IView ? IView(hideView).viewReturnObject : _poppedViewReturnedObject = null;
			
			// Setting showView
			if (showView && showView is IView)
				IView(showView).resize();
			
			
			// Applying transition
			applyTransition(transition ? transition : _defaultTransition, hideView, showView, ViewNavigatorAction.POP);
			
			
			// Destroying hidden view reference
			if (hideView && hideView is IView && IView(hideView).destructionPolicy == ViewDestructionPolicy.AUTO)
				hideViewReference.destroyInstance();
		}
		
		protected function applyTransition(transition:IViewTransition, hideView:DisplayObject, showView:DisplayObject, action:String):void
		{
			transition.hideView = hideView;
			transition.showView = showView;
			transition.action = action;
			transition.play();
		}
		
		public function get poppedViewReturnedObject():Object
		{
			return _poppedViewReturnedObject;
		}
		
		/**
		 * Returns number of views managed by this navigator.
		 */
		public function get length():int
		{
			return _views.length;
		}
		
		/**
		 * Returns context object returned by popped view. If multiple views were popped it is a value of the one that was on top.
		 * View doesn't have to implement IView interface in order to have this value returned.
		 */
		public function get poppedViewContext():Object
		{
			return _poppedViewContext;
		}

		public function get firstView():Object
		{
			return _firstView;
		}

		public function set firstView(value:Object):void
		{
			_firstView = value;
		}

		public function get firstViewProps():Object
		{
			return _firstViewProps;
		}

		public function set firstViewProps(value:Object):void
		{
			_firstViewProps = value;
		}

		public function get firstViewContext():Object
		{
			return _firstViewContext;
		}

		public function set firstViewContext(value:Object):void
		{
			_firstViewContext = value;
		}

		public function get firstViewTransition():IViewTransition
		{
			return _firstViewTransition;
		}

		public function set firstViewTransition(value:IViewTransition):void
		{
			_firstViewTransition = value;
		}

		public function get transitionDuration():Number
		{
			return _transitionDuration;
		}

		public function set transitionDuration(value:Number):void
		{
			_transitionDuration = value;
			
			if (_defaultTransition)
				_defaultTransition.transitionDuration = value;
		}

		public function get defaultTransition():IViewTransition
		{
			return _defaultTransition;
		}

		public function set defaultTransition(value:IViewTransition):void
		{
			_defaultTransition = value;
		}

	}
}