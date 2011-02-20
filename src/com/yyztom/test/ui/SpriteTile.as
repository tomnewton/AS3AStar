package com.yyztom.test.ui {
	import flash.events.MouseEvent;
	import flash.display.Sprite;

	/**
	 * @author tomnewton
	 */
	public class SpriteTile extends Sprite {
		
		public static const tileWidth : int = 5;
		public static const tileHeight : int = 5;
		
		private var _occupied : Boolean;
		private var _onPath : Boolean;
		
		public function SpriteTile( ) {
			
		}

		
		
		public function init() : void{
			drawEmptyTile();
		}
		
		
		public function set occupied ( v : Boolean ) : void {
			_occupied = v;
			
			if( _occupied ){
				drawOccupiedTile();
			}else{
				drawEmptyTile();
			}
		}

		public function get occupied () : Boolean {
			
			return _occupied;
		}
		
		public function get onPath() : Boolean {
			
			return _onPath;
		}
		
		
		public function drawForPath() : void {
			_onPath = true;
			fillWithColor(0x000000);
		}
		
		public function clearPath() : void {
			if ( _onPath ){
				
				drawEmptyTile();
				_onPath = false;
			}
		}
		
		public function drawWasEvaluated() : void {
			_onPath = true;
			fillWithColor(0x000000, .25);
			
		}
		
		public function drawAsCurrentPosition() : void {
			
			fillWithColor(0x00FF00);
		}

		public function drawEmptyTile() : void {
			
			this.graphics.clear();
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.lineStyle( 1, 0x000000);
			this.graphics.lineTo(tileWidth, 0);
			this.graphics.lineTo(tileWidth, tileWidth);
			this.graphics.lineTo(0, tileWidth);
			this.graphics.lineTo(0, 0);
			this.graphics.endFill();
			
		}
		
		private function fillWithColor( colour : uint , alpha : Number = 1) : void{
			
			this.graphics.clear();
			this.graphics.beginFill(colour, alpha);
			this.graphics.lineTo(tileWidth, 0);
			this.graphics.lineTo(tileWidth, tileWidth);
			this.graphics.lineTo(0, tileWidth);
			this.graphics.lineTo(0, 0);
			this.graphics.endFill();
			
		}
		
		
		private function drawOccupiedTile() : void {
			fillWithColor(0xFF0000);
			
		}
		
		
		
	}
}
