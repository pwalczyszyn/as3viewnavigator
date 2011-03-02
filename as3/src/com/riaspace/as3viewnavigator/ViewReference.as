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
	
	internal class ViewReference
	{
		private var _navigator:IViewNavigator;
		
		private var _instance:DisplayObject;
		
		private var _viewProps:Object;
		
		private var _context:Object;
		
		private var _viewClass:Class;
		
		public function ViewReference(navigator:IViewNavigator, view:Object, viewProps:Object, context:Object)
		{
			_navigator = navigator;
			_viewProps = viewProps;
			_context = context;
			
			if (view is Class)
			{
				_viewClass = Class(view);
				_instance = create();
			}
			else
			{
				_viewClass = Object(view).constructor;
				_instance = DisplayObject(view);
			}
		}
		
		private function create():DisplayObject
		{
			var result:DisplayObject = new _viewClass();
			
			// if pushed view is an IView setting navigator reference
			if (result is IView)
			{
				IView(result).navigator = _navigator;
				IView(result).context = context;
				
				IView(result).resize();
			}
			
			// Setting view properties
			for(var prop:String in viewProps)
				if (result.hasOwnProperty(prop))
					result[prop] = viewProps[prop];
			
			return result;
		}

		public function destroyInstance():void
		{
			if (_instance && _instance is IView)
				IView(_instance).navigator = null;
			
			_instance = null;
		}
		
		public function get instance():DisplayObject
		{
			if (_instance)
				return _instance;
			else
				return _instance = create();
		}

		public function get viewProps():Object
		{
			return _viewProps;
		}

		public function get viewClass():Class
		{
			return _viewClass;
		}

		public function get context():Object
		{
			return _context;
		}
	}
}