#!/bin/sh
# Emit one line per relevant Gajim StatusNotifier icon change.
# Gajim's state is read from DBus; no persistent polling.
export LC_ALL=C
status() {
    value=$(busctl --user get-property org.gajim.Gajim /StatusNotifierItem \
        org.kde.StatusNotifierItem IconName 2>/dev/null) || {
        printf 'offline\n'
        return
    }
    case "$value" in
        *'gajim-status-message-new'*) printf 'unread\n' ;;
        *) printf 'read\n' ;;
    esac
}
status
# Watcher uses the well-known bus name, rather than a transient :1.N identity.
# stderr suppressed to avoid spamming logs if Gajim is not launched yet.
stdbuf -oL dbus-monitor --session \
  "type='signal',sender='org.gajim.Gajim',path='/StatusNotifierItem',interface='org.kde.StatusNotifierItem',member='NewIcon'" 2>/dev/null |
while IFS= read -r line; do
    case "$line" in
        *'member=NewIcon'*) status ;;
    esac
done
