# sidecar-tahoe-toggle

Tired of digging through Control Center every time I wanted Sidecar? Every automation tool is broken on macOS Tahoe — AppleScript, Automator, all of it. Found a way to call Apple's private SidecarCore framework directly using Swift. No installs, no admin rights. One click toggle.

## Install

Open Terminal and run:
```bash
curl -s https://raw.githubusercontent.com/thejobot/sidecar-tahoe-toggle/main/install.sh | bash
```

It will ask for your iPad's name and set everything up automatically.

## Find your iPad's name

Settings → General → About → Name

## Make it one click

1. Open Script Editor (`/Applications/Utilities/Script Editor.app`)
2. Paste this:
```applescript
try
    set homePath to POSIX path of (path to home folder)
    do shell script "/usr/bin/swift " & homePath & "sidecar_toggle.swift"
end try
```
3. File → Export → File Format: Application
4. Name it something like "Sidecar Toggle" so you can find it easily in Spotlight, then save it to your Dock or Desktop
   
## Requirements

- macOS Tahoe 26
- iPad connected via USB
- Both devices on same Apple ID
- Swift (pre-installed on all Macs)

## Credit

SidecarCore API approach inspired by [SidecarLauncher](https://github.com/Ocasio-J/SidecarLauncher).
