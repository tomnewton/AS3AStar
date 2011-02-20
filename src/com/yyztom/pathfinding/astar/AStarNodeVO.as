package com.yyztom.pathfinding.astar
{
	import flash.geom.Point;
	
	public class AStarNodeVO
	{
		
		public var h : int;
		public var f : int;
		public var g : int;
		public var visited : Boolean;
		public var closed : Boolean;
		public var isWall : Boolean;
		public var position : Point;
		public var debug : String;
		public var parent : AStarNodeVO;
		public var next : AStarNodeVO;
		
		public function AStarNodeVO( )
		{
		}
	}
}