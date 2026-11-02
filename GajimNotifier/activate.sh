#!/bin/sh
# Activate an existing Gajim window on MangoWM, instead of just starting Gajim.
if command -v mmsg >/dev/null 2>&1; then
    # Gajim is normally on tag 5 in this user's setup.
    mmsg dispatch view,5 >/dev/null 2>&1 || true
    if command -v jq >/dev/null 2>&1; then
        id=$(mmsg get all-clients 2>/dev/null | jq -r '
          (if type == "array" then . else (.clients // []) end)
          | map(select(((.app_id // .appid // .class // .initialClass // "") | ascii_downcase) | contains("gajim")))
          | first | (.id // .address // empty)' 2>/dev/null)
        if [ -n "$id" ] && [ "$id" != null ]; then
            mmsg dispatch focusid "client,$id" >/dev/null 2>&1 && exit 0
        fi
    fi
fi
# If no existing window was found, ask Gajim to open/activate itself.
exec gajim
