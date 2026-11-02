import QtQuick
import qs.Common
import qs.Modules.Plugins
import qs.Widgets

PluginSettings {
    id: root
    pluginId: "gajimNotifier"

    ToggleSetting {
        settingKey: "alwaysShowWhite"
        label: "Weissen Umschlag dauerhaft anzeigen"
        description: "Bei neuen Nachrichten blinkt der Umschlag weiterhin."
        defaultValue: true
    }
}
