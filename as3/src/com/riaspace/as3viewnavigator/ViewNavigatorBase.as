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
		
		protected var _firstViewTransition:String;
		
		protected var _transitionDuration:Number = 0.5;
		
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
				pushView(_firstView, _firstViewProps, _firstViewContext, _firstViewTransition);
		}
		
		/**
		 * Returning top view from the stack
		 */
		public function get activeView():ViewReference
		{
			return _views.length > 0 ? _views[_views.length - 1] : null;
		}
		
		internal function resizeActiveView():void
		{
			var av:ViewReference = activeView;
			if (av && av.view && av.view is IView)
				IView(av.view).resize();
		}

		public function pushView(view:Object, viewProps:Object = null, context:Object = null, transition:String = "slide"):DisplayObject
		{
			var dispObj:DisplayObject;
			
			// If view is a Class instantiating it
			if (view is Class)
				dispObj = new view();
			else
				dispObj = DisplayObject(view);
			
			// if pushed view is an IView setting navigator reference
			if (dispObj is IView)
			{
				IView(dispObj).navigator = ViewNavigator(_parent);
				IView(dispObj).context = context;
				
				IView(dispObj).resize();
			}
			
			// Setting view properties
			for(var prop:String in viewProps)
				if (dispObj.hasOwnProperty(prop))
					dispObj[prop] = viewProps[prop];
			
			// Setting x position to the right outside the screen
			dispObj.x = _parent.width;
			// Setting y to the top of the screen
			dispObj.y = 0;
			
			// Adding view to the parent
			_parent.addChild(dispObj);
			
			var currentView:ViewReference;
			if (_views.length > 0)
			{
				// Getting current view from the stack
				currentView = _views[_views.length - 1];
				
				if (transition == ViewTransition.SLIDE)
					// Tweening currentView to the right outside the screen
					Tweener.addTween(currentView.view, {x : -_parent.width, time : transitionDuration});
			}
			
			if (transition == ViewTransition.SLIDE)
			{
				// Tweening added view
				Tweener.addTween(dispObj, 
					{
						x : 0, 
						time : transitionDuration, 
						onComplete:function():void
						{
							if (currentView)
								_parent.removeChild(currentView.view);
						}
					});
			}
			else
			{
				if (currentView)
					_parent.removeChild(currentView.view);
				dispObj.x = 0;
			}
			
			// Adding current view to the stack
			_views.push(new ViewReference(dispObj, context));
			
			// Returning pushed view
			return dispObj;
		}
		
		public function popView(transition:String = "slide"):DisplayObject
		{
			var currentView:ViewReference;
			if (_views.length > 0)
			{
				// Getting current view from the stack
				currentView = _views[_views.length - 1];
				
				// Getting below view
				var belowView:ViewReference;
				if (_views.length > 1)
					belowView = _views[_views.length - 2];
				
				var removeCurrentFunction:Function = 
					function():void
					{
						// Removing top view from the stack
						_views.pop();
						// Removing view from parent
						_parent.removeChild(currentView.view);
						
						// Setting context of popped view
						_poppedViewContext = currentView.context;
						
						// Getting popped view return object
						if (currentView is IView)
							_poppedViewReturnedObject = 
								IView(currentView.view).viewReturnObject;
						else
							_poppedViewReturnedObject = null;
					};
				
				if (transition == ViewTransition.SLIDE)
					// Tweening currentView to the right outside the screen
					Tweener.addTween(currentView.view, {x : _parent.width, time : transitionDuration, onComplete : removeCurrentFunction});
				else
					removeCurrentFunction();
				
				if (belowView)
				{
					if (belowView.view is IView)
						IView(belowView.view).resize();
					
					_parent.addChild(belowView.view);
					if (transition == ViewTransition.SLIDE)
						// Tweening view from below
						Tweener.addTween(belowView.view, {x : 0, time : transitionDuration});
					else
						belowView.view.x = 0;
				}
			}
			// Returning popped view
			return currentView.view;
		}
		
		public function popToFirstView(transition:String = "slide"):DisplayObject
		{
			var topView:DisplayObject;
			if (_views.length > 1)
			{
				// Removing views except the bottom and the top one
				if (_views.length > 2)
					_views.splice(1, _views.length - 2);
				
				// Poping top view to have nice transition
				topView = popView(transition);
			}
			return topView;
		}
		
		public function popAll(transition:String = "slide"):DisplayObject
		{
			// Removing views except the top one
			_views.splice(0, _views.length - 1);
			
			// Poping top view to have nice transition
			return popView(transition);
		}
		
		public function replaceView(view:Object, viewProps:Object = null, context:Object = null, transition:String = "slide"):DisplayObject
		{
			// Pushing view on top of the stack
			var dispObj:DisplayObject = pushView(view, viewProps, context, transition);
			
			// Removing view below
			if (_views.length > 1)
				_views.splice(_views.length - 2, 1);
			
			// Returning pushed view
			return dispObj;
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