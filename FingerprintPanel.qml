import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Popup {
    id: root
    property var service
    property color themeForeground: "#e8e5ec"
    property color themeBackground: "#1d1c20"
    property color themeUrgent: "#f0b7ad"
    property color surface: Qt.darker(themeBackground, 1.14)
    property color muted: Qt.darker(themeForeground, 1.55)
    signal dismissed()

    modal: false
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    width: 392
    height: content.implicitHeight + 32
    x: Math.max(16, (parent ? parent.width : 1440) - width - 24)
    y: 42
    padding: 0
    onClosed: dismissed()

    Keys.onPressed: event => {
        if (event.key === Qt.Key_R) {
            root.service.refresh()
            event.accepted = true
        }
    }

    background: Rectangle {
        radius: 14
        color: root.surface
        border.color: Qt.lighter(root.surface, 1.18)
        border.width: 1
    }

    contentItem: ColumnLayout {
        id: content
        width: root.width - 32
        spacing: 0

        Item { Layout.preferredHeight: 20 }

        RowLayout {
            Layout.fillWidth: true
            Text {
                text: "Fingerprint Studio"
                color: root.themeForeground
                font.pixelSize: 17
                font.weight: Font.DemiBold
                Layout.fillWidth: true
            }
            Button {
                text: "Esc"
                flat: true
                opacity: 0.72
                onClicked: root.close()
            }
        }

        Item { Layout.preferredHeight: 18 }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Text {
                text: root.service && root.service.ready ? "●" : root.service && root.service.state === "checking" ? "◌" : "●"
                color: root.service && root.service.ready ? root.themeForeground : root.service && root.service.state === "checking" ? root.themeForeground : root.themeUrgent
                font.pixelSize: 17
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 3
                Text {
                    text: root.service ? root.service.serviceState : "Checking hardware…"
                    color: root.themeForeground
                    font.pixelSize: 15
                    font.weight: Font.DemiBold
                }
                Text {
                    text: root.service ? root.service.deviceName : ""
                    color: root.muted
                    font.pixelSize: 12
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
            }
        }

        Item { Layout.preferredHeight: 14 }

        Text {
            text: root.service ? root.service.detail : ""
            color: root.muted
            font.pixelSize: 12
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Item { Layout.preferredHeight: 18 }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: Qt.lighter(root.surface, 1.18)
        }

        Item { Layout.preferredHeight: 14 }

        Text {
            text: "Agent-ready diagnostics"
            color: root.themeForeground
            font.pixelSize: 12
            font.weight: Font.DemiBold
        }
        Text {
            text: "Ask your Omarchy agent to diagnose Fingerprint Studio. It starts with a local, read-only health report."
            color: root.muted
            font.pixelSize: 12
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            Layout.topMargin: 4
        }

        Item { Layout.preferredHeight: 20 }

        RowLayout {
            Layout.fillWidth: true
            Text { text: root.service && root.service.lastUpdated ? "Updated " + root.service.lastUpdated + "  ·  R refresh" : ""; color: root.muted; font.pixelSize: 11; Layout.fillWidth: true }
            Button { text: "Refresh"; onClicked: root.service.refresh() }
            Button { text: "Evidence"; onClicked: Qt.openUrlExternally("https://github.com/uunicorn/python-validity/pull/256") }
        }

        Item { Layout.preferredHeight: 18 }
    }
}
