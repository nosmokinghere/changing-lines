# Changing Lines

Bar widget for [Omarchy Quattro](https://github.com/basecamp/omarchy). Click **I Ching** on the bar, then **Generate hexagrams**. Six lines are cast with the three-coin method. Every old line (6 or 9) inverts to form the relating hexagram.

## Install

```sh
omarchy plugin add https://github.com/nosmokinghere/changing-lines.git --enable
omarchy bar put solfredag.changing-lines '{"section":"right"}'
```

Needs [Noto Sans Symbols 2](https://fonts.google.com/noto/specimen/Noto+Sans+Symbols+2) for the hexagram glyphs:

```sh
sudo pacman -S noto-fonts
fc-cache -f
omarchy restart shell
```

## Use

- Left-click the bar mark to open the panel
- **Generate hexagrams** casts a new reading
- Primary figure is the situation now; relating figure is what it tends toward
- Moving-line oracles print under the judgments

## Files

| File | Role |
| --- | --- |
| `manifest.json` | `bar-widget` contract |
| `BarWidget.qml` | Label on the bar |
| `Panel.qml` | Dropdown |
| `Cast.js` | Coin / yarrow odds and King Wen lookup |
| `Wen1.js`–`Wen4.js` | Names, judgments, and line texts (64 hexagrams) |

Edit the `Wen*.js` tables to use your own translation. After a QML change run `omarchy restart shell` (Quattro caches bar-widget QML).

## License

MIT

## Remove

```sh
omarchy bar remove solfredag.changing-lines
omarchy plugin remove solfredag.changing-lines
```
