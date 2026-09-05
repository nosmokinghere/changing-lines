import QtQuick
import QtQuick.Controls
import Quickshell
import qs.Commons
import qs.Ui
import "Cast.js" as Cast

Panel {
  id: root
  moduleName: "solfredag.changing-lines"
  manageIpc: false

  property var anchorItem: null
  property var hostWidget: null
  property var reading: null
  readonly property string hexFontName: hexFont.status === FontLoader.Ready ? hexFont.name : "Noto Sans Symbols 2"

  function open() { root.controller.show() }
  function close() { root.controller.hide() }
  function switchPanel(direction) {
    if (root.bar && typeof root.bar.switchPanelFrom === "function")
      root.bar.switchPanelFrom(root.hostWidget || root, direction)
    return false
  }

  function generate() {
    reading = Cast.cast("coins")
    if (root.hostWidget && reading)
      root.hostWidget.lastValues = reading.values
  }

  function lineLabel(v) {
    if (v === 6) return "old yin"
    if (v === 7) return "young yang"
    if (v === 8) return "young yin"
    if (v === 9) return "old yang"
    return ""
  }

  function barFor(value, invert) {
    var yang = (value === 7 || value === 9)
    var moving = (value === 6 || value === 9)
    if (invert && moving) yang = !yang
    return yang ? "=========" : "==== ===="
  }

  function lineOracle(pos) {
    if (!root.reading || !root.reading.primary || !root.reading.primary.lines)
      return ""
    return root.reading.primary.lines[pos - 1] || ""
  }

  FontLoader {
    id: hexFont
    source: "file:///usr/share/fonts/noto/NotoSansSymbols2-Regular.ttf"
  }

  KeyboardPanel {
    id: panel
    anchorItem: root.anchorItem
    owner: root.hostWidget || root
    bar: root.bar
    open: root.opened
    focusTarget: keyCatcher
    contentWidth: panel.fittedContentWidth(Style.space(360))
    contentHeight: panel.fittedContentHeight(content.implicitHeight)

    PanelKeyCatcher {
      id: keyCatcher
      anchors.fill: parent
      onCloseRequested: root.close()
      onTabRequested: function(direction) { root.switchPanel(direction) }

      Column {
        id: content
        width: parent.width
        spacing: Style.space(8)

        Text {
          width: parent.width
          text: "Changing Lines"
          color: root.barForeground
          font.family: root.bar ? root.bar.fontFamily : Style.font.family
          font.pixelSize: Style.font.caption
        }

        Rectangle {
          width: parent.width
          height: 36
          radius: 8
          color: root.barForeground
          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: root.generate()
          }
          Text {
            anchors.centerIn: parent
            text: "Generate hexagrams"
            color: root.bar && root.bar.background ? root.bar.background : "#14130f"
            font.family: root.bar ? root.bar.fontFamily : Style.font.family
            font.pixelSize: Style.font.body
            font.bold: true
          }
        }

        Text {
          visible: !root.reading
          width: parent.width
          wrapMode: Text.WordWrap
          text: "Six lines from the bottom. Changing lines invert into the relating hexagram."
          color: root.barForeground
          opacity: 0.7
          font.family: root.bar ? root.bar.fontFamily : Style.font.family
          font.pixelSize: Style.font.caption
        }

        Column {
          visible: !!root.reading
          width: parent.width
          spacing: Style.space(10)

          Row {
            width: parent.width
            spacing: 16

            Column {
              width: (parent.width - 16) / 2
              spacing: 6

              Text {
                text: "Now"
                color: root.barForeground
                opacity: 0.65
                font.family: root.bar ? root.bar.fontFamily : Style.font.family
                font.pixelSize: Style.font.caption
              }

              Text {
                text: root.reading ? root.reading.primary.glyph : ""
                color: root.barForeground
                font.family: root.hexFontName
                font.pixelSize: 72
              }

              Text {
                width: parent.width
                wrapMode: Text.WordWrap
                color: root.barForeground
                font.family: root.bar ? root.bar.fontFamily : Style.font.family
                font.pixelSize: Style.font.body
                font.bold: true
                text: root.reading ? (root.reading.primary.n + ". " + root.reading.primary.name) : ""
              }
            }

            Column {
              width: (parent.width - 16) / 2
              spacing: 6

              Text {
                text: "Becomes"
                color: root.barForeground
                opacity: 0.65
                font.family: root.bar ? root.bar.fontFamily : Style.font.family
                font.pixelSize: Style.font.caption
              }

              Text {
                visible: !!(root.reading && root.reading.relating)
                text: (root.reading && root.reading.relating) ? root.reading.relating.glyph : ""
                color: root.barForeground
                font.family: root.hexFontName
                font.pixelSize: 72
              }

              Text {
                width: parent.width
                wrapMode: Text.WordWrap
                color: root.barForeground
                opacity: 0.8
                font.family: root.bar ? root.bar.fontFamily : Style.font.family
                font.pixelSize: Style.font.body
                font.bold: true
                text: {
                  if (!root.reading) return ""
                  if (!root.reading.relating) return "No moving lines."
                  return root.reading.relating.n + ". " + root.reading.relating.name
                }
              }
            }
          }

          Text {
            width: parent.width
            wrapMode: Text.WordWrap
            color: root.barForeground
            font.family: root.bar ? root.bar.fontFamily : Style.font.family
            font.pixelSize: Style.font.body
            text: root.reading ? root.reading.primary.judgment : ""
          }

          Text {
            visible: !!(root.reading && root.reading.relating)
            width: parent.width
            wrapMode: Text.WordWrap
            color: root.barForeground
            opacity: 0.8
            font.family: root.bar ? root.bar.fontFamily : Style.font.family
            font.pixelSize: Style.font.caption
            text: root.reading && root.reading.relating
              ? ("Becomes — " + root.reading.relating.judgment)
              : ""
          }

          Repeater {
            model: root.reading ? root.reading.values : []
            delegate: Column {
              width: content.width
              spacing: 2
              visible: modelData === 6 || modelData === 9

              Text {
                width: parent.width
                color: root.barForeground
                font.family: root.bar ? root.bar.fontFamily : Style.font.family
                font.pixelSize: Style.font.caption
                text: root.barFor(modelData, false) + "  line " + (index + 1) + "  " + root.lineLabel(modelData)
              }

              Text {
                width: parent.width
                wrapMode: Text.WordWrap
                color: root.barForeground
                font.family: root.bar ? root.bar.fontFamily : Style.font.family
                font.pixelSize: Style.font.body
                text: root.lineOracle(index + 1)
              }
            }
          }
        }
      }
    }
  }
}
