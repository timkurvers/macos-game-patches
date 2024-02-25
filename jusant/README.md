# Jusant on macOS + D3DMetal

Jusant seems to have added an additional requirements check on top of the default one in Unreal Engine 5,
which prevents the game from launching on macOS using D3DMetal.

The below script patches the binary, seemingly resulted in a playable game (limited testing).

> [!WARNING]
>
> Please use at your own risk.

## Screenshot

Game running on macOS through CrossOver 23.7 + D3DMetal:

<img width="768" alt="jusant-macos" src="https://gist.github.com/assets/378235/f5ef58d2-e1c3-431a-a04c-1cbd3c67589f">

## Instructions

1. Download the file below as `patch-jusant.sh`
2. Make it executable: `chmod +x patch-jusant.sh`
3. Run it: `./patch-jusant.sh <path/to/ASC-Win64-Shipping.exe>`
