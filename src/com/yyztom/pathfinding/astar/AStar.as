package com.yyztom.pathfinding.astar
{
	import flash.geom.Point;


	public class AStar
	{
		
		private var _openHeap : BinaryHeap;
		private var _touched : Vector.<AStarNodeVO>;
		private var _grid : Vector.<Vector.<AStarNodeVO>>;
		
		public function AStar( grid : Vector.<Vector.<AStarNodeVO>> ){
			_touched = new Vector.<AStarNodeVO>();
			_grid = grid;
		}
		
		
		
		/**
		 * 
		 * DEBUG ONLY.
		 */
		public function get evaluatedTiles () : Vector.<AStarNodeVO> {
			return _touched;
		}
		
		
		public function search(  start : AStarNodeVO, end:AStarNodeVO) : Vector.<AStarNodeVO> {
			
			if ( _openHeap ){
				var k : int = _touched.length-1;
				while ( k > -1 ){
					_touched[k].f=0;
					_touched[k].g=0;
					_touched[k].h=0;
					_touched[k].closed = false;
					_touched[k].visited = false;
					_touched[k].debug = "";
					_touched[k].parent = null;
					k--;
				}
				
				_touched = new Vector.<AStarNodeVO>();
				_openHeap.reset();
			}
			else{
				_openHeap = new BinaryHeap( function(node:AStarNodeVO):Number{return node.f;} );
			}
			
			_openHeap.push(start);
			
			
			while( _openHeap.size > 0 ){
				// Grab the lowest f(x) to process next.  Heap keeps this sorted for us.
				var currentNode : AStarNodeVO = _openHeap.pop();
				// End case -- result has been found, return the traced path
				
				if(currentNode.position.x == end.position.x && currentNode.position.y == end.position.y) {
					var curr : AStarNodeVO = currentNode;
					var ret : Vector.<AStarNodeVO> = new Vector.<AStarNodeVO>();
					while(curr.parent) {
						ret.push(curr);
						curr = curr.parent;
						
					}
					return ret.reverse();
				}
				
				// Normal case -- move currentNode from open to closed, process each of its neighbors
				currentNode.closed = true;
				_touched.push(currentNode);
				
				var neighbors : Vector.<AStarNodeVO> = neighbors(_grid, currentNode);
				var il : uint = neighbors.length;
				
				for(var i: int =0; i < il; i++) {
					
					var neighbor : AStarNodeVO = neighbors[i];
					
					if(neighbor.closed || neighbor.isWall) {
						// not a valid node to process, skip to next neighbor
						continue;
					}
					
					// g score is the shortest distance from start to current node, we need to check if
					//   the path we have arrived at this neighbor is the shortest one we have seen yet
					// 1 is the distance from a node to it's neighbor.  This could be variable for weighted paths.
					var gScore : Number = currentNode.g + 1;
					var beenVisited : Boolean = neighbor.visited;
					if ( !beenVisited ){
						_touched.push(neighbor);
					}
					if( beenVisited == false || gScore < neighbor.g) {
						
						// Found an optimal (so far) path to this node.  Take score for node to see how good it is.
						neighbor.visited = true;
						neighbor.parent = currentNode;
						neighbor.h = neighbor.h || manhattan(neighbor.position, end.position);
						neighbor.g = gScore;
						neighbor.f = neighbor.g + neighbor.h;
						//neighbor.debug = "F: " + neighbor.f + "<br />G: " + neighbor.g + "<br />H: " + neighbor.h;
						
						if (!beenVisited) {
							// Pushing to heap will put it in proper place based on the 'f' value.
							_openHeap.push(neighbor);
						}
						else {
							// Already seen the node, but since it has been rescored we need to reorder it in the heap
							_openHeap.rescoreElement(neighbor);
						}
					}
				}
			}
			
			// No result was found -- empty array signifies failure to find path
			return new Vector.<AStarNodeVO>();
		}
		
		
		
		private function neighbors( grid : Vector.<Vector.<AStarNodeVO>> , node : AStarNodeVO, allowDiagonal : Boolean = true ) : Vector.<AStarNodeVO> {
			var ret : Vector.<AStarNodeVO> = new Vector.<AStarNodeVO>();
			var x : Number = node.position.x;
			var y : Number = node.position.y;
			
			try{
				if( grid[x-1] && grid[x-1][y]) {
					ret.push(grid[x-1][y]);
				}
			}catch(e:ReferenceError){}catch(e:RangeError){}
			try{
				if(grid[x+1] && grid[x+1][y]) {
					ret.push(grid[x+1][y]);
				}
			}catch(e:ReferenceError){}catch(e:RangeError){}
			try{
				if(grid[x] && grid[x][y-1]) {
					ret.push(grid[x][y-1]);
				}
			}catch(e:ReferenceError){}catch(e:RangeError){}
			try{
				if(grid[x] && grid[x][y+1]) {
					ret.push(grid[x][y+1]);
				}
			}catch(e:ReferenceError){}catch(e:RangeError){}
			
			//diags
			//diags
            if ( allowDiagonal ){
				try{
					if ( !grid[x][y-1].isWall || !grid[x+1][y].isWall ){		
						ret.push(grid[x+1][y-1]); //up right
					}
				}catch(e:ReferenceError){}catch(e:RangeError){}
				try{
					if ( !grid[x+1][y].isWall || !grid[x][y+1].isWall ){
						ret.push(grid[x+1][y+1]); //down right
					}
				}catch(e:ReferenceError){}catch(e:RangeError){}
				try{
					if ( !grid[x-1][y].isWall || !grid[x][y+1].isWall ){
						ret.push( grid[x-1][y+1]  ); //down left
					}

				}catch(e:ReferenceError){}catch(e:RangeError){}
				try{
					if ( !grid[x-1][y].isWall || !grid[x][y-1].isWall ){
							ret.push( grid[x-1][y-1] );//up left
					}
				}catch(e:ReferenceError){}catch(e:RangeError){}
			}
			return ret;
		}
		
		
		private function manhattan( pos0 : Point, pos1 : Point ) : int{
			var d1 : uint = Math.abs( pos1.x - pos0.x );
			var d2 : uint = Math.abs( pos1.y - pos0.y );
			return d1 + d2;
		}
		
	}
}