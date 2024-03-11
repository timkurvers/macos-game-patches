# Jusant on macOS + D3DMetal

Jusant seems to have added an additional requirements check on top of the default one in Unreal Engine 5,
which prevents the game from launching on macOS using D3DMetal.

The below script patches the binary, seemingly resulted in a playable game (limited testing).

> [!WARNING]
>
> Please use at your own risk.

## Screenshot

Game running on macOS through CrossOver 23.7 + D3DMetal:

<img width="768" alt="jusant-macos" src="https://github.com/timkurvers/macos-game-patches/assets/378235/dddd284f-b4f1-4fd3-b8e1-34d4ee0ab18c">

## Instructions

1. Download the `patch-jusant.sh` file
2. Make it executable: `chmod +x patch-jusant.sh`
3. Run it: `./patch-jusant.sh <path/to/ASC-Win64-Shipping.exe>`

## Configuration

Check out MacProTips' [video on Jusant](https://www.youtube.com/watch?v=3kp2wA1NaC8) for configuration tips.
