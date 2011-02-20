package com.yyztom.test.event{
	import flash.events.Event;

	/**
	 * @author tomnewton
	 */
	public class DemoEvent extends Event {
		public static const ASTAR_TIME : String = "AstarTime";
		
		public var time : Number;
		
		public function DemoEvent(type : String, time : Number = 0, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			this.time = time;
		}
	}
}
