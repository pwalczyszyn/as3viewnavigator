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
	public interface IView
	{
		/**
		 * Launched before adding view ViewNavigator and when ViewNavigator size changes.
		 */
		function resize():void;
		
		/**
		 * Returns reference to parent navigator.
		 */
		function get navigator():IViewNavigator;
		/**
		 * Sets parent navigator.
		 */
		function set navigator(value:IViewNavigator):void;
		
		/**
		 * Returns view context object.
		 */
		function get context():Object;
		/**
		 * Sets view context object.
		 */
		function set context(value:Object):void;
		
		/**
		 * Returns view return object.
		 */
		function get viewReturnObject():Object;
		
		/**
		 * Returns view destruction policy, possible values auto and never.
		 * @see ViewDestructionPolicy
		 */
		function get destructionPolicy():String;
		
		/**
		 * Sets view destruction policy, possible values auto and never.
		 * @see ViewDestructionPolicy
		 */
		function set destructionPolicy(value:String):void;
	}
}