package 
com.yyztom.test.ui{
	import com.yyztom.pathfinding.astar.AStar;
	import com.yyztom.pathfinding.astar.AStarNodeVO;
	import com.yyztom.test.event.DemoEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	public class Demo extends Sprite
	{
		private static const NUM_TILES : int = 100;
		private static var PROB : Number = .1;
		
		private var _grid : Vector.<Vector.<SpriteTile>>;
		private var _aStarNodes : Vector.<Vector.<AStarNodeVO>>;
		private var _currentPos : Point;
		private var _astar : AStar;
		
		
		
		public function Demo( density : Number  )
		{
			Demo.PROB = density;
			_currentPos = new Point(0,0);
			createGrid();
			
		}
	
		
		/**
		 * Create your the tiles.
		 */
		private function createGrid() : void {
			
			_grid = new Vector.<Vector.<SpriteTile>>();
			
			var i : int = 0;
			var j : int = 0;
			
			while ( i < NUM_TILES ){
				_grid[i] = new Vector.<SpriteTile>();
				
				while ( j < NUM_TILES ){
					var tile : SpriteTile = new SpriteTile();
					_grid[i][j] = tile;
					tile.init();
					this.addChild(tile);
					tile.x = i*SpriteTile.tileWidth;
					tile.y = j*SpriteTile.tileHeight;
					
					tile.addEventListener(MouseEvent.CLICK, handle_click);
					if ( (i == 0 && j == 0) == false ){
						tile.occupied = isOccupied();
					}
						
					j++;
				}
				
				j = 0;
				i++;
			}
			
			initNodesForAStar();
			
			_currentPos = new Point(0,0);
			_grid[0][0].drawAsCurrentPosition();
		}

		
		
		private function handle_click(e : MouseEvent) : void {
			
			clearPathTiles();
						
			var x : int = SpriteTile(e.currentTarget).x/SpriteTile.tileWidth;
			var y : int = SpriteTile(e.currentTarget).y/SpriteTile.tileHeight;
			
			
			if( !_astar ){
				_astar = new AStar(_aStarNodes);
			}
			
			if ( _aStarNodes[x][y].isWall ){
				return;
			}
			
			
			var t : Number = getTimer();
			
			//search.
			var result : Vector.<AStarNodeVO> = _astar.search(_aStarNodes[_currentPos.x][_currentPos.y], _aStarNodes[x][y]);
			var time : Number = getTimer()-t;
			
			dispatchEvent( new DemoEvent(DemoEvent.ASTAR_TIME, time) );
			
			
			for each ( var node2:AStarNodeVO in _astar.evaluatedTiles ){
				
				_grid[node2.position.x][node2.position.y].drawWasEvaluated();
			}
			
			for each ( var node:AStarNodeVO in result ){
				
				_grid[node.position.x][node.position.y].drawForPath();
			}
			
			
			_grid[_currentPos.x][_currentPos.y].drawForPath();
			if ( result.length > 1 ){
				_currentPos = result[result.length-1].position;
			}
			_grid[_currentPos.x][_currentPos.y].drawAsCurrentPosition();
		}
		
		
		
		
		
		
		/**
		 * Create the aStarNodes to represent the tiles.
		 * Only needs to be done once.
		 */
		private function initNodesForAStar() : void {
			_aStarNodes = new Vector.<Vector.<AStarNodeVO>>();
			var _previousNode : AStarNodeVO;
			
			var x : uint = 0;
			var z : uint = 0;
			
			while ( x < _grid.length ) {
				_aStarNodes[x] = new Vector.<AStarNodeVO>();
				
				while ( z < _grid[x].length ){
					var isoTile : SpriteTile = _grid[x][z];
					var node :AStarNodeVO  = new AStarNodeVO();
					node.next = _previousNode;
					node.h = 0;
					node.f = 0;
					node.g = 0;
					node.visited = false;
					node.parent = null;
					node.closed = false;
					node.isWall = isoTile.occupied;
					node.position = new Point(x, z);
					_aStarNodes[x][z]  = node;
					_previousNode = node;
					
					z++;
				}
				z=0;
				x++;
			}
			
		}
		
		
	
		
		private function isOccupied () : Boolean {
			var ran : Number = Math.random();
			
			if ( ran < Demo.PROB ){
				
				return true;
			}
			return false;
		}
		
		
		private function clearPathTiles() : void {
			
			var i : int = 0;
			var j : int = 0;
			
			while ( i < NUM_TILES ){

				
				while ( j < NUM_TILES ){
					
					_grid[i][j].clearPath();
						
					j++;
				}
				
				j = 0;
				i++;
			}
		}
		
	}
}
