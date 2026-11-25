# EinTickZuSpaet Forever Auras

A standalone layout addon for **World of Warcraft: Forever (Interface 16001)**.
Arrange Blizzard's native buff and debuff displays without replacing their
buttons or scanning auras yourself.

**Early beta:** automated tests pass, but live-client visual, combat, Edit Mode
and resolution testing is still pending. Back up your settings before testing.

## Features

- Vertical columns or horizontal rows, with configurable wrapping and spacing.
- Separate buff/debuff offsets and shared scaling.
- Native timers, tooltips and right-click cancellation remain in Blizzard's UI.
- Debuffs align with buff icons below Blizzard's collapse/expand control.
- Account-wide settings; German interface on `deDE`, English everywhere else.
- Combat-safe deferred positioning and restoration when disabled.
- No dependency on PitBull, SexyMap, a viewport addon or any private layout addon.

## Installation

1. Download the installation ZIP from [Releases](https://github.com/worli-info/ein-tick-zu-spaet-forever-auras/releases).
2. Extract `EinTickZuSpaetForeverAuras` into `_forever_/Interface/AddOns/`.
3. Fully restart WoW after adding the new addon folder.
4. Open `/fba`, `/etzsauras`, or the addon's entry in WoW Settings.

Use the release ZIP, not GitHub's source-code archive, for the correct directory
name. No other addons are required.

## Configuration

Configure outside combat, then click **Apply** (German: **Übernehmen**).
Options include enabling positioning, orientation, icons per column/row,
spacing, scale and right/top offsets for both displays.

Defaults: vertical, 12 icons per column, 6-pixel spacing, scale 1,
buffs right 16/top 45 and debuffs right 112/top 45. Debuff top offsets are
relative to the buff icon baseline, not Blizzard's collapse button.
Additional columns/rows are managed by Blizzard; no custom aura limit is added.

Unchecking positioning and applying restores the native layout captured before
activation. Other addons or Edit Mode can change the native layout again.
Do not enable a second addon that also arranges these same frames.

### Deutsch

Mit `/fba` oder `/etzsauras` öffnest du die Einstellungen. Die Oberfläche ist
auf deutschen Clients deutsch, auf allen anderen englisch. Position, Größe,
Abstände und Spalten-/Zeilenrichtung gelten für alle Charaktere.
Nach einer Neuinstallation WoW vollständig neu starten.

## Development

Run the standalone mock tests with Lua 5.1:

```sh
lua5.1 tests/test-auras.lua .
luac5.1 -p Auras.lua
luac5.1 -p Options.lua
luac5.1 -p Locales.lua
```

The tests cover locale fallback, native layout reuse, wrapping configuration,
scale-aware anchors, restoration, combat deferral and settings preservation.
They do not replace live-client testing.

## License

MIT. Author: **olqs**. Not affiliated with Blizzard Entertainment.
