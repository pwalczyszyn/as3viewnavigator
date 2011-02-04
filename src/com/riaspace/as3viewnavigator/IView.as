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
	public interface IView
	{
		function get navigator():ViewNavigator;
		function set navigator(value:ViewNavigator):void;
		
		function get context():Object;
		function set context(value:Object):void;
		
		function get viewReturnObject():Object;
	}
}