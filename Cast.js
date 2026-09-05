.pragma library

// King Wen lookup + oracles. Edit judgment/lines for your translation.
function glyph(n) { return String.fromCodePoint(0x4DC0 + n - 1) }
function coinLine() { var s=0; for (var i=0;i<3;i++) s += Math.random()<0.5?2:3; return s }
function yarrowLine() { var n=Math.floor(Math.random()*16); if(n===0)return 6; if(n<6)return 7; if(n<13)return 8; return 9 }
function isYang(v){ return v===7||v===9 }
function isChanging(v){ return v===6||v===9 }
function bitsOf(values, invert){ var s=""; for (var i=0;i<values.length;i++){ var y=isYang(values[i]); if(invert&&isChanging(values[i])) y=!y; s+= y?"1":"0" } return s }
function lookup(bits){ var h=KING_WEN[bits]; if(!h) return {n:0,name:"Unknown",pinyin:"",glyph:"?",judgment:"",lines:[]}; return {n:h.n,name:h.name,pinyin:h.pinyin,glyph:glyph(h.n),judgment:h.judgment,lines:h.lines} }
function cast(method){ var values=[]; for (var i=0;i<6;i++) values.push(method==="yarrow"?yarrowLine():coinLine()); var primary=lookup(bitsOf(values,false)); var changing=[]; for (var j=0;j<6;j++) if(isChanging(values[j])) changing.push(j+1); return {values:values,changing:changing,primary:primary,relating:changing.length?lookup(bitsOf(values,true)):null} }

// Full table is loaded from Texts.js so this file stays small for git.
Qt.include("Texts.js")
