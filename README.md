# GajimNotifier for Dux Shell

A lightweight Dux Shell 2.x bar widget for Gajim XMPP messages.

When Gajim reports an unread message via its StatusNotifierItem D-Bus interface, a mail icon blinks in the active Dux Shell theme color. When messages are read, a white envelope can remain visible or be hidden.

## Features

- Event-driven updates using Gajim's `org.kde.StatusNotifierItem.NewIcon` D-Bus signal
- Unread messages: blinking mail icon (700 ms) in the Dux Shell theme color
- Read/no unread messages: optional persistent white envelope
- Left click: open/focus Gajim, including switching to MangoWM tag 5
- Right click: toggle persistent icon; setting is saved
- No changes to Gajim or Dux Shell required

## Requirements

- Dux Shell 2.0 or newer, including its plugin support
- Gajim with **system tray icon enabled** (needed to expose the StatusNotifierItem D-Bus interface)
- `busctl`, `dbus-monitor`, `stdbuf` (normally provided by systemd, dbus tools and coreutils)
- `mmsg` for MangoWM tag switching; `jq` for targeting an existing Gajim window

The activation script is **MangoWM-specific** and currently assumes that Gajim lives on **tag 5**. Edit `GajimNotifier/activate.sh` for a different tag or window manager.

## Install

Copy the `GajimNotifier` directory to:

```sh
mkdir -p ~/.config/dms/plugins
cp -r GajimNotifier ~/.config/dms/plugins/
dms ipc call plugins reload gajimNotifier
```

Enable the plugin and add its bar widget in Dux Shell's plugin settings.

## Hide Gajim's native tray entry

**Do not disable the tray icon in Gajim itself**: this also removes the D-Bus interface that powers this widget.

Instead, set `DMS_HIDE_TRAYIDS=org.gajim.Gajim` in the environment of the Dux Shell process. For example, if launching Dux Shell from MangoWM's `autostart.sh`:

```sh
DMS_HIDE_TRAYIDS=org.gajim.Gajim dms run -d &
```

Restart Dux Shell after changing the environment variable. This hides only the original tray entry, leaving Gajim's D-Bus signals available.

## Usage

- Left click: activate Gajim; on MangoWM, switch to tag 5 and focus its window
- Right click: toggle white envelope in the idle state
- Unread message: envelope blinks in the theme color

## Notes and limitations

- The indicator detects the specific Gajim icon name `gajim-status-message-new`. Changes to Gajim's indicator names may require an update.
- If Gajim's tray interface is disabled or Gajim exits, message updates are unavailable.
- The helper currently listens for `NewIcon`; process/service restarts may require reloading the plugin to re-establish monitoring.
- Tested by the original user on Arch Linux, MangoWM and Dux Shell Git 2.x with Gajim 2.6.0. No general compatibility guarantee.

## Version

0.1.7 – initial public-ready snapshot of the working prototype.

## License

License to be selected before public redistribution.
