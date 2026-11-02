import QtQuick
import Quickshell.Io
import qs.Common
import qs.Modules.Plugins
import qs.DCommon.Widgets

PluginComponent {
    id: root

    // Read plugin setting with an explicit default.
    property bool alwaysShowWhite: true

    Component.onCompleted: {
        const saved = getData("alwaysShowWhite", true)
        root.alwaysShowWhite = (saved === true || saved === "true")
        console.log("[GajimNotifier] loaded alwaysShowWhite:", root.alwaysShowWhite)
    }

    function toggleAlwaysShow() {
        alwaysShowWhite = !alwaysShowWhite
        console.log("[GajimNotifier] right click, alwaysShowWhite:", alwaysShowWhite)
        setData("alwaysShowWhite", alwaysShowWhite)
    }
    onAlwaysShowWhiteChanged: console.log("[GajimNotifier] alwaysShowWhite changed:", alwaysShowWhite)
    property bool unread: false
    property bool online: false
    property bool blinkOn: true
    property string activationPath: Qt.resolvedUrl("activate.sh").toString().replace(/^file:\/\//, "")
    property string scriptPath: Qt.resolvedUrl("watch.sh").toString().replace(/^file:\/\//, "")

    // Avoid spawning one persistent process for each widget illustration in the UI.
    Process {
        id: watchProcess
        command: ["sh", root.scriptPath]
        running: true
        stdout: SplitParser {
            onRead: line => {
                const state = line.trim()
                if (state === "unread") {
                    root.online = true
                    root.unread = true
                    root.blinkOn = true
                } else if (state === "read") {
                    root.online = true
                    root.unread = false
                    root.blinkOn = true
                } else if (state === "offline") {
                    root.online = false
                    root.unread = false
                    root.blinkOn = true
                }
            }
        }
    }

    Timer {
        id: blinkTimer
        interval: 700
        repeat: true
        running: root.unread && root.surfaceLive
        onTriggered: root.blinkOn = !root.blinkOn
        onRunningChanged: if (!running) root.blinkOn = true
    }

    Process {
        id: openGajim
        command: ["sh", root.activationPath]
    }

    function activate() {
        if (!openGajim.running)
            openGajim.running = true
    }

    horizontalBarPill: Component {
        Item {
            implicitWidth: root.iconSize + 12
            implicitHeight: root.iconSize + 8
            DIcon {
                anchors.centerIn: parent
                name: "mail"
                size: root.iconSize
                color: root.unread ? Theme.primary : "#ffffff"
                opacity: root.unread ? (root.blinkOn ? 1 : 0.12) : (root.alwaysShowWhite ? 1 : 0)
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: mouse => {
                    if (mouse.button === Qt.RightButton)
                        root.toggleAlwaysShow()
                    else
                        root.activate()
                }
            }
        }
    }

    verticalBarPill: Component {
        Item {
            implicitWidth: root.iconSize + 8
            implicitHeight: root.iconSize + 12
            DIcon {
                anchors.centerIn: parent
                name: "mail"
                size: root.iconSize
                color: root.unread ? Theme.primary : "#ffffff"
                opacity: root.unread ? (root.blinkOn ? 1 : 0.12) : (root.alwaysShowWhite ? 1 : 0)
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: mouse => {
                    if (mouse.button === Qt.RightButton)
                        root.toggleAlwaysShow()
                    else
                        root.activate()
                }
            }
        }
    }
}
