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
	import spark.components.SkinnableContainer;
	
	/**
	 * This is an IView implementation class (from as3viewnavigator library), it can used 
	 * in Flex desktop projects as base class for application views.
	 * 
	 * @author Piotr Walczyszyn
	 */
	public class View extends SkinnableContainer implements IView
	{
		private var _navigator:IViewNavigator;
		
		private var _context:Object;
		
		private var _viewReturnObject:Object;
		
		private var _destructionPolicy:String = ViewDestructionPolicy.AUTO;
		
		/**
		 * Default constructor.
		 */
		public function View()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get context():Object
		{
			return _context;
		}
		/**
		 * @inheritDoc
		 */
		public function set context(value:Object):void
		{
			_context = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get navigator():IViewNavigator
		{
			return _navigator;
		}
		/**
		 * @inheritDoc
		 */
		public function set navigator(value:IViewNavigator):void
		{
			_navigator = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function resize():void
		{
			width = navigator.width;
			height = navigator.height;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get viewReturnObject():Object
		{
			return _viewReturnObject;
		}
		
		/**
		 * @inheritDoc
		 */
		protected function set viewReturnObject(value:Object):void
		{
			_viewReturnObject = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get destructionPolicy():String
		{
			return _destructionPolicy;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set destructionPolicy(value:String):void
		{
			_destructionPolicy = value;
		}
	}
}