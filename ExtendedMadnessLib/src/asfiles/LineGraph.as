﻿/** * <p>Original Author: Daniel Freeman</p> * * <p>Permission is hereby granted, free of charge, to any person obtaining a copy * of this software and associated documentation files (the "Software"), to deal * in the Software without restriction, including without limitation the rights * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell * copies of the Software, and to permit persons to whom the Software is * furnished to do so, subject to the following conditions:</p> * * <p>The above copyright notice and this permission notice shall be included in * all copies or substantial portions of the Software.</p> * * <p>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE * AUTHORS' OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN * THE SOFTWARE.</p> * * <p>Licensed under The MIT License</p> * <p>Redistributions of files must retain the above copyright notice.</p> */package asfiles {		import flash.display.Sprite;//	import flash.ui.Mouse;	import flash.events.MouseEvent;	import flash.text.TextFieldAutoSize;	import flash.utils.ByteArray;	public class LineGraph extends GraphPalette {		private var lines:Array=new Array();					public function LineGraph(screen:Sprite,xx:int,yy:int,select:Packet,ss:*=null) {		iam=2;super(screen,xx,yy,select,ss);	//	controls=new GraphControls(this,frame/2,frame/2,'line graph',false,false,swap=(datai>1 && dataj>1));		clearlines();		resize(wdth,hght);	//	controls.addEventListener(MouseEvent.CLICK,controlsclick);		}					//	private function controlsclick(ev:MouseEvent):void {	//		if (ev.target==controls.swapbtn) {swap=!swap;clearlines()}	//		else if (ev.target==controls.legendbtn) {	//			legend.visible=!legend.visible;	//			extra=legend.visible ? legend.width : 0;	//			redraw(lcolour);	//			}	//		gridbehind();	//		bgredraw();	//	}		private function cellvalue(i:int,j:int):Number {			var cell:Cell=readcell(i,j);			if (cell==null) return 0; else return cell.value;		}						private function clearlines():void {			for (var i:int=0;i<lines.length;i++) grph.removeChild(lines[i]);			lines=new Array();		}				override public function bgredraw():void {			var cell:Cell;			var wdth:Number;			var i:int,j:int;clearlines();			if (no<2) trace('bargraph error! no='+no)			else {				if (swap) {					if (dataj==1) {						wdth=mywidth/(datai-1);						if (lines[0]==undefined) lines[0]=new Line(grph,this);						lines[0].moveto(colour(0),soffset,wdth,shght,readcell(0,0));						for (i=1;i<datai;i++) lines[0].lineto(i,readcell(i,0));					} else {						for (i=0;i<datai;i++) {							wdth=mywidth/(dataj-1);							if (lines[i]==undefined) lines[i]=new Line(grph,this);							lines[i].moveto(colour(i),soffset,wdth,shght,readcell(i,0));							for (j=1;j<dataj;j++) lines[i].lineto(j,readcell(i,j));							}					}				} else {					if (datai==1) {						wdth=mywidth/(dataj-1);						if (lines[0]==undefined) lines[0]=new Line(grph,this);						lines[0].moveto(colour(0),soffset,wdth,shght,readcell(0,0));						for (j=1;j<dataj;j++) lines[0].lineto(j,readcell(0,j));					} else {						for (j=0;j<dataj;j++) {							wdth=mywidth/(datai-1);							if (lines[j]==undefined) lines[j]=new Line(grph,this);							lines[j].moveto(colour(j),soffset,wdth,shght,readcell(0,j));							for (i=1;i<datai;i++) lines[j].lineto(i,readcell(i,j));						}					}				}			}		}	}}