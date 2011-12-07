﻿/** * <p>Original Author: Daniel Freeman</p> * * <p>Permission is hereby granted, free of charge, to any person obtaining a copy * of this software and associated documentation files (the "Software"), to deal * in the Software without restriction, including without limitation the rights * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell * copies of the Software, and to permit persons to whom the Software is * furnished to do so, subject to the following conditions:</p> * * <p>The above copyright notice and this permission notice shall be included in * all copies or substantial portions of the Software.</p> * * <p>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE * AUTHORS' OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN * THE SOFTWARE.</p> * * <p>Licensed under The MIT License</p> * <p>Redistributions of files must retain the above copyright notice.</p> */package asfiles {		import flash.utils.ByteArray;		public class Packet {				private const along:int=100;		public var ifrom:int;		public var jfrom:int;		public var ito:int;		public var jto:int;		public var copyifrom:int,copyito:int,copyjfrom:int,copyjto:int;		public var iid:int,jid:int;		public var capture:Array=new Array();		public var changed:Boolean=false;		public var min:Number,max:Number;		public var localdata:Array;		public var column:int=-1;				public var dbg:String=new String();								public function Packet(clone:Packet=null) {			if (clone!=null) {				ifrom=clone.ifrom;				jfrom=clone.jfrom;				ito=clone.ito;				jto=clone.jto;			}		}						public function load(ret:*,vals:Boolean=false):void {			var vlu:String;			var b0:int,b1:int,b2:int,b3:int;			selectcells(b0=ret.readUnsignedByte(),b1=ret.readUnsignedByte(),b2=ret.readUnsignedByte(),b3=ret.readUnsignedByte());			trace('reading bytes '+b0+' '+b1+' '+b2+' '+b3);			if (vals) {trace('reading local data...');				localdata=new Array();				for (var i:int=ifrom;i<=ito;i++) {					localdata[i-ifrom]=new Array();					for (var j:int=jfrom;j<=jto;j++) {						vlu=String(ret.readFloat());dbg=dbg+','+vlu;						localdata[i-ifrom][j-jfrom]=new Cell(null,0,0,vlu);						}					}				trace(dbg);				}		}						public function save(ret:*,fn:Function=null,vals:Boolean=true):void {			var i:int,j:int;			var cell:Cell;			ret.writeByte(ifrom);			ret.writeByte(jfrom);			ret.writeByte(ito);			ret.writeByte(jto);  trace('writing four bytes '+ifrom+' '+jfrom+' '+ito+' '+jto);			if (vals) {trace('writing data...');				if (fn!=null) {				for (i=ifrom;i<=ito;i++)					for (j=jfrom;j<=jto;j++) if ((cell=fn(i,j))==null || isNaN(cell.value)) {ret.writeFloat(0);trace('wFloat 0')} else {ret.writeFloat(cell.value);trace('wFloat '+cell.value)}				} else {				for (i=ifrom;i<=ito;i++)					for (j=jfrom;j<=jto;j++) if ((cell=readlocal(i-ifrom,j-jfrom))==null || isNaN(cell.value)) {ret.writeFloat(0);trace('wFloat 0')} else {ret.writeFloat(cell.value);trace('wFloat '+cell.value)}				}			}		}						public function readlocal(i:int,j:int):Cell {			var num:Number;			var str:String;			if (localdata[i] && (num = localdata[i][j]) is String) {				var cell:Cell = new Cell();				cell.setcell(num.toString());				localdata[i][j] = cell;				return cell;			}			else if (localdata[i] && (str = localdata[i][j]) is Number) {				var cell0:Cell = new Cell();				cell0.setcell(str);				localdata[i][j] = cell0;				return cell0;			}			else if (localdata[i]==null) return null; else return localdata[i][j];		}						public function setformat(frmt:String):void {			for (var i:int=ifrom;i<=ito;i++)				for (var j:int=jfrom;j<=jto;j++) localdata[i-ifrom][j-jfrom].numformat=frmt;		}						public function writecell(i:int,j:int,cell:Cell):void {			if (capture[j]==undefined) capture[j]=new Array();			capture[j][i]=cell;		}						public function readcell(i:int,j:int):Cell {			if (capture[j]==undefined) return null;			else if (capture[j][i]==undefined) return null; else return capture[j][i];		}				public function selectcells(ifrom:int,jfrom:int,ito:int,jto:int):void {			iid=this.ifrom=ifrom;jid=this.jfrom=jfrom;this.ito=ito;this.jto=jto;			if (column>=0) {this.jfrom=0;this.jto=column}			changed=false;		}		public function get datai():int {			return ito-ifrom+1;		}						public function get dataj():int {			return jto-jfrom+1;		}						public function moveidi(di:int):void {			var dj:int;			changed=false;			if (singlecell) {				if (ifrom+di<0) {selectcells(0,jfrom,0,jfrom);dj--} else if (ifrom+di>=along) {selectcells(ifrom+di-along,jfrom,ifrom+di-along,jfrom);dj++} else selectcells(ifrom+di,jfrom,ifrom+di,jfrom);				if (jfrom+dj<0) {selectcells(ifrom,0,ifrom,0);di=-1} else if (jfrom+dj>=along) {selectcells(ifrom,jfrom+dj-along,ifrom,jfrom+dj-along);di=1} else {selectcells(ifrom,jfrom+dj,ifrom,jfrom+dj);di=0}			} else {				if (iid+di<ifrom) {iid=iid+di+ito-ifrom+1;dj--} else if (iid+di>ito) {iid=iid+di-ito+ifrom-1;dj++} else iid+=di;				if (jid+dj<jfrom) {jid=jid+dj+jto-jfrom+1;di=-1} else if (jid+dj>jto) {jid=jid+dj-jto+jfrom-1;di=1}	else {jid+=dj;di=0}			}					}		public function moveidj(dj:int):void {			var di:int;			changed=false;			if (singlecell) {				if (jfrom+dj<0) {selectcells(ifrom,jfrom+dj+along,ifrom,jfrom+dj+along);di=-1} else if (jfrom+dj>=along) {selectcells(ifrom,jfrom+dj-along,ifrom,jfrom+dj-along);di=1} else {selectcells(ifrom,jfrom+dj,ifrom,jfrom+dj);di=0}				if (ifrom+di<0) {selectcells(ifrom+di+along,jfrom,ifrom+di+along,jfrom)} else if (ifrom+di>=along) {selectcells(ifrom+di-along,jfrom,ifrom+di-along,jfrom)} else selectcells(ifrom+di,jfrom,ifrom+di,jfrom);			} else {				if (jid+dj<jfrom) {jid=jid+dj+jto-jfrom+1;di=-1} else if (jid+dj>jto) {jid=jid+dj-jto+jfrom-1;di=1}	else {jid+=dj;di=0}						if (iid+di<ifrom) {iid=iid+di+ito-ifrom+1} else if (iid+di>ito) {iid=iid+di-ito+ifrom-1} else iid+=di;			}		}		public function get singlecell():Boolean {			return ito==ifrom && jto==jfrom;		}	}}