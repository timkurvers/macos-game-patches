# Sea of Thieves on macOS via CrossOver

This patch aims to address the following two issues:

1. The Xbox sign-in window crashes and/or is completely black.

2. Even making it past the Xbox sign-in, the game itself will struggle to authenticate and essentially go into
   a loop until eventually the dreaded 'Lavenderbeard' error appears.

The below script can patch both these issues, resulting in a playble game. Limited testing seems to indicate
decent performance with no connectivity issues.

Things remaining to test:

- [ ] Audio / voice chat
- [ ] Naval combat
- [ ] Actually meeting other players
- [ ] First-time sign-in for a Microsoft account
- [ ] Controller support?

> [!CAUTION]
>
> Our fellow Linux gamers using Proton seem to be running the game just fine through Wine and avoiding bans or
> other problems when sailing the high seas. Even if Rare's stance has been mild, this may change.
>
> The patch for CrossOver's credential management _**will affect all bottles**_ (and any games or apps therein). If
> you are unsure whether this may affect you, make sure to revert the patch once you are done trying Sea of Thieves.
>
> These are experimental changes to (small) parts of the game.
>
> **Please use at your own risk.**

## Screenshot

Game running on macOS through CrossOver 23.7.1 + D3DMetal:

<img width="768" alt="sea-of-thieves-macos" src="https://github.com/timkurvers/macos-game-patches/assets/378235/9d093925-06bb-4982-9aa1-b803606a1c8a">

<sup>~60fps @ 1440p with low quality settings on an M1 Pro</sup>

## Prerequisites

- Sea of Thieves (Steam version only)
- Microsoft account (this is a multiplayer game after all)
- CrossOver 23.7.1 or CrossOver 24.0.0

> [!NOTE]
>
> Enabling D3DMetal for Sea of Thieves under CrossOver 24.0.0 seems to crash the game. Will need some investigating.

## Instructions

1. Install Steam and Sea of Thieves in a (fresh) CrossOver 23.7.1 bottle
2. Download the `patch-sot.sh` file
3. Make it executable: `chmod +x patch-sot.sh`
4. Patch `libcef` which is used for the Xbox sign-in window:

   ```shell
   ./patch-sot.sh libcef <path/to/Sea of Thieves>
   ```

   Note: If you get the message `Found an unknown version of libcef.dll` then the script most likely needs updating. Sea of Thieves seems to alter `libcef.dll` slightly with each release.

5. Patch CrossOver's `advapi32` which contains seemingly bugged credential management:

   ```shell
   ./patch-sot.sh cx
   ```

   If you have installed `CrossOver.app` in a non-default location, pass it as an argument:

   ```shell
   ./patch-sot.sh cx <path/to/Crossover.app>
   ```

   If this fails with `Operation not permitted` temporarily grant Terminal full disk access under System Settings >
   Privacy & Security > Full Disk Access.

6. **Disable** both DXVK and D3DMetal for your CrossOver bottle temporarily
7. Restart the bottle / CrossOver
8. Boot Steam, launch Sea of Thieves and sign in

   Note: the sign-in window is still notoriously unstable: if it freezes, stop the game via Steam and try again.

9. Once signed in, you may have to skip the intro movie using `esc`
10. At this point: quit the game, swap back to D3DMetal for improved performance :partying_face:

> [!IMPORTANT]
>
> If you run into any potentially problematic behavior (the game glitching, account lockouts etc.) please
> leave a comment so that others are informed.

## Unpatching

Simply run the commands again to unpatch either `libcef` or `cx`.
