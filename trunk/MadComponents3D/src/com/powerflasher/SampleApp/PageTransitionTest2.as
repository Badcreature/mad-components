/**
 * <p>Original Author: Daniel Freeman</p>
 *
 * <p>Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:</p>
 *
 * <p>The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.</p>
 *
 * <p>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.</p>
 *
 * <p>Licensed under The MIT License</p>
 * <p>Redistributions of files must retain the above copyright notice.</p>
 */

package com.powerflasher.SampleApp {
	import flash.trace.Trace;
	
	[SWF(frameRate="60", backgroundColor="#FFFFFF")]	

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;	
	import com.danielfreeman.madcomponents.*;
	import com.danielfreeman.stage3Dacceleration.*;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	import flash.events.MouseEvent;
	

	public class PageTransitionTest2 extends Sprite {
		
		protected static const CLICK_TIME:int = 500;
		protected static const CLICK_DELTA:Number = 0.2;
				
		[Embed(source="images/buddha.jpg")]
		protected static const BUDDHA:Class;
		
		[Embed(source="images/dragon.jpg")]
		protected static const DRAGON:Class;
		
		[Embed(source="images/faces.jpg")]
		protected static const FACES:Class;
		
		[Embed(source="images/monks.jpg")]
		protected static const MONKS:Class;
		
		
		protected static function latin(colour:String):XML {
		
			return <label width="400"><font color={colour}/>
				Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
			</label>;
		}
		
		
		protected static function makePage(image:Class, pageColour:uint, buttonColour:uint, textColour:String = "#666666"):XML { 

			return <vertical colour={buttonColour} background={pageColour}>
				<vertical alignH="centre" alignV="centre">
					<label><font size="40" color={textColour}/>Demo: To change page swipe left or right</label>
					<label/>
					<horizontal>
						<image>{getQualifiedClassName(image)}</image>
						{latin(textColour)}
					</horizontal>
					<button width="100">one</button>
					<button width="100">two</button>
					<button width="100">three</button>					
				</vertical>
			</vertical>;
		}
		
		
		protected static const LAYOUT:XML =
		
			<pages id="pages">
				{makePage(BUDDHA, 0xCCCCCC, 0x339933)}
				{makePage(DRAGON, 0x336633, 0x339933, "#CCCCCC")}
				{makePage(FACES, 0xCCCCFF, 0x993333)}
				{makePage(MONKS, 0x333366, 0x996633, "#CCCCCC")}			
			</pages>;


		protected var _layout:Sprite;
		protected var _pages:UIPages;
		protected var _clickTime:int;		
		protected var _pageTransitions:PageTransitions;
		protected var _clickX:Number;
		protected var _pageNumber:int = 0;


		public function PageTransitionTest2(screen:Sprite = null) {
			if (screen)
				screen.addChild(this);

			stage.align = StageAlign.TOP_LEFT;  
			stage.scaleMode = StageScaleMode.NO_SCALE;

			_layout = UI.create(this, LAYOUT);			
			_pages = UIPages(UI.findViewById("pages"));
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			
			addEventListener(Stage3DAcceleration.CONTEXT_COMPLETE, contextComplete);
			Stage3DAcceleration.startStage3D(this);
		}
		
		
		protected function mouseDown(event:MouseEvent):void {
			_clickTime = getTimer();
			_clickX = mouseX;
		}
		
		
		protected function mouseUp(event:MouseEvent):void { // primitive swipe detection
			if (getTimer() - _clickTime < CLICK_TIME && Math.abs(mouseX - _clickX) > stage.stageWidth * CLICK_DELTA) {
				var lastPage:int = _pages.pageNumber;
				var newPage:int;
				var transition:String;
				if (mouseX - _clickX > 0) {
					 newPage = lastPage + 1;
					 if (newPage >= _pages.pages.length) {
						newPage = 0;
					 }
					 transition = PageTransitions.ZOOM_LEFT;
				}
				else {
					newPage = lastPage - 1;
					 if (newPage < 0) {
						newPage = _pages.pages.length - 1;
					 }
					 transition = PageTransitions.ZOOM_RIGHT;
				}
				_pageTransitions.goToPage(_pages, newPage);
				_pageTransitions.pageTransition(_pages.pages[newPage], _pages.pages[lastPage], transition);
			}
		}


		protected function contextComplete(event:Event):void {
			_pageTransitions = new PageTransitions();
        }
	}
}
