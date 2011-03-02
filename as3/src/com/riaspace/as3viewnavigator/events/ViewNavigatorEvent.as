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

package com.riaspace.as3viewnavigator.events
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class ViewNavigatorEvent extends Event
	{
		public static const VIEW_CHANGING:String = "viewChanging";

		public var action:String;
		
		public var oldView:DisplayObject;
		
		public var newView:DisplayObject;
		
		public function ViewNavigatorEvent(type:String, action:String, oldView:DisplayObject, newView:DisplayObject, bubbles:Boolean=false, cancelable:Boolean=true)
		{
			super(type, bubbles, cancelable);
			
			this.action = action;
			this.oldView = oldView;
			this.newView = newView;
		}
		
		override public function clone():Event
		{
			return new ViewNavigatorEvent(type, action, oldView, newView, bubbles, cancelable);
		}
	}
}