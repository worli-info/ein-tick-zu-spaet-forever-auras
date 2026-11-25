# EinTickZuSpaet Forever Auras

A standalone layout addon for **World of Warcraft: Forever (Interface 16001)**.
Arrange Blizzard's native buff and debuff displays without replacing their
buttons or scanning auras yourself.

**Stable release:** the addon has been confirmed working in a live Forever
client. Automated layout and localization tests also pass. Not every combat,
Edit Mode or resolution combination has been tested; please report any issues.

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

## Maintainer releases

The `Publish release` GitHub Actions workflow tests, packages and publishes a
pushed version tag to GitHub and CurseForge project **1830502**, targeting
**WoW Forever 1.60.1**. It uses the maintained BigWigs packager; third-party
actions are pinned to commits. The repository secret `CURSEFORGE_API_TOKEN`
holds the upload token. Never commit that token.

1. Update `## Version` in the TOC and add the version's changelog.
2. Commit and push the changes.
3. Create and push an annotated tag, for example:

```sh
git tag -a v0.1.1-beta.1 -m "v0.1.1-beta.1"
git push origin v0.1.1-beta.1
```

The TOC version for this example is `0.1.1`. `-alpha.N` tags upload as alpha;
`-beta.N` tags upload as beta. A plain tag such as `v0.1.1`
uploads as a regular release. The initial `v0.1.0` is an explicitly designated
early beta and was uploaded separately, without moving or recreating its tag.

CurseForge moderation can delay publication after a successful upload.
Running the workflow manually (`workflow_dispatch`) performs tests and a
packaging dry run without upload credentials; only pushed version tags publish.
Before retrying a failed publishing run, check both sites: an upload might
already have succeeded. Uploads are not transactionally idempotent across
GitHub and CurseForge. Do not force-push published version tags.
