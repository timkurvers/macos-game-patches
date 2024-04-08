# macOS Game Patches

Gaming on macOS has taken a massive leap over the last few years with the introduction of Apple Silicon, a
continued tremendous effort by CodeWeavers and other Wine contributors to rid us of Windows, but also Apple
themselves with the introduction of D3DMetal and other tools to assist game developers to port their games.

While we patiently wait for translation layers to get better, game developers to finally realize that the Mac
is a viable platform and game utopia to arrive, we need to concede that it can still be increasingly tricky to
get a game to run.

That said, some games **should** run fine, but do not for arbitrary reasons:

- Broken feature detection or graphics device inclusion / exlusion lists
- Incompatiblity with legacy macOS APIs
- Small unresolved issues in CrossOver / Wine
- Anti-cheat measures

Ultimately, the hope is for this repository to be completely empty, but here we are 😊

> [!NOTE]
>
> If a game requires heavy changes to internals such as D3DMetal, MoltenVK or Wine itself, it is out-of-scope
> for this repository. The same goes for usage of virtualization software such as Parallels or VMware Fusion.
>

## Available Patches

| Game                               | Why?                                      | Note
| ---------------------------------- | ----------------------------------------- | ------------------------- |
| [Jusant]                           | Incompatible DX12 feature detection       |
| ~~[Sea of Thieves]~~               | Xbox Live + game authentication issues    | [Easy Anti-Cheat] prevents game from running
| ~~[Tomb Raider I-III Remastered]~~ | macOS OpenGL incompatibility              | Fixed in CrossOver 24.0.1

## Tools & Techniques

- Reverse engineering / (dis)assembly:
  - [Binary Ninja](https://binary.ninja/)
  - [Hex Fiend](http://hexfiend.com/)

- Source code:
  - [CrossOver Source](https://www.codeweavers.com/crossover/source)
  - [Unreal Engine](https://docs.unrealengine.com/5.3/en-US/downloading-unreal-engine-source-code/) (requires sign-up)
  - [Chromium Embedded Framework](https://github.com/chromiumembedded/cef) (aka `libcef`, bane of our existence)

- Obfuscated game binaries:
  - Bridging `WineDbg`, `gdb` and `lldb` to dump memory (example to follow at a later date)

[Easy Anti-Cheat]: https://www.seaofthieves.com/release-notes/2.10.2
[Jusant]: jusant
[Sea of Thieves]: sea-of-thieves
[Tomb Raider I-III Remastered]: tomb-raider-I-III-remastered
