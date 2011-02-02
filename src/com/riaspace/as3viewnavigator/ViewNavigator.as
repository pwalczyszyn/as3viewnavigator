//////////////////////////////////////////////////////////////////////////////////////
//
//	Copyright 2011 Piotr Walczyszyn
//	
//	This file is part of as3viewnavigator.
//
//	as3viewnavigator is free software: you can redistribute it and/or modify
//	it under the terms of the GNU General Public License as published by
//	the Free Software Foundation, either version 3 of the License, or
//	(at your option) any later version.
//	
//	as3viewnavigator is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU General Public License for more details.
//	
//	You should have received a copy of the GNU General Public License
//	along with as3viewnavigator.  If not, see <http://www.gnu.org/licenses/>.
//
//////////////////////////////////////////////////////////////////////////////////////

package com.riaspace.as3viewnavigator
{
	import caurina.transitions.Tweener;
	
	import flash.display.Sprite;
	import flash.events.Event;

	public class ViewNavigator
	{
		protected var parent:Sprite;
		
		protected var views:Vector.<Sprite> = new Vector.<Sprite>;
		
		protected var _poppedViewReturnedObject:Object;
		
		/**
		 * Views transition duration, default value is 0.5s.
		 */
		public var transitionTime:Number = 0.5;
		
		/**
		 * ViewNavigator constructor, it accepts one parameter with a parent sprite.
		 * 
		 * @param parent - parent application sprite.
		 */
		public function ViewNavigator(parent:Sprite)
		{
			this.parent = parent;
			parent.addEventListener(Event.ADDED_TO_STAGE, parent_addedToStageHandler);
		}
		
		protected function parent_addedToStageHandler(event:Event):void
		{
			parent.removeEventListener(Event.ADDED_TO_STAGE, parent_addedToStageHandler);
			parent.stage.addEventListener(Event.RESIZE, stage_resizeHandler);
		}

		protected function stage_resizeHandler(event:Event):void
		{
			for each(var view:Sprite in views)
			{
				view.width = parent.stage.stageWidth;
				view.height = parent.stage.stageHeight; 
			}
		}

		/**
		 * Adds view container on top of the stack. 
		 * 
		 * If added view implements IView interface it will also inject the reference to
		 * this navigator instance.
		 * 
		 * @see com.riaspace.as3viewnavigator.IView
		 * 
		 * @param view - Sprite to add
		 */
		public function pushView(view:Sprite):void
		{
			// if pushed view is an IView setting navigator reference
			if (view is IView)
				IView(view).navigator = this;
			
			// Setting size of the added view
			view.width = parent.stage.stageWidth; 
			view.height = parent.stage.stageHeight;
			
			// Getting width of the stage
			var stageWidth:Number = parent.stage.stageWidth;
			
			// Setting x position to the right outside the screen
			view.x = stageWidth;
			// Setting y to the top of the screen
			view.y = 0;
			
			// Adding view to the parent
			parent.addChild(view);
			
			var currentView:Sprite;
			if (views.length > 0)
			{
				// Getting current view from the stack
				currentView = views[views.length - 1]
				// Tweening currentView to the right outside the screen
				Tweener.addTween(currentView, {x : -stageWidth, time : transitionTime});
			}
			
			// Tweening added view
			Tweener.addTween(view, 
				{
					x : 0, 
					time : transitionTime, 
					onComplete:function():void
					{
						if (currentView)
							parent.removeChild(currentView);
					}
				});
			// Adding current view to the stack
			views.push(view);
		}
		
		/**
		 * Pops current view from the top of the stack.
		 */
		public function popView():void
		{
			// Getting width of the stage
			var stageWidth:Number = parent.stage.stageWidth;

			var currentView:Sprite;
			if (views.length > 0)
			{
				// Getting current view from the stack
				currentView = views[views.length - 1];
				
				// Getting below view
				var belowView:Sprite;
				if (views.length > 1)
					belowView = views[views.length - 2];
				
				// Tweening currentView to the right outside the screen
				Tweener.addTween(currentView, 
					{
						x : stageWidth, 
						time : transitionTime, 
						onComplete:function():void
						{
							views.pop();
							parent.removeChild(currentView);
							
							if (currentView is IView)
								_poppedViewReturnedObject = 
									IView(currentView).viewReturnObject;
							else
								_poppedViewReturnedObject = null;
						}
					});
				
				// Tweening view from below
				if (belowView)
				{
					parent.addChild(belowView);
					Tweener.addTween(belowView, {x : 0, time : transitionTime});
				}
			}
		}
		
		/**
		 * Pops to the first view from the very top.
		 */
		public function popToFirstView():void
		{
			if (views.length > 1)
			{
				// Removing views except the bottom and the top one
				if (views.length > 2)
					views.splice(1, views.length - 2);
				
				// Poping top view to have nice transition
				popView();
			}
		}
		
		/**
		 * Pops all views from the stack.
		 */
		public function popAll():void
		{
			// Removing views except the top one
			views.splice(0, views.length - 1);
			// Poping top view to have nice transition
			popView();
		}
		
		/**
		 * Replaces view with the one passed as parameter.
		 * 
		 * @param view - new view.
		 */
		public function replaceView(view:Sprite):void
		{
			pushView(view);
			if (views.length > 1)
				views.splice(views.length - 2, 1);
		}
		
		/**
		 * Returns object value returned by popped view. 
		 * View has to implement IView interface in order to have this value returned.
		 */
		public function get poppedViewReturnedObject():Object
		{
			return _poppedViewReturnedObject;
		}
		
		/**
		 * Returns number of views managed by this navigator.
		 */
		public function get length():int
		{
			return views.length;
		}
	}
}