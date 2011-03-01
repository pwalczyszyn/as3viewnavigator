package com.riaspace.as3viewnavigator
{
	import spark.components.SkinnableContainer;
	
	public class View extends SkinnableContainer implements IView
	{
		private var _navigator:IViewNavigator;
		
		private var _context:Object;
		
		private var _viewReturnObject:Object;
		
		public function View()
		{
			super();
		}
		
		public function get context():Object
		{
			return _context;
		}
		
		public function set context(value:Object):void
		{
			_context = value;
		}
		
		public function get navigator():IViewNavigator
		{
			return _navigator;
		}
		
		public function set navigator(value:IViewNavigator):void
		{
			_navigator = value;
		}
		
		public function resize():void
		{
			width = navigator.width;
			height = navigator.height;
		}
		
		public function get viewReturnObject():Object
		{
			return _viewReturnObject;
		}
		
		protected function set viewReturnObject(value:Object):void
		{
			_viewReturnObject = value;
		}
	}
}