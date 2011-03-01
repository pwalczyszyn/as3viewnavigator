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
	import caurina.transitions.Tweener;
	
	import com.riaspace.as3viewnavigator.events.ViewNavigatorEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	use namespace vn_internal;
	
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
		
		protected var _firstViewTransition:String;
		
		protected var _transitionDuration:Number = 0.5;
		
		protected var _currentViewReference:ViewReference;
		
		public function ViewNavigatorBase(parent:Sprite, firstView:Object = null, firstViewProps:Object = null, firstViewContext:Object = null, firstViewTransition:String = "none")
		{
			_parent = parent;
			
			_firstView = firstView;
			_firstViewProps = firstViewProps;
			_firstViewContext = _firstViewContext;
			_firstViewTransition = firstViewTransition;
			
			_parent.addEventListener(Event.ADDED_TO_STAGE, parent_addedToStageHandler);
		}
		
		protected function parent_addedToStageHandler(event:Event):void
		{
			_parent.removeEventListener(Event.ADDED_TO_STAGE, parent_addedToStageHandler);
			
			// If first view was defined pushing it
			if (_firstView)
				public::pushView(_firstView, _firstViewProps, _firstViewContext, _firstViewTransition);
		}
		
		/**
		 * Returns top view from the stack
		 */
		public function get currentView():Object
		{
			return _views.length > 0 ? _currentViewReference.instance : null;
		}
		
		internal function resizeActiveView():void
		{
			var av:Object = currentView;
			if (av && av is IView)
				IView(av).resize();
		}

		public function pushView(view:Object, viewProps:Object = null, context:Object = null, transition:String = "slide"):DisplayObject
		{
			if (_parent.dispatchEvent(new ViewNavigatorEvent(ViewNavigatorEvent.VIEW_CHANGING, ViewNavigatorAction.PUSH, currentView, view)))
				// Returning pushed view
				return vn_internal::pushView(view, viewProps, context, transition);
			
			return null;
		}
		
		vn_internal function pushView(view:Object, viewProps:Object = null, context:Object = null, transition:String = "slide"):DisplayObject
		{
			var targetView:DisplayObject;
			
			// If view is a Class instantiating it
			if (view is Class)
				targetView = new view();
			else
				targetView = DisplayObject(view);
			
			// if pushed view is an IView setting navigator reference
			if (targetView is IView)
			{
				IView(targetView).navigator = ViewNavigator(_parent);
				IView(targetView).context = context;
				
				IView(targetView).resize();
			}
			
			// Setting view properties
			for(var prop:String in viewProps)
				if (targetView.hasOwnProperty(prop))
					targetView[prop] = viewProps[prop];
			
			// Setting x position to the right outside the screen
			targetView.x = _parent.width;
			// Setting y to the top of the screen
			targetView.y = 0;
			
			// Adding view to the parent
			_parent.addChild(targetView);
			
			var currentView:ViewReference;
			if (_views.length > 0)
			{
				// Getting current view from the stack
				currentView = _views[_views.length - 1];
				
				if (transition == ViewTransition.SLIDE)
					// Tweening currentView to the right outside the screen
					Tweener.addTween(_currentViewReference.instance, {x : -_parent.width, time : transitionDuration});
			}
			
			var addCurrentFunction:Function =
				function():void
				{
					if (_currentViewReference)
						_parent.removeChild(_currentViewReference.instance);

					// Adding current view to the stack
					_currentViewReference = new ViewReference(targetView, viewProps, context); 
					_views.push(_currentViewReference);
				};
			
			if (transition == ViewTransition.SLIDE)
			{
				// Tweening added view
				Tweener.addTween(targetView, 
					{
						x : 0, 
						time : transitionDuration, 
						onComplete : addCurrentFunction
					});
			}
			else
			{
				addCurrentFunction();
				targetView.x = 0;
			}
			
			// Returning pushed view
			return targetView;
		}
		
		public function popView(transition:String = "slide"):DisplayObject
		{
			var poppedView:DisplayObject;
			
			if (_views.length > 0)
			{
				var targetView:Object;
				if (_views.length > 1)
					targetView = _views[_views.length - 2].instance;
	
				if (_parent.dispatchEvent(new ViewNavigatorEvent(ViewNavigatorEvent.VIEW_CHANGING, ViewNavigatorAction.POP, currentView, targetView)))
					poppedView = vn_internal::popView(transition);
			}
			
			return poppedView;
		}
		
		vn_internal function popView(transition:String = "slide"):DisplayObject
		{
			var poppedViewReference:ViewReference = _currentViewReference;
			
			// Getting below view
			var targetViewReference:ViewReference;
			if (_views.length > 1)
				targetViewReference = _views[_views.length - 2];
			
			var removeCurrentFunction:Function = 
				function():void
				{
					// Removing top view from the stack
					_views.pop();
					// Removing view from parent
					_parent.removeChild(poppedViewReference.instance);
					
					// Setting context of popped view
					_poppedViewContext = poppedViewReference.context;
					
					// Getting popped view return object
					if (poppedViewReference.instance is IView)
						_poppedViewReturnedObject = 
							IView(poppedViewReference.instance).viewReturnObject;
					else
						_poppedViewReturnedObject = null;
				};
			
			if (transition == ViewTransition.SLIDE)
				// Tweening currentView to the right outside the screen
				Tweener.addTween(poppedViewReference.instance, 
					{
						x : _parent.width, 
						time : transitionDuration, 
						onComplete : removeCurrentFunction
					});
			else
				removeCurrentFunction();
			
			// If popped view is not the last one
			if (targetViewReference)
			{
				if (targetViewReference.instance is IView)
					IView(targetViewReference.instance).resize();
				
				_parent.addChild(targetViewReference.instance);
				if (transition == ViewTransition.SLIDE)
					// Tweening view from below
					Tweener.addTween(targetViewReference.instance, {x : 0, time : transitionDuration});
				else
					targetViewReference.instance.x = 0;
			}
			
			// Setting current view to target view
			_currentViewReference = targetViewReference;
			
			// Returning popped view
			return poppedViewReference.instance;
		}
		
		public function popToFirstView(transition:String = "slide"):DisplayObject
		{
			var topView:DisplayObject;
			if (_views.length > 1)
			{
				var targetView:Object = _views[0].instance;
				if (!_parent.dispatchEvent(new ViewNavigatorEvent(ViewNavigatorEvent.VIEW_CHANGING, ViewNavigatorAction.POP_TO_FIRST, currentView, targetView)))
					return null;
				
				// Removing views except the bottom and the top one
				if (_views.length > 2)
					_views.splice(1, _views.length - 2);
				
				// Poping top view to have nice transition
				topView = vn_internal::popView(transition);
			}
			return topView;
		}
		
		public function popAll(transition:String = "slide"):DisplayObject
		{
			var poppedView:DisplayObject;		
			if (_parent.dispatchEvent(new ViewNavigatorEvent(ViewNavigatorEvent.VIEW_CHANGING, ViewNavigatorAction.POP_ALL, currentView, null)))
			{
				// Removing views except the top one
				_views.splice(0, _views.length - 1);
				// Poping top view to have nice transition
				poppedView = vn_internal::popView(transition);
			}
			return poppedView;
		}
		
		public function replaceView(view:Object, viewProps:Object = null, context:Object = null, transition:String = "slide"):DisplayObject
		{
			var pushedView:DisplayObject;
			if (_parent.dispatchEvent(new ViewNavigatorEvent(ViewNavigatorEvent.VIEW_CHANGING, ViewNavigatorAction.REPLACE, currentView, view)))
			{
				// Pushing view on top of the stack
				pushedView = vn_internal::pushView(view, viewProps, context, transition);
				
				// Removing view below
				if (_views.length > 1)
					_views.splice(_views.length - 2, 1);
			}
			// Returning pushed view
			return pushedView;
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

		public function get firstViewTransition():String
		{
			return _firstViewTransition;
		}

		public function set firstViewTransition(value:String):void
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
		}
	}
}