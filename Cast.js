.pragma library
.import "Wen1.js" as W1
.import "Wen2.js" as W2
.import "Wen3.js" as W3
.import "Wen4.js" as W4

// King Wen lookup: bits are line 1 (bottom) → line 6 (top), yang=1 yin=0
var KING_WEN = {}

function loadPart(part) {
  if (!part) return
  for (var i = 0; i < part.length; i++) {
    var r = part[i]
    KING_WEN[r.b] = { n: r.n, name: r.name, pinyin: r.p, judgment: r.j, lines: r.l }
  }
}

loadPart(W1.PART)
loadPart(W2.PART)
loadPart(W3.PART)
loadPart(W4.PART)

function glyph(n) {
  return String.fromCodePoint(0x4DC0 + n - 1)
}

function coinLine() {
  var sum = 0
  for (var i = 0; i < 3; i++)
    sum += Math.random() < 0.5 ? 2 : 3
  return sum
}

function yarrowLine() {
  var n = Math.floor(Math.random() * 16)
  if (n === 0) return 6
  if (n < 6) return 7
  if (n < 13) return 8
  return 9
}

function isYang(v) { return v === 7 || v === 9 }
function isChanging(v) { return v === 6 || v === 9 }

function bitsOf(values, invertChanging) {
  var s = ""
  for (var i = 0; i < values.length; i++) {
    var y = isYang(values[i])
    if (invertChanging && isChanging(values[i])) y = !y
    s += y ? "1" : "0"
  }
  return s
}

function lookup(bits) {
  var h = KING_WEN[bits]
  if (!h) return { n: 0, name: "Unknown", pinyin: "", glyph: "?", judgment: "", lines: [] }
  return {
    n: h.n,
    name: h.name,
    pinyin: h.pinyin,
    glyph: glyph(h.n),
    judgment: h.judgment,
    lines: h.lines
  }
}

function cast(method) {
  var values = []
  for (var i = 0; i < 6; i++)
    values.push(method === "yarrow" ? yarrowLine() : coinLine())
  var primary = lookup(bitsOf(values, false))
  var changing = []
  for (var j = 0; j < 6; j++)
    if (isChanging(values[j])) changing.push(j + 1)
  var relating = changing.length ? lookup(bitsOf(values, true)) : null
  return {
    values: values,
    changing: changing,
    primary: primary,
    relating: relating
  }
}
