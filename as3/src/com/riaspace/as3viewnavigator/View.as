package com.riaspace.as3viewnavigator
{
	import flash.display.Sprite;
	
	public class View extends Sprite implements IView
	{
		private var _navigator:IViewNavigator;
		
		private var _context:Object;
		
		private var _viewReturnObject:Object;
		
		private var _destructionPolicy:String = ViewDestructionPolicy.AUTO;

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