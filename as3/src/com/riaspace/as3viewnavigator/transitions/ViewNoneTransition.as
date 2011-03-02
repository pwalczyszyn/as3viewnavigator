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

package com.riaspace.as3viewnavigator.transitions
{
	import com.riaspace.as3viewnavigator.IViewNavigator;
	import com.riaspace.as3viewnavigator.IViewTransition;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class ViewNoneTransition implements IViewTransition
	{
		private var _navigator:IViewNavigator;
		
		private var _action:String;
		
		private var _hideView:DisplayObject;
		
		private var _showView:DisplayObject;
		
		private var _transitionDuration:Number;
		
		public function ViewNoneTransition(navigator:IViewNavigator)
		{
			_navigator = navigator;
		}
		
		public function play():void
		{
			var hv:DisplayObject = _hideView;
			var sv:DisplayObject = _showView;

			if (hv)
			{
				Sprite(_navigator).removeChild(hv);
			}
			
			if (sv)
			{
				sv.x = 0;
				Sprite(_navigator).addChild(sv);
			}
		}
		
		public function set navigator(value:IViewNavigator):void
		{
			_navigator = value;
		}
		
		public function set transitionDuration(value:Number):void
		{
			_transitionDuration = value;
		}
		
		public function get transitionDuration():Number
		{
			return _transitionDuration;
		}

		public function set action(value:String):void
		{
			_action = value;
		}
		
		public function set hideView(value:DisplayObject):void
		{
			_hideView = value;
		}
		
		public function set showView(value:DisplayObject):void
		{
			_showView = value;
		}

		public function get navigator():IViewNavigator
		{
			return _navigator;
		}

	}
}